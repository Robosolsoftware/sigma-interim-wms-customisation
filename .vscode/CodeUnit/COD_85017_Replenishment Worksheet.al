codeunit 85017 "Replenishment Worksheet"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        TempReplenishmentWorksheet: Record "Replenishment Worksheet" temporary; //Dont remove Temp property++
        NextLineNo: Integer;
        InsertedTH: Record "Transfer Header";
        G_SNo: Code[20];
        G_ToZoneCode: Code[20];

    // procedure CreteTransferOrder(Var _ReplenishmentWorksheet: Record "Replenishment Worksheet"): Boolean
    // var
    //     L_TransferHeader: Record "Transfer Header";
    //     L_TransferLine: Record "Transfer Line";
    //     LastTransferLine: Record "Transfer Line";
    //     HeaderCreated: Boolean;
    // begin
    //     Clear(HeaderCreated);
    //     if _ReplenishmentWorksheet.FindSet() then begin
    //         repeat
    //             _ReplenishmentWorksheet.TestField("From Location Code");
    //             _ReplenishmentWorksheet.TestField("From Bin Code");
    //             _ReplenishmentWorksheet.TestField("Qty to Move");

    //             //Header++
    //             if HeaderCreated = false then begin
    //                 L_TransferHeader.Init();
    //                 L_TransferHeader.Validate("Transfer-from Code", _ReplenishmentWorksheet."From Location Code");
    //                 L_TransferHeader.Validate("Transfer-to Code", _ReplenishmentWorksheet."Location Code");
    //                 L_TransferHeader.Validate("Posting Date", _ReplenishmentWorksheet."Posting Date");
    //                 L_TransferHeader.Validate("Shipment Date", _ReplenishmentWorksheet."Posting Date");
    //                 L_TransferHeader.Validate("Receipt Date", _ReplenishmentWorksheet."Posting Date");
    //                 L_TransferHeader.Validate("Replenishment Batch Name", _ReplenishmentWorksheet."Batch Name");
    //                 HeaderCreated := L_TransferHeader.Insert(true);
    //             end;

    //             //Line++
    //             if HeaderCreated = true then begin
    //                 L_TransferLine.Init();
    //                 L_TransferLine.Validate("Document No.", L_TransferHeader."No.");
    //                 LastTransferLine.Reset();
    //                 LastTransferLine.SetRange("Document No.", L_TransferHeader."No.");
    //                 if LastTransferLine.FindLast() then
    //                     L_TransferLine."Line No." := LastTransferLine."Line No." + 10000
    //                 else
    //                     L_TransferLine."Line No." := 10000;
    //                 L_TransferLine.Validate("Item No.", _ReplenishmentWorksheet."Item No.");
    //                 L_TransferLine.Validate("Transfer-from Code", _ReplenishmentWorksheet."From Location Code");
    //                 L_TransferLine.Validate("Transfer-from Bin Code", _ReplenishmentWorksheet."From Bin Code");
    //                 L_TransferLine.Validate("Transfer-to Code", _ReplenishmentWorksheet."Location Code");
    //                 L_TransferLine.Validate("Transfer-To Bin Code", _ReplenishmentWorksheet."Bin Code");
    //                 L_TransferLine.Validate(Quantity, _ReplenishmentWorksheet."Qty to Move");
    //                 L_TransferLine.Insert(true);
    //             end;
    //         until _ReplenishmentWorksheet.Next() = 0;
    //     end;
    //     exit(HeaderCreated)
    // end;


    procedure CreteTransferOrder(Var _ReplenishmentWorksheet: Record "Replenishment Worksheet"; _ToZoneCode: Code[20]): Boolean
    var
        L_TransferHeader: Record "Transfer Header";
        L_TransferLine: Record "Transfer Line";
        LastTransferLine: Record "Transfer Line";
        HeaderCreated: Boolean;
    begin
        //clear And Reset Variable++
        Clear(HeaderCreated);
        Clear(NextLineNo);
        Clear(G_ToZoneCode);
        TempReplenishmentWorksheet.Reset();
        TempReplenishmentWorksheet.DeleteAll();
        NextLineNo := 10000;
        G_ToZoneCode := _ToZoneCode;


        //Create Temp Record++++
        _ReplenishmentWorksheet.SetCurrentKey("From Location Code");
        _ReplenishmentWorksheet.Ascending(true);
        if _ReplenishmentWorksheet.FindSet() then begin
            repeat
                _ReplenishmentWorksheet.TestField("From Location Code");
                _ReplenishmentWorksheet.TestField("Qty to Move");

                //Create Temp Record++
                FindReplenishmtBin(_ReplenishmentWorksheet);
            until _ReplenishmentWorksheet.Next() = 0;

            //Create Transfer Order from Temp Tbale+++
            exit(CreteTransferOrderFromTemTable())
        end;
    end;

    procedure FindReplenishmtBin(_ReplenishmentWorksheet: Record "Replenishment Worksheet")
    var
        FromBinContent: Record "Bin Content";
        ReplenishmentWorksheet2: Record "Replenishment Worksheet";
        QtyAvailToTakeBase: Decimal;
        MovementQtyBase: Decimal;
        RemainQtyToReplenishBase, L_TransferLineQty : Decimal;
    begin
        //Calculate RemainQtyToReplenishBase Qty+++
        Clear(RemainQtyToReplenishBase);
        RemainQtyToReplenishBase := _ReplenishmentWorksheet."Qty to Move";

        FromBinContent.Reset();
        FromBinContent.SetRange("Item No.", _ReplenishmentWorksheet."Item No.");
        FromBinContent.SetRange("Variant Code", _ReplenishmentWorksheet."Variant Code");
        FromBinContent.SetFilter("Location Code", _ReplenishmentWorksheet."From Location Code");
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
                    L_TransferLineQty := CheckExitingQtyInTransferLineforFromLocation(_ReplenishmentWorksheet."Item No.", _ReplenishmentWorksheet."Variant Code", FromBinContent."Location Code", FromBinContent."Bin Code");
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
                        CreateReplenishmentWorksheet(_ReplenishmentWorksheet, FromBinContent, MovementQtyBase);
                        RemainQtyToReplenishBase := RemainQtyToReplenishBase - MovementQtyBase;
                    end;
                end;
            until (FromBinContent.Next() = 0) or (RemainQtyToReplenishBase = 0);
            TempReplenishmentWorksheet.Copy(ReplenishmentWorksheet2);
        end;
    end;

    procedure CreteTransferOrderFromTemTable() _HeaderCreated: Boolean
    var
        L_TransferHeader: Record "Transfer Header";
        L_TransferLine: Record "Transfer Line";
        LastTransferLine: Record "Transfer Line";
        LocationCodeLoop: Code[20];
        BreakCount: Integer;
        TempReplenishmentWorksheet_ForLoop: Record "Replenishment Worksheet" temporary; //Dont remove Temp property++
        Counter: Integer;
        L_TotalLoopCount: Integer;
        L_ItemNoLoop: Code[20];
        L_LineNo: Integer;
    begin
        //Insert Data in Temp Table for Loop+++
        TempReplenishmentWorksheet_ForLoop.Reset();
        TempReplenishmentWorksheet_ForLoop.DeleteAll();
        TempReplenishmentWorksheet.Reset();
        if TempReplenishmentWorksheet.FindSet() then begin
            repeat
                TempReplenishmentWorksheet_ForLoop.Init();
                TempReplenishmentWorksheet_ForLoop.TransferFields(TempReplenishmentWorksheet);
                TempReplenishmentWorksheet_ForLoop.Insert();
            until TempReplenishmentWorksheet.Next() = 0;
        end;

        //Clear Variable++
        Clear(L_LineNo);
        Clear(LocationCodeLoop);
        Clear(L_TotalLoopCount);
        Clear(_HeaderCreated);

        //Get Total Break Count++
        Clear(BreakCount);
        BreakCount := 16;


        //Process to Create Transfer Order++++++++
        TempReplenishmentWorksheet.Reset();
        TempReplenishmentWorksheet.SetCurrentKey("From Location Code");
        TempReplenishmentWorksheet.Ascending(true);
        if TempReplenishmentWorksheet.FindSet() then begin
            repeat
                if LocationCodeLoop <> TempReplenishmentWorksheet."From Location Code" then begin

                    Clear(Counter);
                    TempReplenishmentWorksheet_ForLoop.Reset();
                    TempReplenishmentWorksheet_ForLoop.SetRange("From Location Code", TempReplenishmentWorksheet."From Location Code");
                    TempReplenishmentWorksheet_ForLoop.SetRange("System-Created Entry", false);
                    TempReplenishmentWorksheet_ForLoop.SetCurrentKey("Item No.");
                    TempReplenishmentWorksheet_ForLoop.Ascending(true);
                    if TempReplenishmentWorksheet_ForLoop.FindSet() then begin
                        Clear(L_LineNo);

                        //Get Total Count++
                        Clear(L_TotalLoopCount);
                        L_TotalLoopCount := TempReplenishmentWorksheet_ForLoop.Count;


                        //Create Header+++
                        InsertedTH.Reset();
                        if CreateTransferHeaderFromTemporary(TempReplenishmentWorksheet_ForLoop) = true then
                            _HeaderCreated := true
                        else
                            Error('The transfer header does not exist.');
                        repeat
                            //substract by 1 in Total count++
                            L_TotalLoopCount -= 1;

                            //Increase By 1 for new header++
                            if L_ItemNoLoop <> TempReplenishmentWorksheet_ForLoop."Item No." then begin
                                Counter += 1;
                                L_ItemNoLoop := TempReplenishmentWorksheet_ForLoop."Item No."
                            end;

                            //Get Line No +++
                            L_LineNo := L_LineNo + 10000;

                            //Create Line++
                            CreateTransferLineFromTemporary(G_SNo, TempReplenishmentWorksheet_ForLoop, L_LineNo);

                            //Update System Create Entry for next loop+++
                            TempReplenishmentWorksheet_ForLoop."System-Created Entry" := true;
                            TempReplenishmentWorksheet_ForLoop.Modify();

                            if BreakCount > 0 then begin
                                if Counter = BreakCount then begin
                                    //break;

                                    //Create Header++
                                    if L_TotalLoopCount > 0 then begin
                                        Clear(Counter);
                                        //Create Header+++
                                        InsertedTH.Reset();
                                        if CreateTransferHeaderFromTemporary(TempReplenishmentWorksheet_ForLoop) = true then
                                            _HeaderCreated := true
                                        else
                                            Error('The transfer header does not exist.');
                                    end;
                                end;
                            end else begin
                                if Counter = 16 then begin
                                    //Create Header++
                                    if L_TotalLoopCount > 0 then begin
                                        Clear(Counter);
                                        //Create Header+++
                                        InsertedTH.Reset();
                                        if CreateTransferHeaderFromTemporary(TempReplenishmentWorksheet_ForLoop) = true then
                                            _HeaderCreated := true
                                        else
                                            Error('The transfer header does not exist.');
                                    end;
                                end;
                            end;
                        until TempReplenishmentWorksheet_ForLoop.Next() = 0;
                    end;
                end;

                //++++
                LocationCodeLoop := TempReplenishmentWorksheet."From Location Code";
            until TempReplenishmentWorksheet.Next() = 0;
        end;
    end;


    local procedure CreateTransferHeaderFromTemporary(_Temporary_ReplenishmentWorksheet: Record "Replenishment Worksheet" temporary): Boolean
    var
        NoSeries: Codeunit "No. Series";
        L_InventorySetup: Record "Inventory Setup";
    begin
        L_InventorySetup.Get();
        Clear(G_SNo);
        InsertedTH.Reset();
        InsertedTH.Init();
        InsertedTH."No." := NoSeries.PeekNextNo(L_InventorySetup."Transfer Order Nos.", WorkDate());
        NoSeries.GetNextNo(L_InventorySetup."Transfer Order Nos.", WorkDate());
        InsertedTH.Validate("Transfer-from Code", TempReplenishmentWorksheet."From Location Code");
        InsertedTH.Validate("Transfer-to Code", TempReplenishmentWorksheet."Location Code");
        InsertedTH.Validate("Posting Date", TempReplenishmentWorksheet."Posting Date");
        InsertedTH.Validate("Shipment Date", TempReplenishmentWorksheet."Posting Date");
        InsertedTH.Validate("Receipt Date", TempReplenishmentWorksheet."Posting Date");
        InsertedTH.Validate("Replenishment Batch Name", TempReplenishmentWorksheet."Batch Name");
        InsertedTH.Validate("Transfer-To Zone Code", G_ToZoneCode);
        if InsertedTH.Insert(true) = true then begin
            G_SNo := InsertedTH."No.";
            exit(true);
        end else
            exit(false);
    end;

    local procedure CreateTransferLineFromTemporary(_SalesOrderNo: Code[20]; _Temporary_ReplenishmentWorksheet: Record "Replenishment Worksheet" temporary; _LineNumber: Integer)
    var
        L_TransferHeader: Record "Transfer Header";
        L_TransferLine: Record "Transfer Line";
    begin
        L_TransferHeader.Reset();
        L_TransferHeader.SetRange("No.", _SalesOrderNo);
        if L_TransferHeader.FindFirst() then begin
            L_TransferLine.Init();
            L_TransferLine.Validate("Document No.", L_TransferHeader."No.");
            L_TransferLine."Line No." := _LineNumber;
            L_TransferLine.Validate("Item No.", _Temporary_ReplenishmentWorksheet."Item No.");
            L_TransferLine.Validate("Variant Code", _Temporary_ReplenishmentWorksheet."Variant Code");
            L_TransferLine.Validate("Transfer-from Code", _Temporary_ReplenishmentWorksheet."From Location Code");
            L_TransferLine.Validate("Transfer-from Bin Code", _Temporary_ReplenishmentWorksheet."From Bin Code");
            L_TransferLine.Validate("Transfer-to Code", _Temporary_ReplenishmentWorksheet."Location Code");
            L_TransferLine."Transfer-To Bin Code" := '';
            L_TransferLine.Validate(Quantity, _Temporary_ReplenishmentWorksheet."Qty to Move");
            L_TransferLine.Insert(true);
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

    procedure CreateReplenishmentWorksheet(_ReplenishmentWorksheet: Record "Replenishment Worksheet"; FromBinContent: Record "Bin Content"; MovementQtyBase: Decimal)
    var
        L_Item: Record Item;
    begin
        TempReplenishmentWorksheet.Init();
        TempReplenishmentWorksheet."Posting Date" := WorkDate();
        TempReplenishmentWorksheet."Template Name" := _ReplenishmentWorksheet."Template Name";
        TempReplenishmentWorksheet."Batch Name" := _ReplenishmentWorksheet."Batch Name";
        TempReplenishmentWorksheet."Location Code" := _ReplenishmentWorksheet."Location Code";
        TempReplenishmentWorksheet."From Location Code" := FromBinContent."Location Code";
        TempReplenishmentWorksheet."From Bin Code" := FromBinContent."Bin Code";
        TempReplenishmentWorksheet."Bin Code" := _ReplenishmentWorksheet."Bin Code";
        TempReplenishmentWorksheet."Line No." := NextLineNo;
        TempReplenishmentWorksheet."Unit of Measure Code" := FromBinContent."Unit of Measure Code";
        TempReplenishmentWorksheet."Item No." := _ReplenishmentWorksheet."Item No.";
        L_Item.Reset();
        L_Item.SetRange("No.", _ReplenishmentWorksheet."Item No.");
        if L_Item.FindFirst() then begin
            TempReplenishmentWorksheet.Description := L_Item.Description;
            TempReplenishmentWorksheet."Top Category" := L_Item."Top Category";
        end;
        TempReplenishmentWorksheet."Variant Code" := _ReplenishmentWorksheet."Variant Code";
        TempReplenishmentWorksheet."Min. Qty." := _ReplenishmentWorksheet."Min. Qty.";
        TempReplenishmentWorksheet."Max. Qty." := _ReplenishmentWorksheet."Max. Qty.";
        TempReplenishmentWorksheet."System Quantity" := _ReplenishmentWorksheet."System Quantity";
        TempReplenishmentWorksheet."Demand Quantity" := _ReplenishmentWorksheet."Demand Quantity";
        TempReplenishmentWorksheet."Qty to Move" := MovementQtyBase;
        TempReplenishmentWorksheet.Insert();

        NextLineNo := NextLineNo + 10000;
    end;

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


    procedure TotalAvailabletoTake(_ItemNo: Code[20]; _VariantCode: Code[10]; _LocationCode: Code[10]): Decimal
    var
        L_BinContent: Record "Bin Content";
        L_Bin: Record Bin;
        L_AvailabletoTake: Decimal;
    begin
        Clear(L_AvailabletoTake);
        L_BinContent.Reset();
        L_BinContent.SetRange("Location Code", _LocationCode);
        L_BinContent.SetRange("Item No.", _ItemNo);
        L_BinContent.SetRange("Variant Code", _VariantCode);
        L_BinContent.SetFilter("Exclude from free Qty.", '%1', false);
        if L_BinContent.FindSet() then begin
            repeat
                L_AvailabletoTake := L_AvailabletoTake + L_BinContent.CalcQtyAvailToTakeUOM();
            until L_BinContent.Next() = 0;
        end;
        if L_AvailabletoTake > 0 then
            exit(L_AvailabletoTake)
        else
            exit(0);
    end;



    //Last 2 Weekday qty++
    procedure CheckExitingQtyInTransferLineFromToLocation(_ItemNo: Code[20]; _VariantCode: Code[20]; _Location: Code[10]): Decimal
    var
        L_TransferLine: Record "Transfer Line";
        L_TotalQty: Decimal;
        L_Date: Date;
    begin
        Clear(L_Date);
        if Format(WorkDate(), 0, '<Weekday Text>') = 'Sunday' then
            L_Date := CalcDate('-3D', WorkDate())
        else
            if Format(WorkDate(), 0, '<Weekday Text>') = 'Monday' then
                L_Date := CalcDate('-4D', WorkDate())
            else
                if Format(WorkDate(), 0, '<Weekday Text>') = 'Tuesday' then
                    L_Date := CalcDate('-4D', WorkDate())
                else
                    L_Date := CalcDate('-2D', WorkDate());


        Clear(L_TotalQty);
        L_TransferLine.SetRange("Transfer-to Code", _Location);
        L_TransferLine.SetRange("Item No.", _ItemNo);
        L_TransferLine.SetFilter("Posting Date", '%1..%2', L_Date, WorkDate());
        L_TransferLine.SetRange("Variant Code", _VariantCode);
        if L_TransferLine.FindSet() then begin
            L_TransferLine.CalcSums("Outstanding Quantity");
            L_TotalQty := L_TransferLine."Outstanding Quantity";
        end;


        if L_TotalQty > 0 then
            exit(L_TotalQty)
        else
            exit(0);
    end;

    procedure CheckExitingQtyInTransferLineforFromLocation(_ItemNo: Code[20]; _VariantCode: Code[20]; _Location: Code[10]; _BinCode: Code[20]): Decimal
    var
        L_TransferLine: Record "Transfer Line";
        L_TotalQty: Decimal;
        L_Date: Date;
    begin
        Clear(L_Date);
        if Format(WorkDate(), 0, '<Weekday Text>') = 'Sunday' then
            L_Date := CalcDate('-3D', WorkDate())
        else
            if Format(WorkDate(), 0, '<Weekday Text>') = 'Monday' then
                L_Date := CalcDate('-4D', WorkDate())
            else
                if Format(WorkDate(), 0, '<Weekday Text>') = 'Tuesday' then
                    L_Date := CalcDate('-4D', WorkDate())
                else
                    L_Date := CalcDate('-2D', WorkDate());


        Clear(L_TotalQty);
        L_TransferLine.SetRange("Transfer-from Code", _Location);
        L_TransferLine.SetRange("Item No.", _ItemNo);
        L_TransferLine.SetFilter("Posting Date", '%1..%2', L_Date, WorkDate());
        L_TransferLine.SetRange("Variant Code", _VariantCode);
        if _BinCode <> '' then
            L_TransferLine.SetRange("Transfer-from Bin Code", _BinCode);
        if L_TransferLine.FindSet() then begin
            L_TransferLine.CalcSums("Outstanding Quantity");
            L_TotalQty := L_TransferLine."Outstanding Quantity";
        end;


        if L_TotalQty > 0 then
            exit(L_TotalQty)
        else
            exit(0);
    end;
}