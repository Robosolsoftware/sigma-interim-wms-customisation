codeunit 85002 "Post Item Reclassification"
{
    Permissions = tabledata "Sales Shipment Line" = rimd;

    trigger OnRun()
    var
        L_KnappLocation: Record Location;
    begin
        L_KnappLocation.Reset();
        L_KnappLocation.SetRange("Knapp Location", true);
        if L_KnappLocation.FindFirst() then begin
            G_Zone.Reset();
            G_Zone.SetFilter("Replenishment Priority", '<>0');
            G_Zone.SetCurrentKey("Replenishment Priority");
            G_Zone.Ascending(true);
            if G_Zone.FindFirst() then
                PostItemReclassificationJobNew(L_KnappLocation.Code, G_Zone."Location Code");
        end;
    end;

    procedure PostItemReclassificationJobNew(P_KnappLocation: Code[10]; P_SaleableLocation: Code[10])
    var
        L_BinContent: Record "Bin Content";
        RequiredQuantity: Decimal;
        AvailableQuantity: Decimal;
        BinCode: Code[20];
        L_ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        KnappQuery: Query "Item Ledger Enteries-Qty Knapp";
        NoSeriesManagement: Codeunit "No. Series";
        IsItemVariantMandatory: Boolean;
        L_Item: Record Item;
        L_InventorySetup: Record "Inventory Setup";
        NegativeItemJnlLine: Record "Item Journal Line";
        NegativeItemJnlLine2: Record "Item Journal Line";
    begin
        Clear(L_ItemJournalLine);
        L_ItemJournalLine.Reset();
        L_ItemJournalLine.SetRange("Journal Template Name", 'TRANSFER');
        L_ItemJournalLine.SetRange("Journal Batch Name", 'KNAPP');
        if L_ItemJournalLine.FindSet() then begin
            L_ItemJournalLine.DeleteAll();
        end;
        /* NegativeItemJnlLine.Reset();
         NegativeItemJnlLine.SetRange("Journal Template Name", 'ITEM');
         NegativeItemJnlLine.SetRange("Journal Batch Name", 'KNAPP');
         if NegativeItemJnlLine.FindSet() then begin
             NegativeItemJnlLine.DeleteAll();
         end;*/


        if KnappQuery.Open() then begin
            while KnappQuery.Read() do begin
                Clear(RequiredQuantity);
                RequiredQuantity := Abs(KnappQuery.Quantity);

                IsItemVariantMandatory := false;
                L_Item.Reset();
                if L_Item.Get(KnappQuery.Item_No_) then begin
                    L_Item.CalcFields("Variant Exist");
                    if L_Item."Variant Exist" = true then begin
                        if KnappQuery.Variant_Code <> '' then
                            IsItemVariantMandatory := true;
                    end
                    else begin
                        IsItemVariantMandatory := true;
                    end;
                end;

                if (RequiredQuantity > 0) and (IsItemVariantMandatory = true) then begin
                    G_Zone.Reset();
                    G_Zone.SetFilter("Replenishment Priority", '<>0');
                    G_Zone.SetCurrentKey("Replenishment Priority");
                    G_Zone.Ascending(true);
                    if G_Zone.FindSet() then begin
                        repeat
                            Clear(BinCode);
                            L_BinContent.Reset();
                            L_BinContent.SetRange("Location Code", P_SaleableLocation);
                            L_BinContent.SetRange("Zone Code", G_Zone.Code);
                            L_BinContent.SetRange("Item No.", KnappQuery.Item_No_);
                            if KnappQuery.Variant_Code <> '' then
                                L_BinContent.SetRange("Variant Code", KnappQuery.Variant_Code);
                            if L_BinContent.FindSet() then begin
                                repeat
                                    if RequiredQuantity = 0 then
                                        break;

                                    Clear(AvailableQuantity);
                                    AvailableQuantity := L_BinContent.CalcQtyAvailToTakeUOM();

                                    Clear(BinCode);
                                    if RequiredQuantity <= AvailableQuantity then begin
                                        BinCode := L_BinContent."Bin Code";
                                        if BinCode <> '' then begin
                                            G_ItemJournalLine.Reset();
                                            G_ItemJournalLine.Init();
                                            G_ItemJournalLine.Validate("Journal Template Name", 'TRANSFER');
                                            G_ItemJournalLine.Validate("Journal Batch Name", 'KNAPP');
                                            G_ItemJournalLine.Validate("Line No.", GetLastLineNo());
                                            G_ItemJournalLine.Validate("Entry Type", G_ItemJournalLine."Entry Type"::Transfer);

                                            L_InventorySetup.Get();
                                            G_ItemJournalLine."Document No." := NoSeriesManagement.GetNextNo(L_InventorySetup."Knapp Replenishment No. Series", WorkDate());

                                            G_ItemJournalLine.Validate("Item No.", KnappQuery.Item_No_);
                                            if KnappQuery.Variant_Code <> '' then
                                                G_ItemJournalLine.Validate("Variant Code", KnappQuery.Variant_Code);
                                            G_ItemJournalLine.Validate(Quantity, RequiredQuantity);
                                            G_ItemJournalLine.Validate("Location Code", P_SaleableLocation);
                                            G_ItemJournalLine.Validate("New Location Code", P_KnappLocation);
                                            G_ItemJournalLine.Validate("Bin Code", BinCode);
                                            G_ItemJournalLine.Validate("Posting Date", Today);
                                            G_ItemJournalLine.Validate("Source Code", 'RECLASSJNL');
                                            G_ItemJournalLine.Insert(true);
                                            Commit();

                                            if Codeunit.Run(Codeunit::"Item Jnl.-Post", G_ItemJournalLine) then
                                                break
                                            else
                                                Error(GetLastErrorText());
                                        end
                                        //  break;
                                    end else begin
                                        if AvailableQuantity > 0 then begin
                                            //RequiredQuantity := AvailableQuantity;
                                            BinCode := L_BinContent."Bin Code";
                                            if BinCode <> '' then begin
                                                G_ItemJournalLine.Reset();
                                                G_ItemJournalLine.Init();
                                                G_ItemJournalLine.Validate("Journal Template Name", 'TRANSFER');
                                                G_ItemJournalLine.Validate("Journal Batch Name", 'KNAPP');
                                                G_ItemJournalLine.Validate("Line No.", GetLastLineNo());
                                                G_ItemJournalLine.Validate("Entry Type", G_ItemJournalLine."Entry Type"::Transfer);

                                                L_InventorySetup.Get();
                                                G_ItemJournalLine."Document No." := NoSeriesManagement.GetNextNo(L_InventorySetup."Knapp Replenishment No. Series", WorkDate());

                                                G_ItemJournalLine.Validate("Item No.", KnappQuery.Item_No_);
                                                if KnappQuery.Variant_Code <> '' then
                                                    G_ItemJournalLine.Validate("Variant Code", KnappQuery.Variant_Code);
                                                G_ItemJournalLine.Validate(Quantity, AvailableQuantity);
                                                G_ItemJournalLine.Validate("Location Code", P_SaleableLocation);
                                                G_ItemJournalLine.Validate("New Location Code", P_KnappLocation);
                                                G_ItemJournalLine.Validate("Bin Code", BinCode);
                                                G_ItemJournalLine.Validate("Posting Date", Today);
                                                G_ItemJournalLine.Validate("Source Code", 'RECLASSJNL');
                                                G_ItemJournalLine.Insert(true);
                                                Commit();

                                                if Codeunit.Run(Codeunit::"Item Jnl.-Post", G_ItemJournalLine) then
                                                    RequiredQuantity := RequiredQuantity - AvailableQuantity
                                                else
                                                    Error(GetLastErrorText());

                                            end
                                            //  break;
                                        end;
                                    end;
                                until L_BinContent.Next() = 0;
                            end;

                        //if BinCode <> '' then
                        //  break;
                        until G_Zone.Next() = 0;
                    end;

                    /*if BinCode <> '' then begin
                        G_ItemJournalLine.Reset();
                        G_ItemJournalLine.Init();
                        G_ItemJournalLine.Validate("Journal Template Name", 'TRANSFER');
                        G_ItemJournalLine.Validate("Journal Batch Name", 'KNAPP');
                        G_ItemJournalLine.Validate("Line No.", GetLastLineNo());
                        G_ItemJournalLine.Validate("Entry Type", G_ItemJournalLine."Entry Type"::Transfer);
 
                        L_InventorySetup.Get();
                        G_ItemJournalLine."Document No." := NoSeriesManagement.GetNextNo(L_InventorySetup."Knapp Replenishment No. Series", WorkDate());
 
                        G_ItemJournalLine.Validate("Item No.", KnappQuery.Item_No_);
                        if KnappQuery.Variant_Code <> '' then
                            G_ItemJournalLine.Validate("Variant Code", KnappQuery.Variant_Code);
                        G_ItemJournalLine.Validate(Quantity, RequiredQuantity);
                        G_ItemJournalLine.Validate("Location Code", P_SaleableLocation);
                        G_ItemJournalLine.Validate("New Location Code", P_KnappLocation);
                        G_ItemJournalLine.Validate("Bin Code", BinCode);
                        G_ItemJournalLine.Validate("Posting Date", Today);
                        G_ItemJournalLine.Validate("Source Code", 'RECLASSJNL');
                        G_ItemJournalLine.Insert(true);
                        Commit();
 
                        if Codeunit.Run(Codeunit::"Item Jnl.-Post", G_ItemJournalLine) then;
                    end
                    else begin
 
                        NegativeItemJnlLine2.Reset();
                        NegativeItemJnlLine2.Init();
                        NegativeItemJnlLine2.Validate("Journal Template Name", 'ITEM');
                        NegativeItemJnlLine2.Validate("Journal Batch Name", 'KNAPP');
                        NegativeItemJnlLine2.Validate("Line No.", GetLastItemLineNo());
                        NegativeItemJnlLine2.Validate("Entry Type", NegativeItemJnlLine2."Entry Type"::"Negative Adjmt.");
                        L_InventorySetup.Get();
                        NegativeItemJnlLine2."Document No." := 'KNAAP ITEM ADJ';
                        NegativeItemJnlLine2.Validate("Item No.", KnappQuery.Item_No_);
                        if KnappQuery.Variant_Code <> '' then
                            NegativeItemJnlLine2.Validate("Variant Code", KnappQuery.Variant_Code);
                        NegativeItemJnlLine2.Validate(Quantity, RequiredQuantity);
                        NegativeItemJnlLine2.Validate("Location Code", P_KnappLocation);
                        //NegativeItemJnlLine2.Validate("New Location Code", P_SaleableLocation);
                        NegativeItemJnlLine2.Validate("Bin Code", BinCode);
                        NegativeItemJnlLine2.Validate("Posting Date", Today);
                        NegativeItemJnlLine2.Validate("Source Code", 'ITEMJNL');
                        NegativeItemJnlLine2.Insert(true);
                        Commit();
                        Codeunit.Run(Codeunit::"Item Jnl.-Post", NegativeItemJnlLine2);
                    end;*/
                end;
            end;
        end;
    end;



    local procedure PostItemReclassificationJob(P_KnappLocation: Code[10]; P_SaleableLocation: Code[10])
    var
        L_SalesShipmentLine: Record "Sales Shipment Line";
        L_BinContent: Record "Bin Content";
        RequiredQuantity: Decimal;
        AvailableQuantity: Decimal;
        BinCode: Code[20];
        L_ItemJournalLine: Record "Item Journal Line";
        NoSeriesManagement: Codeunit "No. Series";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        Clear(L_ItemJournalLine);
        L_ItemJournalLine.Reset();
        L_ItemJournalLine.SetRange("Journal Template Name", 'TRANSFER');
        L_ItemJournalLine.SetRange("Journal Batch Name", 'KNAPP');
        if L_ItemJournalLine.FindSet() then begin
            L_ItemJournalLine.DeleteAll();
        end;

        L_SalesShipmentLine.Reset();
        L_SalesShipmentLine.SetFilter("No.", '<>%1', '');
        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
        L_SalesShipmentLine.SetFilter(Quantity, '>0');
        L_SalesShipmentLine.SetRange("Location Code", P_KnappLocation);
        L_SalesShipmentLine.SetRange(Reclassified, false);
        //L_SalesShipmentLine.SetFilter("Document No.", '%1', '177184');
        if L_SalesShipmentLine.FindSet() then begin
            repeat
                Clear(RequiredQuantity);
                RequiredQuantity := L_SalesShipmentLine.Quantity;

                G_Zone.Reset();
                G_Zone.SetFilter("Replenishment Priority", '<>0');
                G_Zone.SetCurrentKey("Replenishment Priority");
                G_Zone.Ascending(true);
                if G_Zone.FindSet() then begin
                    repeat
                        Clear(BinCode);
                        L_BinContent.Reset();
                        L_BinContent.SetRange("Location Code", P_SaleableLocation);
                        L_BinContent.SetRange("Zone Code", G_Zone.Code);
                        L_BinContent.SetRange("Item No.", L_SalesShipmentLine."No.");
                        if L_SalesShipmentLine."Variant Code" <> '' then
                            L_BinContent.SetRange("Variant Code", L_SalesShipmentLine."Variant Code");
                        if L_BinContent.FindSet() then begin
                            repeat
                                Clear(AvailableQuantity);
                                L_BinContent.CalcFields(Quantity);
                                AvailableQuantity := L_BinContent.Quantity;

                                Clear(BinCode);
                                if RequiredQuantity <= AvailableQuantity then begin
                                    BinCode := L_BinContent."Bin Code";
                                    break;
                                end;
                            until L_BinContent.Next() = 0;
                        end;

                        if BinCode <> '' then
                            break;
                    until G_Zone.Next() = 0;
                end;

                if BinCode <> '' then begin
                    G_ItemJournalLine.Reset();
                    G_ItemJournalLine.Init();
                    G_ItemJournalLine.Validate("Journal Template Name", 'TRANSFER');
                    G_ItemJournalLine.Validate("Journal Batch Name", 'KNAPP');
                    G_ItemJournalLine.Validate("Line No.", GetLastLineNo());
                    G_ItemJournalLine.Validate("Entry Type", G_ItemJournalLine."Entry Type"::Transfer);

                    // ItemJournalBatch.Reset();
                    // ItemJournalBatch.SetRange("Journal Template Name", 'TRANSFER');
                    // ItemJournalBatch.SetRange(Name, 'KNAPP');
                    // if ItemJournalBatch.FindFirst() then begin
                    //     G_ItemJournalLine."Document No." := NoSeriesManagement.GetNextNo(ItemJournalBatch."No. Series", WorkDate());
                    // end;

                    G_ItemJournalLine."Document No." := L_SalesShipmentLine."Document No.";
                    G_ItemJournalLine."Document Line No." := L_SalesShipmentLine."Line No.";
                    G_ItemJournalLine.Validate("Item No.", L_SalesShipmentLine."No.");
                    if L_SalesShipmentLine."Variant Code" <> '' then
                        G_ItemJournalLine.Validate("Variant Code", L_SalesShipmentLine."Variant Code");
                    G_ItemJournalLine.Validate(Quantity, L_SalesShipmentLine.Quantity);
                    G_ItemJournalLine.Validate("Location Code", P_SaleableLocation);
                    G_ItemJournalLine.Validate("New Location Code", P_KnappLocation);
                    G_ItemJournalLine.Validate("Bin Code", BinCode);
                    G_ItemJournalLine.Validate("External Document No.", L_SalesShipmentLine."Order No.");
                    G_ItemJournalLine.Validate("Posting Date", Today);
                    G_ItemJournalLine.Validate("Source Code", 'RECLASSJNL');
                    G_ItemJournalLine.Insert(true);
                    Commit();

                    if Codeunit.Run(Codeunit::"Item Jnl.-Post", G_ItemJournalLine) then begin
                        L_SalesShipmentLine.Reclassified := true;
                        L_SalesShipmentLine.Modify();
                    end;
                end;

                Commit();
            until L_SalesShipmentLine.Next() = 0;
        end;
    end;

    procedure PostItemReclassification(P_KnappLocation: Code[10]; P_SaleableLocation: Code[10]; var P_SalesShipmentHeader: Record "Sales Shipment Header")
    var
        L_SalesShipmentLine: Record "Sales Shipment Line";
        L_BinContent: Record "Bin Content";
        RequiredQuantity: Decimal;
        AvailableQuantity: Decimal;
        BinCode: Code[20];
        L_ItemJournalLine: Record "Item Journal Line";
        NoSeriesManagement: Codeunit "No. Series";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        Clear(L_ItemJournalLine);
        L_ItemJournalLine.Reset();
        L_ItemJournalLine.SetRange("Journal Template Name", 'TRANSFER');
        L_ItemJournalLine.SetRange("Journal Batch Name", 'KNAPP');
        if L_ItemJournalLine.FindSet() then begin
            L_ItemJournalLine.DeleteAll();
        end;

        L_SalesShipmentLine.Reset();
        L_SalesShipmentLine.SetFilter("No.", '<>%1', '');
        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
        L_SalesShipmentLine.SetFilter(Quantity, '>0');
        L_SalesShipmentLine.SetRange("Location Code", P_KnappLocation);
        L_SalesShipmentLine.SetRange(Reclassified, false);
        L_SalesShipmentLine.SetFilter("Document No.", P_SalesShipmentHeader."No.");
        if L_SalesShipmentLine.FindSet() then begin
            repeat
                Clear(RequiredQuantity);
                RequiredQuantity := L_SalesShipmentLine.Quantity;

                G_Zone.Reset();
                G_Zone.SetFilter("Replenishment Priority", '<>0');
                G_Zone.SetCurrentKey("Replenishment Priority");
                G_Zone.Ascending(true);
                if G_Zone.FindSet() then begin
                    repeat
                        Clear(BinCode);
                        L_BinContent.Reset();
                        L_BinContent.SetRange("Location Code", P_SaleableLocation);
                        L_BinContent.SetRange("Zone Code", G_Zone.Code);
                        L_BinContent.SetRange("Item No.", L_SalesShipmentLine."No.");
                        if L_SalesShipmentLine."Variant Code" <> '' then
                            L_BinContent.SetRange("Variant Code", L_SalesShipmentLine."Variant Code");
                        if L_BinContent.FindSet() then begin
                            repeat
                                Clear(AvailableQuantity);
                                L_BinContent.CalcFields(Quantity);
                                AvailableQuantity := L_BinContent.Quantity;

                                Clear(BinCode);
                                if RequiredQuantity <= AvailableQuantity then begin
                                    BinCode := L_BinContent."Bin Code";
                                    break;
                                end;
                            until L_BinContent.Next() = 0;
                        end;

                        if BinCode <> '' then
                            break;
                    until G_Zone.Next() = 0;
                end;

                if BinCode <> '' then begin
                    G_ItemJournalLine.Reset();
                    G_ItemJournalLine.Init();
                    G_ItemJournalLine.Validate("Journal Template Name", 'TRANSFER');
                    G_ItemJournalLine.Validate("Journal Batch Name", 'KNAPP');
                    G_ItemJournalLine.Validate("Line No.", GetLastLineNo());
                    G_ItemJournalLine.Validate("Entry Type", G_ItemJournalLine."Entry Type"::Transfer);
                    G_ItemJournalLine."Document No." := L_SalesShipmentLine."Document No.";
                    G_ItemJournalLine."Document Line No." := L_SalesShipmentLine."Line No.";
                    G_ItemJournalLine.Validate("Item No.", L_SalesShipmentLine."No.");
                    if L_SalesShipmentLine."Variant Code" <> '' then
                        G_ItemJournalLine.Validate("Variant Code", L_SalesShipmentLine."Variant Code");
                    G_ItemJournalLine.Validate(Quantity, L_SalesShipmentLine.Quantity);
                    G_ItemJournalLine.Validate("Location Code", P_SaleableLocation);
                    G_ItemJournalLine.Validate("New Location Code", P_KnappLocation);
                    G_ItemJournalLine.Validate("Bin Code", BinCode);
                    G_ItemJournalLine.Validate("External Document No.", L_SalesShipmentLine."Order No.");
                    G_ItemJournalLine.Validate("Posting Date", Today);
                    G_ItemJournalLine.Validate("Source Code", 'RECLASSJNL');
                    G_ItemJournalLine.Insert(true);
                    Commit();

                    if Codeunit.Run(Codeunit::"Item Jnl.-Post", G_ItemJournalLine) then begin
                        L_SalesShipmentLine.Reclassified := true;
                        L_SalesShipmentLine.Modify();
                    end;
                end;

                Commit();
            until L_SalesShipmentLine.Next() = 0;
        end;
    end;

    local procedure GetLastLineNo(): Integer
    var
        Rec_ItemJournalLine: Record "Item Journal Line";
    begin
        Rec_ItemJournalLine.Reset();
        Rec_ItemJournalLine.SetRange("Journal Template Name", 'TRANSFER');
        Rec_ItemJournalLine.SetRange("Journal Batch Name", 'KNAPP');
        if Rec_ItemJournalLine.FindLast() then
            exit(Rec_ItemJournalLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetLastItemLineNo(): Integer
    var
        Rec_ItemJournalLine: Record "Item Journal Line";
    begin
        Rec_ItemJournalLine.Reset();
        Rec_ItemJournalLine.SetRange("Journal Template Name", 'ITEM');
        Rec_ItemJournalLine.SetRange("Journal Batch Name", 'KNAPP');
        if Rec_ItemJournalLine.FindLast() then
            exit(Rec_ItemJournalLine."Line No." + 10000)
        else
            exit(10000);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeItemJnlPostCode(var HideDialog: Boolean)
    begin
        //if GuiAllowed = false then
        HideDialog := true;
    end;

    var
        G_ItemJournalLine: Record "Item Journal Line";
        G_Zone: Record Zone;
}
