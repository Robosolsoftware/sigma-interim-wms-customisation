//Dont Use this codeunit for any customization++
codeunit 70105 "Purchase Variant Management"
{
    Permissions = tabledata 7312 = m, tabledata 5767 = m;
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Codeunit 90;

    ///////+++++++++++++++++++++++++++++++ Post Purchase Receipt(Variant Customization)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // //Step1++
    // //If Variant code available in Purchase line++
    // [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterInitFromPurchLine', '', false, false)]
    // local procedure OnAfterInitFromPurchLine(PurchaseLine: Record "Purchase Line"; var TrackingSpecification: Record "Tracking Specification")
    // begin
    //     if PurchaseLine."Variant Code" <> '' then begin
    //         TrackingSpecification."Custom Variant Code" := PurchaseLine."Variant Code";
    //         //TrackingSpecification.Modify();
    //     end;

    // end;


    //Step2++++
    //Item trcking Lines Custom Feilds Posting Process++++++++
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure ItemTrackingLinesOnRegisterChangeOnAfterCreateReservEntry(var ReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification")
    begin
        ReservEntry."Custom Variant Code" := OldTrackingSpecification."Custom Variant Code";
        ReservEntry.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure ItemTrackingLinesOnAfterCopyTrackingSpec(var DestTrkgSpec: Record "Tracking Specification"; var SourceTrackingSpec: Record "Tracking Specification")
    begin
        DestTrkgSpec."Custom Variant Code" := SourceTrackingSpec."Custom Variant Code";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure ItemTrackingLinesOnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin

        IdenticalArray[2] := IdenticalArray[2] and (ReservEntry1."Custom Variant Code" = ReservEntry2."Custom Variant Code");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure ItemTrackingLinesOnAfterMoveFields(var ReservEntry: Record "Reservation Entry"; var TrkgSpec: Record "Tracking Specification")
    begin
        ReservEntry."Custom Variant Code" := TrkgSpec."Custom Variant Code";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    local procedure ItemJnlPostLineOnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification"; var TempItemJournalLine: Record "Item Journal Line")
    var
        L_InventorySetup: Record "Inventory Setup";
        L_Item: Record Item;
        L_InvoiceQty: Decimal;
        L_InvoiceQtyBase: Decimal;
    begin
        TempItemJournalLine."Custom Variant Code" := TempTrackingSpecification."Custom Variant Code";



        //Step4++
        Clear(L_InvoiceQty);
        Clear(L_InvoiceQtyBase);
        //Save variant into item journal++++
        L_InventorySetup.Get();
        if L_InventorySetup."Variant Mandatory if Exists" = true then begin
            L_Item.Reset();
            L_Item.SetRange("No.", TempTrackingSpecification."Item No.");
            if L_Item.FindFirst() then begin
                if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                    if (TempTrackingSpecification."Source Type" = 83) AND (TempTrackingSpecification."Source Subtype" = 0) then begin
                        if TempItemJournalLine."Variant Code" <> TempTrackingSpecification."Variant Code" then begin
                            TempItemJournalLine."Variant Code" := TempTrackingSpecification."Variant Code";
                            L_InvoiceQty := TempItemJournalLine."Invoiced Quantity";
                            L_InvoiceQtyBase := TempItemJournalLine."Invoiced Qty. (Base)";
                            TempItemJournalLine.Validate("Variant Code");


                            //After Validate Variant code above its changed the invoice Quantity++
                            //So below I have update again with TempTrackingSpecification++
                            TempItemJournalLine.Validate("Invoiced Quantity", L_InvoiceQty);
                            TempItemJournalLine.Validate("Invoiced Qty. (Base)", L_InvoiceQtyBase);
                        end;

                    end;
                end;
            end;
        end;
        //Save variant into item journal++++
        //Step4--
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure ItemJnlPostLineOnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry."Custom Variant Code" := ItemJournalLine."Custom Variant Code";
    end;
    //Item trcking Lines Custom Feilds Posting Process++++++++




    //Step3++
    //Check Variant Code mandotory at the time posting warehouse Recipt++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnRunWithCheckOnAfterRetrieveItemTracking', '', false, false)]
    local procedure OnRunWithCheckOnAfterRetrieveItemTracking(var TrackingSpecExists: Boolean; var TempTrackingSpecification: Record "Tracking Specification")
    var
        L_Item: Record Item;
        L_InventorySetup: Record "Inventory Setup";
    begin
        if (TempTrackingSpecification."Source Type" = 83) AND (TempTrackingSpecification."Source Subtype" = 0) then begin
            L_InventorySetup.Get();
            if L_InventorySetup."Variant Mandatory if Exists" = true then begin
                if (TrackingSpecExists = true) then begin
                    if TempTrackingSpecification.FindSet() then begin
                        repeat
                            if (TempTrackingSpecification."Source Type" = 83) AND (TempTrackingSpecification."Source Subtype" = 0) AND (TempTrackingSpecification.Positive = true) then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", TempTrackingSpecification."Item No.");
                                if L_Item.FindFirst() then begin
                                    if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                                        //TempTrackingSpecification.TestField("Variant Code");
                                        if TempTrackingSpecification."Custom Variant Code" = '' then
                                            Error('Variant Code must have a value in Tracking Line: Lot No.: %1. It cannot be zero or empty.', TempTrackingSpecification."Lot No.")
                                        else begin
                                            if TempTrackingSpecification."Variant Code" <> TempTrackingSpecification."Custom Variant Code" then begin
                                                TempTrackingSpecification."Variant Code" := TempTrackingSpecification."Custom Variant Code";
                                                TempTrackingSpecification.Modify();
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        until TempTrackingSpecification.Next() = 0;
                    end;
                end;
            end;
        end;
    end;


    //Step5++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl. Line-Reserve", 'OnTransferItemJnlToItemLedgEntryOnBeforeTestVariantCode', '', false, false)]
    local procedure OnTransferItemJnlToItemLedgEntryOnBeforeTestVariantCode(var ItemJnlLine: Record "Item Journal Line"; var OldReservEntry: Record "Reservation Entry")
    var
        L_Item: Record Item;
        L_InventorySetup: Record "Inventory Setup";
    begin
        L_InventorySetup.Get();
        if L_InventorySetup."Variant Mandatory if Exists" = true then begin
            L_Item.Reset();
            L_Item.SetRange("No.", ItemJnlLine."Item No.");
            if L_Item.FindFirst() then begin
                if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                    if (OldReservEntry."Source Type" = 83) AND (OldReservEntry."Source Subtype" = 0) then begin
                        if OldReservEntry."Variant Code" <> ItemJnlLine."Variant Code" then begin
                            OldReservEntry.Validate("Variant Code", ItemJnlLine."Variant Code");
                            OldReservEntry.Modify();
                        end;
                    end;
                end;
            end;
        end;
    end;


    //Step6++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeTempWhseJnlLine2Insert', '', false, false)]
    local procedure OnBeforeTempWhseJnlLine2Insert(var TempSplitTrackingSpec: Record "Tracking Specification" temporary; TempWhseJnlLineFrom: Record "Warehouse Journal Line" temporary; WhseLNRequired: Boolean; var TempWhseJnlLineTo: Record "Warehouse Journal Line" temporary)
    var
        L_Item: Record Item;
        L_InventorySetup: Record "Inventory Setup";
    begin
        if (TempSplitTrackingSpec."Source Type" = 39) AND (TempSplitTrackingSpec."Source Subtype" = 1) then begin
            L_InventorySetup.Get();
            if L_InventorySetup."Variant Mandatory if Exists" = true then begin
                L_Item.Reset();
                L_Item.SetRange("No.", TempSplitTrackingSpec."Item No.");
                if L_Item.FindFirst() then begin
                    if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                        //if WhseLNRequired = true then begin
                        TempWhseJnlLineFrom."Custom Variant Code" := TempSplitTrackingSpec."Custom Variant Code";
                        if TempSplitTrackingSpec."Variant Code" <> TempWhseJnlLineFrom."Variant Code" then begin
                            TempWhseJnlLineFrom."Variant Code" := TempSplitTrackingSpec."Variant Code";
                            TempWhseJnlLineFrom.Validate("Variant Code");
                        end;

                        TempWhseJnlLineTo."Custom Variant Code" := TempSplitTrackingSpec."Custom Variant Code";
                        if TempSplitTrackingSpec."Variant Code" <> TempWhseJnlLineTo."Variant Code" then begin
                            TempWhseJnlLineTo."Variant Code" := TempSplitTrackingSpec."Variant Code";
                            TempWhseJnlLineTo.Validate("Variant Code");
                            //TempWhseJnlLineTo.Modify();
                        end;
                        //end;
                    end;
                end;
            end;
        end;
    end;

    //Step7++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnAfterInsertWhseEntry', '', false, false)]
    local procedure OnAfterInsertWhseEntry(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry."Custom Variant Code" := WarehouseJournalLine."Custom Variant Code";
        WarehouseEntry.Modify();
    end;

    //Step8++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnAfterWhseActivLineInsert', '', false, false)]
    local procedure OnAfterWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        L_ItemLedgerEntry: Record "Item Ledger Entry";
        L_Item: Record Item;
        L_InventorySetup: Record "Inventory Setup";
    begin
        L_InventorySetup.Get();
        if L_InventorySetup."Variant Mandatory if Exists" = true then begin
            L_Item.Reset();
            L_Item.SetRange("No.", WarehouseActivityLine."Item No.");
            if L_Item.FindFirst() then begin
                if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                    L_ItemLedgerEntry.Reset();
                    L_ItemLedgerEntry.SetRange("Item No.", WarehouseActivityLine."Item No.");
                    L_ItemLedgerEntry.SetRange("Location Code", WarehouseActivityLine."Location Code");
                    L_ItemLedgerEntry.SetRange("Lot No.", WarehouseActivityLine."Lot No.");
                    if L_ItemLedgerEntry.FindFirst() then begin
                        if WarehouseActivityLine."Variant Code" <> L_ItemLedgerEntry."Variant Code" then begin
                            WarehouseActivityLine.Validate("Variant Code", L_ItemLedgerEntry."Variant Code");
                            WarehouseActivityLine.Modify();
                        end;
                    end;
                end;
            end;
        end;
    end;


    //Step9++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertTrackingSpecification', '', false, false)]
    local procedure OnBeforeInsertTrackingSpecification(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        L_PurchaseLine: Record "Purchase Line";
    begin
        TempTrackingSpecification.Reset();
        if TempTrackingSpecification.FindSet() then
            repeat
                L_PurchaseLine.Reset();
                L_PurchaseLine.SetRange("Document Type", L_PurchaseLine."Document Type"::Order);
                L_PurchaseLine.SetRange("Document No.", TempTrackingSpecification."Source ID");
                L_PurchaseLine.SetRange("Line No.", TempTrackingSpecification."Source Ref. No.");
                if L_PurchaseLine.FindFirst() then begin
                    if L_PurchaseLine."Variant Code" = '' then begin
                        TempTrackingSpecification.Validate("Variant Code", '');
                        TempTrackingSpecification.Modify();
                    end;
                end;
            until TempTrackingSpecification.Next() = 0;
    end;

    //Step10++
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageEvent(var Rec: Record "Tracking Specification")
    var
        L_TrackingSpecification: Record "Tracking Specification";
    begin
        L_TrackingSpecification.Reset();
        L_TrackingSpecification.SetRange("Source Type", Rec."Source Type");
        L_TrackingSpecification.SetRange("Source Subtype", Rec."Source Subtype");
        L_TrackingSpecification.SetRange("Source ID", Rec."Source ID");
        L_TrackingSpecification.SetRange("Source Ref. No.", Rec."Source Ref. No.");
        L_TrackingSpecification.SetRange(Positive, Rec.Positive);
        L_TrackingSpecification.SetRange("Lot No.", Rec."Lot No.");
        if L_TrackingSpecification.FindFirst() then begin
            Rec.Validate("Custom Variant Code", L_TrackingSpecification."Custom Variant Code");
            Rec.Modify();
        end;
    end;


    //Step11++ This code (Only For Purchase) added becuse we have disabled the Lot Warehouse Tracking on Item Tracking Code++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnSplitWhseJnlLineOnAfterCheckWhseItemTrkgSetup', '', false, false)]
    local procedure OnSplitWhseJnlLineOnAfterCheckWhseItemTrkgSetup(var TempWhseSplitTrackingSpec: Record "Tracking Specification"; var TempWhseJnlLine2: Record "Warehouse Journal Line"; var IsHandled: Boolean)
    begin
        if (TempWhseSplitTrackingSpec."Source Type" = 39) AND (TempWhseSplitTrackingSpec."Source Subtype" = 1) then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Journal Line", 'OnAfterCopyTrackingFromItemTrackingSetupIfRequired', '', false, false)]
    local procedure OnAfterCopyTrackingFromItemTrackingSetupIfRequired(var WhseJnlLine: Record "Warehouse Journal Line"; WhseItemTrackingSetup: Record "Item Tracking Setup" temporary)
    begin
        if (WhseJnlLine."Source Type" = 39) AND (WhseJnlLine."Source Subtype" = 1) then
            WhseJnlLine."Lot No." := WhseItemTrackingSetup."Lot No.";
    end;

    //At the time of creating putaway. Overide Default creating putaway code and added our custom code++
    //this code run only for Purchase order++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeCreatePutAwayDoc', '', false, false)]
    local procedure OnBeforeCreatePutAwayDoc(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; var IsHandled: Boolean)
    var
        CreatePutAway: Codeunit "Create Put-away";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        TempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary;
        TempPostedWhseRcptLine2: Record "Posted Whse. Receipt Line" temporary;
        WhseSourceCreateDocument: Report "Whse.-Source - Create Document";
        RemQtyToHandleBase: Decimal;
    begin
        if PostedWhseReceiptLine."Source Document" = PostedWhseReceiptLine."Source Document"::"Purchase Order" then begin
            //Skip Default code++
            IsHandled := true;

            //Custom Code++
            RemQtyToHandleBase := PostedWhseReceiptLine."Qty. (Base)";


            CreatePutAway.SetValues('', Enum::"Whse. Activity Sorting Method"::None, false, false);
            CreatePutAway.SetCrossDockValues(true);

            ItemTrackingMgt.InitItemTrackingForTempWhseWorksheetLine(
                  Enum::"Warehouse Worksheet Document Type"::Receipt,
                  PostedWhseReceiptLine."No.", PostedWhseReceiptLine."Line No.",
                  PostedWhseReceiptLine."Source Type", PostedWhseReceiptLine."Source Subtype",
                  PostedWhseReceiptLine."Source No.", PostedWhseReceiptLine."Source Line No.", 0);

            ItemTrackingMgt.SplitPostedWhseRcptLine(PostedWhseReceiptLine, TempPostedWhseRcptLine);

            TempPostedWhseRcptLine.Reset();
            if TempPostedWhseRcptLine.Find('-') then
                repeat
                    TempPostedWhseRcptLine2 := TempPostedWhseRcptLine;
                    TempPostedWhseRcptLine2."Line No." := PostedWhseReceiptLine."Line No.";
                    WhseSourceCreateDocument.SetQuantity(TempPostedWhseRcptLine2, Database::"Posted Whse. Receipt Line", RemQtyToHandleBase);
                    CreatePutAway.Run(TempPostedWhseRcptLine2);
                until TempPostedWhseRcptLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeSplitPostedWhseReceiptLine', '', false, false)]
    local procedure OnBeforeSplitPostedWhseReceiptLine(PostedWhseRcptLine: Record "Posted Whse. Receipt Line"; var TempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary; var IsHandled: Boolean)
    var
        WhseItemEntryRelation: Record "Whse. Item Entry Relation";
        ItemLedgEntry: Record "Item Ledger Entry";
        UOMMgt: Codeunit "Unit of Measure Management";
        CrossDockQty: Decimal;
        CrossDockQtyBase: Decimal;
        LineNo: Integer;
        L_ItemTrackingManagement: Codeunit "Item Tracking Management";
        WhseItemTrackingSetup: Record "Item Tracking Setup";
    begin
        if PostedWhseRcptLine."Source Document" = PostedWhseRcptLine."Source Document"::"Purchase Order" then begin
            //Skip Default code++
            IsHandled := true;

            //Custom Code++
            TempPostedWhseRcptLine.Reset();
            TempPostedWhseRcptLine.DeleteAll();


            WhseItemEntryRelation.Reset();
            WhseItemEntryRelation.SetSourceFilter(
              Database::"Posted Whse. Receipt Line", 0, PostedWhseRcptLine."No.", PostedWhseRcptLine."Line No.", true);

            if WhseItemEntryRelation.FindSet() then begin
                repeat
                    ItemLedgEntry.Get(WhseItemEntryRelation."Item Entry No.");
                    TempPostedWhseRcptLine.SetTrackingFilterFromItemLedgEntry(ItemLedgEntry);
                    TempPostedWhseRcptLine.SetRange("Warranty Date", ItemLedgEntry."Warranty Date");
                    TempPostedWhseRcptLine.SetRange("Expiration Date", ItemLedgEntry."Expiration Date");
                    if TempPostedWhseRcptLine.FindFirst() then begin
                        TempPostedWhseRcptLine."Qty. (Base)" += ItemLedgEntry.Quantity;
                        TempPostedWhseRcptLine.Quantity :=
                          Round(
                            TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure",
                            UOMMgt.QtyRndPrecision());
                        TempPostedWhseRcptLine.Modify();

                        CrossDockQty := CrossDockQty - TempPostedWhseRcptLine."Qty. Cross-Docked";
                        CrossDockQtyBase := CrossDockQtyBase - TempPostedWhseRcptLine."Qty. Cross-Docked (Base)";
                    end else begin
                        LineNo += 10000;
                        TempPostedWhseRcptLine.Reset();
                        TempPostedWhseRcptLine := PostedWhseRcptLine;
                        TempPostedWhseRcptLine."Line No." := LineNo;
                        TempPostedWhseRcptLine.CopyTrackingFromWhseItemEntryRelation(WhseItemEntryRelation);
                        TempPostedWhseRcptLine."Warranty Date" := ItemLedgEntry."Warranty Date";
                        TempPostedWhseRcptLine."Expiration Date" := ItemLedgEntry."Expiration Date";
                        TempPostedWhseRcptLine."Qty. (Base)" := ItemLedgEntry.Quantity;
                        TempPostedWhseRcptLine.Quantity :=
                          Round(
                            TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure",
                            UOMMgt.QtyRndPrecision());
                        TempPostedWhseRcptLine.Insert();
                    end;


                    L_ItemTrackingManagement.GetWhseItemTrkgSetup(PostedWhseRcptLine."Item No.", WhseItemTrackingSetup);

                    if WhseItemTrackingSetup."Serial No. Required" then begin
                        if CrossDockQty < PostedWhseRcptLine."Qty. Cross-Docked" then begin
                            TempPostedWhseRcptLine."Qty. Cross-Docked" := TempPostedWhseRcptLine.Quantity;
                            TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptLine."Qty. (Base)";
                        end else begin
                            TempPostedWhseRcptLine."Qty. Cross-Docked" := 0;
                            TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
                        end;
                        CrossDockQty := CrossDockQty + TempPostedWhseRcptLine.Quantity;
                    end else
                        if PostedWhseRcptLine."Qty. Cross-Docked" > 0 then begin
                            if TempPostedWhseRcptLine.Quantity <=
                               PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty
                            then begin
                                TempPostedWhseRcptLine."Qty. Cross-Docked" := TempPostedWhseRcptLine.Quantity;
                                TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptLine."Qty. (Base)";
                            end else begin
                                TempPostedWhseRcptLine."Qty. Cross-Docked" := PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty;
                                TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" :=
                                  PostedWhseRcptLine."Qty. Cross-Docked (Base)" - CrossDockQtyBase;
                            end;
                            CrossDockQty := CrossDockQty + TempPostedWhseRcptLine."Qty. Cross-Docked";
                            CrossDockQtyBase := CrossDockQtyBase + TempPostedWhseRcptLine."Qty. Cross-Docked (Base)";
                            if CrossDockQty >= PostedWhseRcptLine."Qty. Cross-Docked" then begin
                                PostedWhseRcptLine."Qty. Cross-Docked" := 0;
                                PostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
                            end;
                        end;
                    TempPostedWhseRcptLine.Modify();
                until WhseItemEntryRelation.Next() = 0;
            end else begin
                TempPostedWhseRcptLine := PostedWhseRcptLine;
                TempPostedWhseRcptLine.Insert();
            end;
        end;
    end;

    //Step11++ This code added becuse we have disabled the Lot Warehouse Tracking on Item Tracking Code++

    ///////------------------------------- Post Purchase Receipt(Variant Customization)----------------------------------------------------------








    ///////+++++++++++++++++++++++++++++++ Post Purchase Invoice(Variant Customization)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    //Step1++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterRetrieveInvoiceTrackingSpecificationIfExists', '', false, false)]
    local procedure OnAfterRetrieveInvoiceTrackingSpecificationIfExists(var TrackingSpecificationExists: Boolean; var TempTrackingSpecification: Record "Tracking Specification" temporary; var PurchaseLine: Record "Purchase Line")
    var
        L_Item: Record Item;
        L_InventorySetup: Record "Inventory Setup";
    begin
        L_InventorySetup.Get();
        if L_InventorySetup."Variant Mandatory if Exists" = true then begin
            if TempTrackingSpecification.FindSet() then begin
                repeat
                    L_Item.Reset();
                    L_Item.SetRange("No.", TempTrackingSpecification."Item No.");
                    if L_Item.FindFirst() then begin
                        if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                            if TrackingSpecificationExists then begin
                                if (TempTrackingSpecification."Source Type" = 39) AND (TempTrackingSpecification."Source Subtype" = 1) then begin
                                    if PurchaseLine."Variant Code" = '' then begin
                                        TempTrackingSpecification.Validate("Variant Code", TempTrackingSpecification."Custom Variant Code");
                                        TempTrackingSpecification.Modify();
                                    end;
                                end;
                            end;
                        end;
                    end;
                until TempTrackingSpecification.Next() = 0;
            end;
        end;

    end;

    //Step2++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnAfterPrepareItemJnlLine', '', false, false)]
    local procedure OnPostItemJnlLineOnAfterPrepareItemJnlLine(QtyToBeReceived: Decimal; TrackingSpecification: Record "Tracking Specification"; var ItemJournalLine: Record "Item Journal Line"; PurchaseLine: Record "Purchase Line")
    var
        L_Item: Record Item;
        L_InventorySetup: Record "Inventory Setup";
        L_InvoicedQty: Decimal;
        L_InvoicedQtyBase: Decimal;
    begin
        Clear(L_InvoicedQty);
        Clear(L_InvoicedQtyBase);
        L_InventorySetup.Get();
        if L_InventorySetup."Variant Mandatory if Exists" = true then begin
            L_Item.Reset();
            L_Item.SetRange("No.", PurchaseLine."No.");
            if L_Item.FindFirst() then begin
                if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                    if QtyToBeReceived = 0 then begin
                        if PurchaseLine."Variant Code" = '' then begin
                            ItemJournalLine."Variant Code" := TrackingSpecification."Variant Code";
                            L_InvoicedQty := ItemJournalLine."Invoiced Quantity";
                            L_InvoicedQtyBase := ItemJournalLine."Invoiced Qty. (Base)";
                            ItemJournalLine.Validate("Variant Code");

                            //After Validate Variant code above its changed the invoice Quantity++
                            //So below I have update again with TempTrackingSpecification++
                            ItemJournalLine.Validate("Invoiced Quantity", L_InvoicedQty);
                            ItemJournalLine.Validate("Invoiced Qty. (Base)", L_InvoicedQtyBase);
                        end;
                    end;
                end;
            end;
        end;

    end;

    ///////------------------------------- Post Purchase Invoice(Variant Customization)----------------------------------------------------------


    //////-------------------------------- Normal Business Purchase Process ----------------------------------------------------------------------
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure No_OnAfterValidateEvent(var Rec: Record "Purchase Line")
    var
        L_ItemVendor: Record "Item Vendor";
        L_PurchaseHeader: Record "Purchase Header";
    begin
        L_PurchaseHeader.Reset();
        L_PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        L_PurchaseHeader.SetRange("No.", Rec."Document No.");
        if L_PurchaseHeader.FindFirst() then begin
            if L_PurchaseHeader."Document Type" = L_PurchaseHeader."Document Type"::Order then begin
                if (Rec."No." <> '') AND (Rec.Type = Rec.Type::Item) then begin
                    L_ItemVendor.Reset();
                    L_ItemVendor.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                    L_ItemVendor.SetRange("Item No.", Rec."No.");
                    if L_ItemVendor.FindFirst() then begin
                        if L_ItemVendor."Variant Code" <> '' then
                            Rec.Validate("Variant Code", L_ItemVendor."Variant Code");
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnAfterPurchLineSetFilters', '', false, false)]
    local procedure OnCodeOnAfterPurchLineSetFilters(var PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header")
    var
        L_ItemVendor: Record "Item Vendor";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if PurchaseLine.FindSet() then begin
                repeat
                    if PurchaseLine."Variant Code" = '' then begin
                        L_ItemVendor.Reset();
                        L_ItemVendor.SetRange("Vendor No.", PurchaseLine."Buy-from Vendor No.");
                        L_ItemVendor.SetRange("Item No.", PurchaseLine."No.");
                        if L_ItemVendor.FindFirst() then begin
                            if L_ItemVendor."Variant Code" <> '' then begin
                                PurchaseLine.Validate("Variant Code", L_ItemVendor."Variant Code");
                                PurchaseLine.Modify();
                            end;
                        end;
                    end;
                until PurchaseLine.Next() = 0;
            end;
        end;
    end;
    //////++++++++++++++++++++++++++++++++ Normal Business Purchase Process ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

}