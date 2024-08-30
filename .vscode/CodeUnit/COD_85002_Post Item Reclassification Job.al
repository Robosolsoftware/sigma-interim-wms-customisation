codeunit 85002 "Post Item Reclassification"
{
    Permissions = tabledata "Sales Shipment Line" = rimd;

    trigger OnRun()
    var
        L_KnappLocation: Record Location;
        L_SaleableLocation: Record Location;
    begin
        L_KnappLocation.Reset();
        L_KnappLocation.SetRange("Knapp Location", true);
        if L_KnappLocation.FindSet() then begin
            repeat
                L_SaleableLocation.Reset();
                L_SaleableLocation.SetRange("Saleable Location", true);
                if L_SaleableLocation.FindFirst() then
                    PostItemReclassification(L_KnappLocation.Code, L_SaleableLocation.Code);
            until L_KnappLocation.Next() = 0;
        end;
    end;

    local procedure PostItemReclassification(P_KnappLocation: Code[10]; P_SaleableLocation: Code[10])
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
        //L_SalesShipmentLine.SetFilter("Document No.", '%1', '156709');
        if L_SalesShipmentLine.FindSet() then begin
            repeat
                Clear(RequiredQuantity);
                RequiredQuantity := L_SalesShipmentLine.Quantity;

                L_BinContent.Reset();
                L_BinContent.SetRange("Location Code", P_SaleableLocation);
                L_BinContent.SetRange("Zone Code", 'HDH');
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

                if BinCode <> '' then begin
                    L_ItemJournalLine.Reset();
                    L_ItemJournalLine.SetRange("Journal Template Name", 'TRANSFER');
                    L_ItemJournalLine.SetRange("Journal Batch Name", 'KNAPP');
                    L_ItemJournalLine.SetRange("Item No.", L_SalesShipmentLine."No.");
                    if L_SalesShipmentLine."Variant Code" <> '' then
                        L_ItemJournalLine.SetRange("Variant Code", L_SalesShipmentLine."Variant Code");
                    L_ItemJournalLine.SetRange("Location Code", P_SaleableLocation);
                    L_ItemJournalLine.SetRange("New Location Code", P_KnappLocation);
                    L_ItemJournalLine.SetRange("Bin Code", BinCode);
                    L_ItemJournalLine.SetRange("External Document No.", L_SalesShipmentLine."Order No.");
                    L_ItemJournalLine.SetRange(Quantity, L_SalesShipmentLine.Quantity);
                    if L_ItemJournalLine.FindFirst() then begin
                        if Codeunit.Run(Codeunit::"Item Jnl.-Post", L_ItemJournalLine) then begin
                            L_SalesShipmentLine.Reclassified := true;
                            L_SalesShipmentLine.Modify();
                        end;
                    end
                    else begin
                        G_ItemJournalLine.Reset();
                        G_ItemJournalLine.Init();
                        G_ItemJournalLine.Validate("Journal Template Name", 'TRANSFER');
                        G_ItemJournalLine.Validate("Journal Batch Name", 'KNAPP');
                        G_ItemJournalLine.Validate("Entry Type", G_ItemJournalLine."Entry Type"::Transfer);

                        // ItemJournalBatch.Reset();
                        // ItemJournalBatch.SetRange("Journal Template Name", 'TRANSFER');
                        // ItemJournalBatch.SetRange(Name, 'KNAPP');
                        // if ItemJournalBatch.FindFirst() then begin
                        //     G_ItemJournalLine."Document No." := NoSeriesManagement.GetNextNo(ItemJournalBatch."No. Series", WorkDate());
                        // end;

                        G_ItemJournalLine."Document No." := L_SalesShipmentLine."Document No.";
                        G_ItemJournalLine."Document Line No." := L_SalesShipmentLine."Line No.";
                        G_ItemJournalLine.Validate("Line No.", GetLastLineNo());
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

    local procedure PostItemJournalLine(var P_ItemJournalLine: Record "Item Journal Line")
    var

    begin
        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", P_ItemJournalLine);
    end;

    var
        G_ItemJournalLine: Record "Item Journal Line";
}