report 85006 "Cal _Bin Replenishment New"
{
    Caption = 'Calculate Bin Replenishment';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Replenishment Master"; "Replenishment Master")
        {
            DataItemTableView = sorting("Item No.", "Variant Code") order(descending);
            RequestFilterFields = "Item No.", "Variant Code";

            trigger OnAfterGetRecord()
            begin
                //Calculate Available To Take Quantity++
                Clear(Availabletotake);
                Availabletotake := CodeUnit_ReplenishmentWorksheet.TotalAvailabletoTake("Replenishment Master"."Item No.", "Replenishment Master"."Variant Code", LocationCode);
                if Availabletotake <= 0 then
                    Availabletotake := 0;

                //Calculate Last 2 weekday quantity from Transfer line++
                Clear(TransferLineQty);
                TransferLineQty := CodeUnit_ReplenishmentWorksheet.CheckExitingQtyInTransferLineFromToLocation("Replenishment Master"."Item No.", "Replenishment Master"."Variant Code", LocationCode);
                if TransferLineQty <= 0 then
                    TransferLineQty := 0;

                //Check RemainQtyToReplenishBase (Demand Qty)+++
                Clear(RemainQtyToReplenishBase);
                RemainQtyToReplenishBase := "Replenishment Master"."Max Depot1 Qty" - Availabletotake - TransferLineQty;
                if RemainQtyToReplenishBase <= 0 then
                    RemainQtyToReplenishBase := 0;

                //+++++
                if "Replenishment Master"."Min Depot1 Qty" > Availabletotake then begin
                    if RemainQtyToReplenishBase > 0 then
                        ReplenishBin("Replenishment Master");
                end;
            end;

            trigger OnPostDataItem()
            begin
                if not InsertWhseWkshLine() then
                    if not HideDialog then
                        Message(Text000);
            end;

            trigger OnPreDataItem()
            begin
                //Filter++
                SetFilter("Min Depot1 Qty", '>%1', 0);
                SetFilter("Max Depot1 Qty", '>%1', 0);

                //Set record++
                SetWhseWorksheet(WhseWkshTemplateName, WhseWkshName, LocationCode);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(WorksheetTemplateName; WhseWkshTemplateName)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Template Name';
                        TableRelation = "Whse. Worksheet Template";
                        ToolTip = 'Specifies the name of the template that applies to the movement lines.';
                        Editable = false;

                        trigger OnValidate()
                        begin
                            if WhseWkshTemplateName = '' then
                                WhseWkshName := '';
                        end;
                    }
                    field(WorksheetName; WhseWkshName)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Batch Name';
                        Editable = false;
                    }
                    field(LocCode; LocationCode)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Location Code';
                        TableRelation = Location;
                        Editable = false;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        L_RepelinshmentWorksheet: Record "Replenishment Worksheet";
    begin
        //Delete the record++
        L_RepelinshmentWorksheet.Reset();
        L_RepelinshmentWorksheet.SetRange("Batch Name", WhseWkshName);
        if L_RepelinshmentWorksheet.FindSet() then
            L_RepelinshmentWorksheet.DeleteAll();
    end;

    var
        WhseWorksheetName: Record "Whse. Worksheet Name";
        Text000: Label 'There is nothing to replenish.';
        WhseWkshTemplateName: Code[10];
        WhseWkshName: Code[10];
        HideDialog: Boolean;
        LocationCode: Code[10];
        Bin: Record Bin;
        MustNotBeErr: Label 'must not be %1.', Comment = '%1 - field value';
        TempReplenishmentWorksheet: Record "Replenishment Worksheet" temporary; //Dont remove Temp property++
        BinType: Record "Bin Type";
        RemainQtyToReplenishBase: Decimal;
        NextLineNo: Integer;
        CodeUnit_ReplenishmentWorksheet: Codeunit "Replenishment Worksheet";
        TransferLineQty: Decimal;
        Availabletotake: Decimal;

    procedure InitializeRequest(WhseWkshTemplateName2: Code[10]; WhseWkshName2: Code[10]; LocationCode2: Code[10]; HideDialog2: Boolean)
    begin
        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2;
        HideDialog := HideDialog2;
    end;


    procedure ReplenishBin(_ToReplenishment: Record "Replenishment Master")
    begin
        //Create Temporary record+++
        FindReplenishmtBin(_ToReplenishment);
    end;

    procedure FindReplenishmtBin(_ToReplenishment: Record "Replenishment Master")
    var
        FromBinContent: Record "Bin Content";
        QtyAvailToTakeBase: Decimal;
        MovementQtyBase: Decimal;
        ReplenishmentWorksheet2: Record "Replenishment Worksheet";
        L_TransferLineQty: Decimal;
    begin
        FromBinContent.Reset();
        FromBinContent.SetRange("Item No.", _ToReplenishment."Item No.");
        FromBinContent.SetRange("Variant Code", _ToReplenishment."Variant Code");
        FromBinContent.SetFilter("Quantity (Base)", '>%1', 0);
        //FromBinContent.SetRange("Location Code", 'IP3');
        FromBinContent.SetFilter("Location Code", '%1|%2', 'IP3', 'IP4');
        FromBinContent.SetCurrentKey("Location Code");
        FromBinContent.Ascending(true);
        if FromBinContent.Find('-') then begin
            ReplenishmentWorksheet2.Copy(TempReplenishmentWorksheet);
            TempReplenishmentWorksheet.SetCurrentKey("Item No.", "From Bin Code", "Location Code", "Variant Code");
            TempReplenishmentWorksheet.SetRange("Item No.", FromBinContent."Item No.");
            TempReplenishmentWorksheet.SetRange("From Location Code", FromBinContent."Location Code");
            TempReplenishmentWorksheet.SetRange("Variant Code", FromBinContent."Variant Code");
            repeat
                //Check Blocke Movemet and Restricted Bin++
                if UseForReplenishment(FromBinContent) then begin

                    //Calculate Available Tock Qty from Location per Bin+++
                    Clear(QtyAvailToTakeBase);
                    QtyAvailToTakeBase := FromBinContent.CalcQtyAvailToTakeUOM();
                    if QtyAvailToTakeBase <= 0 then
                        QtyAvailToTakeBase := 0;


                    //Calculate Tranfer Line Qty lat 2 working days+++
                    Clear(L_TransferLineQty);
                    L_TransferLineQty := CodeUnit_ReplenishmentWorksheet.CheckExitingQtyInTransferLineforFromLocation("Replenishment Master"."Item No.", "Replenishment Master"."Variant Code", FromBinContent."Location Code", FromBinContent."Bin Code");
                    if L_TransferLineQty <= 0 then
                        L_TransferLineQty := 0;

                    //+++
                    TempReplenishmentWorksheet.SetRange("From Bin Code", FromBinContent."Bin Code");
                    TempReplenishmentWorksheet.CalcSums("Qty to Move");
                    QtyAvailToTakeBase := QtyAvailToTakeBase - L_TransferLineQty - TempReplenishmentWorksheet."Qty to Move";
                    if QtyAvailToTakeBase <= 0 then
                        QtyAvailToTakeBase := 0;

                    //+++
                    if QtyAvailToTakeBase > 0 then begin
                        if QtyAvailToTakeBase < RemainQtyToReplenishBase then
                            MovementQtyBase := QtyAvailToTakeBase
                        else
                            MovementQtyBase := RemainQtyToReplenishBase;
                        CreateReplenishmentWorksheet(_ToReplenishment, FromBinContent, MovementQtyBase);
                        RemainQtyToReplenishBase := RemainQtyToReplenishBase - MovementQtyBase;
                    end;
                end;
            until (FromBinContent.Next() = 0) or (RemainQtyToReplenishBase = 0);
            TempReplenishmentWorksheet.Copy(ReplenishmentWorksheet2);
        end;
    end;

    procedure GetVariantSetup(_ItemNo: Code[20]): Boolean
    var
        L_ItemVariant: Record "Item Variant";
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", _ItemNo);
        if L_Item.FindFirst() then begin
            if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                if L_Item."Variant Mandatory if Exists" = L_Item."Variant Mandatory if Exists"::Yes then
                    exit(true)
                else begin
                    L_ItemVariant.Reset();
                    L_ItemVariant.SetRange("Item No.", _ItemNo);
                    if L_ItemVariant.FindFirst() then
                        exit(true)
                    else
                        exit(false);
                end;
            end else
                exit(false);
        end;
    end;

    procedure UseForReplenishment(FromBinContent: Record "Bin Content"): Boolean
    begin
        if FromBinContent."Block Movement" in
           [FromBinContent."Block Movement"::Outbound,
            FromBinContent."Block Movement"::All]
        then
            exit(false);

        // GetBinType(FromBinContent."Bin Type Code");
        // exit(not (BinType.Receive or BinType.Ship));
        exit(CheckExcludeBin(FromBinContent));
    end;

    // procedure GetBinType(BinTypeCode: Code[10])
    // begin
    //     if BinTypeCode = '' then
    //         BinType.Init()
    //     else
    //         if BinType.Code <> BinTypeCode then
    //             BinType.Get(BinTypeCode);
    // end;

    procedure CheckExcludeBin(FromBinContent: Record "Bin Content"): Boolean
    var
        L_Bin: Record Bin;
    begin
        L_Bin.Reset();
        L_Bin.SetRange("Location Code", FromBinContent."Location Code");
        L_Bin.SetRange(Code, FromBinContent."Bin Code");
        if L_Bin.FindFirst() then
            if L_Bin."Exclude from free Qty." = true then
                exit(false)
            else
                exit(true)
    end;

    procedure CreateReplenishmentWorksheet(_ToReplenishment: Record "Replenishment Master"; FromBinContent: Record "Bin Content"; MovementQtyBase: Decimal)
    var
        L_Item: Record Item;
    begin
        TempReplenishmentWorksheet.Init();
        TempReplenishmentWorksheet."Posting Date" := WorkDate();
        TempReplenishmentWorksheet."Template Name" := WhseWkshTemplateName;
        TempReplenishmentWorksheet."Batch Name" := WhseWkshName;
        TempReplenishmentWorksheet."Location Code" := _ToReplenishment."Location Code";
        TempReplenishmentWorksheet."From Location Code" := FromBinContent."Location Code";
        TempReplenishmentWorksheet."From Bin Code" := FromBinContent."Bin Code";
        TempReplenishmentWorksheet."Line No." := NextLineNo;
        TempReplenishmentWorksheet."Item No." := _ToReplenishment."Item No.";
        L_Item.Reset();
        L_Item.SetRange("No.", _ToReplenishment."Item No.");
        if L_Item.FindFirst() then begin
            TempReplenishmentWorksheet.Description := L_Item.Description;
            TempReplenishmentWorksheet."Top Category" := L_Item."Top Category";
        end;
        TempReplenishmentWorksheet."Variant Code" := _ToReplenishment."Variant Code";
        TempReplenishmentWorksheet."Min. Qty." := _ToReplenishment."Min Depot1 Qty";
        TempReplenishmentWorksheet."Max. Qty." := _ToReplenishment."Max Depot1 Qty";
        TempReplenishmentWorksheet."System Quantity" := Availabletotake;
        TempReplenishmentWorksheet."Demand Quantity" := _ToReplenishment."Max Depot1 Qty" - Availabletotake - TransferLineQty;
        TempReplenishmentWorksheet."Qty to Move" := MovementQtyBase;
        TempReplenishmentWorksheet.Insert();

        NextLineNo := NextLineNo + 10000;
    end;

    procedure SetWhseWorksheet(WhseWkshTemplateName2: Code[10]; WhseWkshName2: Code[10]; LocationCode2: Code[10])
    var
        ReplenishmentWorksheet: Record "Replenishment Worksheet";
    begin
        //Delete Temp+++
        Clear(TempReplenishmentWorksheet);
        TempReplenishmentWorksheet.DeleteAll();


        ReplenishmentWorksheet.SetRange("Template Name", WhseWkshTemplateName2);
        ReplenishmentWorksheet.SetRange("Batch Name", WhseWkshName2);
        ReplenishmentWorksheet.SetRange("Location Code", LocationCode2);
        if ReplenishmentWorksheet.FindLast() then
            NextLineNo := ReplenishmentWorksheet."Line No." + 10000
        else
            NextLineNo := 10000;

        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2;
    end;

    procedure InsertWhseWkshLine() Result: Boolean
    var
        Replenishmentworksheet: Record "Replenishment Worksheet";
    begin
        TempReplenishmentWorksheet.Reset();
        TempReplenishmentWorksheet.SetFilter("Demand Quantity", '>0');
        TempReplenishmentWorksheet.SetCurrentKey("From Location Code");
        TempReplenishmentWorksheet.Ascending(true);
        if TempReplenishmentWorksheet.Find('-') then begin
            repeat
                Replenishmentworksheet.Reset();
                Replenishmentworksheet.SetRange("From Location Code", TempReplenishmentWorksheet."From Location Code");
                Replenishmentworksheet.SetRange("Posting Date", TempReplenishmentWorksheet."Posting Date");
                Replenishmentworksheet.SetRange("Item No.", TempReplenishmentWorksheet."Item No.");
                if not Replenishmentworksheet.FindFirst() then begin
                    Replenishmentworksheet.Init();
                    Replenishmentworksheet := TempReplenishmentWorksheet;
                    Replenishmentworksheet.Insert();
                end else begin
                    Replenishmentworksheet."Qty to Move" := Replenishmentworksheet."Qty to Move" + TempReplenishmentWorksheet."Qty to Move";
                    Replenishmentworksheet.Modify();
                end;
            until TempReplenishmentWorksheet.Next() = 0;
            exit(true);
        end;
        exit(false);
    end;
}

