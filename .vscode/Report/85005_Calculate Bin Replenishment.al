report 85005 "Calculate _Bin Replenishment"
{
    Caption = 'Calculate Bin Replenishment';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bin Content"; "Bin Content")
        {
            DataItemTableView = sorting("Location Code", "Item No.", "Variant Code") order(descending);
            RequestFilterFields = "Bin Code", "Item No.";

            trigger OnAfterGetRecord()
            begin
                if "Bin Content"."Min. Qty." > "Bin Content".CalcQtyAvailToTakeUOM() then begin
                    // "Bin Content".CalcFields("Daily Priority Exist");
                    // if "Bin Content"."Daily Priority Exist" = GetVariantSetup("Bin Content"."Item No.") then
                    ReplenishBin("Bin Content");
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
                SetRange("Location Code", LocationCode);
                SetFilter("Min. Qty.", '>%1', 0);


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

    procedure InitializeRequest(WhseWkshTemplateName2: Code[10]; WhseWkshName2: Code[10]; LocationCode2: Code[10]; HideDialog2: Boolean)
    begin
        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2;
        HideDialog := HideDialog2;
    end;


    procedure ReplenishBin(ToBinContent: Record "Bin Content")
    begin
        //Check Bin Code Block Or Not+++
        if BinBlockedInbound(ToBinContent."Location Code", ToBinContent."Bin Code") then
            Bin.FieldError("Block Movement", StrSubstNo(MustNotBeErr, Bin."Block Movement"));

        // //Check replenish required or not++
        // if not NeedToReplenish(ToBinContent) then
        //     exit;

        //Create Temporary record+++
        FindReplenishmtBin(ToBinContent);
    end;

    // procedure NeedToReplenish(ToBinContent: Record "Bin Content") Result: Boolean
    // begin
    //     Clear(RemainQtyToReplenishBase);
    //     ToBinContent.CalcFields("Quantity (Base)");
    //     if ToBinContent."Quantity (Base)" < ToBinContent."Max. Qty." then begin
    //         RemainQtyToReplenishBase := ToBinContent."Max. Qty." - ToBinContent."Quantity (Base)";
    //         exit(true)
    //     end else begin
    //         exit(false);
    //     end;
    // end;

    local procedure BinBlockedInbound(LocationCode2: Code[10]; BinCode2: Code[20]) Blocked: Boolean
    begin
        GetBin(LocationCode2, BinCode2);
        Blocked := Bin."Block Movement" in
          [Bin."Block Movement"::Inbound, Bin."Block Movement"::All];
        exit(Blocked);
    end;

    local procedure GetBin(LocationCode2: Code[10]; BinCode2: Code[20])
    begin
        if (Bin."Location Code" <> LocationCode2) or
           (Bin.Code <> BinCode2)
        then
            Bin.Get(LocationCode2, BinCode2);
    end;

    procedure FindReplenishmtBin(ToBinContent: Record "Bin Content")
    var
        FromBinContent: Record "Bin Content";
        ReplenishmentWorksheet2: Record "Replenishment Worksheet";
        QtyAvailToTakeBase: Decimal;
        MovementQtyBase: Decimal;
    begin
        //Calculate RemainQtyToReplenishBase Qty+++
        Clear(RemainQtyToReplenishBase);
        RemainQtyToReplenishBase := ToBinContent."Max. Qty." - ToBinContent.CalcQtyAvailToTakeUOM();

        FromBinContent.Reset();
        FromBinContent.SetRange("Item No.", ToBinContent."Item No.");
        FromBinContent.SetRange("Variant Code", ToBinContent."Variant Code");
        FromBinContent.SetRange("Qty. per Unit of Measure", ToBinContent."Qty. per Unit of Measure");
        FromBinContent.SetFilter("Location Code", '%1|%2', 'IP3', 'IP4');
        FromBinContent.SetCurrentKey("Location Code");
        FromBinContent.Ascending(true);
        if FromBinContent.Find('-') then begin
            ReplenishmentWorksheet2.Copy(TempReplenishmentWorksheet);
            TempReplenishmentWorksheet.SetCurrentKey("Item No.", "From Bin Code", "Location Code", "Variant Code");
            TempReplenishmentWorksheet.SetRange("Item No.", FromBinContent."Item No.");
            TempReplenishmentWorksheet.SetRange("Location Code", FromBinContent."Location Code");
            TempReplenishmentWorksheet.SetRange("Variant Code", FromBinContent."Variant Code");
            repeat
                if UseForReplenishment(FromBinContent) then begin
                    QtyAvailToTakeBase := FromBinContent.CalcQtyAvailToTakeUOM();
                    TempReplenishmentWorksheet.SetRange("From Bin Code", FromBinContent."Bin Code");
                    TempReplenishmentWorksheet.SetRange("Unit of Measure Code", FromBinContent."Unit of Measure Code");
                    TempReplenishmentWorksheet.CalcSums("System Quantity");
                    QtyAvailToTakeBase := QtyAvailToTakeBase - TempReplenishmentWorksheet."System Quantity";

                    if QtyAvailToTakeBase > 0 then begin
                        if QtyAvailToTakeBase < RemainQtyToReplenishBase then
                            MovementQtyBase := QtyAvailToTakeBase
                        else
                            MovementQtyBase := RemainQtyToReplenishBase;
                        CreateReplenishmentWorksheet(ToBinContent, FromBinContent, MovementQtyBase);
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

    procedure CreateReplenishmentWorksheet(ToBinContent: Record "Bin Content"; FromBinContent: Record "Bin Content"; MovementQtyBase: Decimal)
    var
        L_Item: Record Item;
        L_DemandQty: Decimal;
    begin
        ToBinContent.CalcFields("Quantity (Base)");
        TempReplenishmentWorksheet.Init();
        TempReplenishmentWorksheet."Posting Date" := WorkDate();
        TempReplenishmentWorksheet."Template Name" := WhseWkshTemplateName;
        TempReplenishmentWorksheet."Batch Name" := WhseWkshName;
        TempReplenishmentWorksheet."Location Code" := LocationCode;
        TempReplenishmentWorksheet."From Location Code" := FromBinContent."Location Code";
        TempReplenishmentWorksheet."From Bin Code" := FromBinContent."Bin Code";
        TempReplenishmentWorksheet."Bin Code" := ToBinContent."Bin Code";
        TempReplenishmentWorksheet."Line No." := NextLineNo;
        TempReplenishmentWorksheet."Unit of Measure Code" := FromBinContent."Unit of Measure Code";
        TempReplenishmentWorksheet."Item No." := ToBinContent."Item No.";
        L_Item.Reset();
        L_Item.SetRange("No.", ToBinContent."Item No.");
        if L_Item.FindFirst() then
            TempReplenishmentWorksheet.Description := L_Item.Description;
        TempReplenishmentWorksheet."Variant Code" := ToBinContent."Variant Code";
        TempReplenishmentWorksheet."Min. Qty." := ToBinContent."Min. Qty.";
        TempReplenishmentWorksheet."Max. Qty." := ToBinContent."Max. Qty.";
        TempReplenishmentWorksheet."System Quantity" := ToBinContent.CalcQtyAvailToTakeUOM();
        Clear(L_DemandQty);
        L_DemandQty := ToBinContent."Max. Qty." - ToBinContent.CalcQtyAvailToTakeUOM();
        TempReplenishmentWorksheet."Demand Quantity" := L_DemandQty;
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
        // TempReplenishmentWorksheet.Reset();
        // TempReplenishmentWorksheet.SetFilter("Demand Quantity", '>0');
        // if TempReplenishmentWorksheet.Find('-') then begin
        //     repeat
        //         Replenishmentworksheet.Init();
        //         Replenishmentworksheet := TempReplenishmentWorksheet;
        //         Replenishmentworksheet.Insert();
        //     until TempReplenishmentWorksheet.Next() = 0;
        //     exit(true);
        // end;
        // exit(false);
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

