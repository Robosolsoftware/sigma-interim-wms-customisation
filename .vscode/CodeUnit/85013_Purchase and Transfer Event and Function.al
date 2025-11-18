codeunit 85013 "Purchase Event & Function"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_LocationCode: Code[20];
        G_PurchaseOrderNo: Code[20];

    #region Customization related for Order date for PO++++++
    //Step1 
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforePriceMessageIfPurchLinesExist, '', false, false)]
    local procedure OnBeforePriceMessageIfPurchLinesExist(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            IsHandled := true;

            if PurchLinesExist(PurchaseHeader) then begin
                PurchaseHeader.UpdatePurchLinesByFieldNo(PurchaseHeader.FieldNo("Order Date"), false);
            end;
        end;
    end;

    //Step2
    procedure PurchLinesExist(_PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.ReadIsolation := IsolationLevel::ReadUncommitted;
        PurchLine.SetRange("Document Type", _PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", _PurchaseHeader."No.");
        exit(not PurchLine.IsEmpty);
    end;
    #endregion Customization related for Order date for PO++++++


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforeUpdatePurchLinesByFieldNo, '', false, false)]
    local procedure OnBeforeUpdatePurchLinesByFieldNo(var AskQuestion: Boolean; var PurchaseHeader: Record "Purchase Header"; ChangedFieldNo: Integer; var IsHandled: Boolean)
    var
        L_PurchaseLine: Record "Purchase Line";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if ChangedFieldNo = PurchaseHeader.FieldNo("Order Date") then
                AskQuestion := false
            else
                if ChangedFieldNo = PurchaseHeader.FieldNo("Requested Receipt Date") then
                    IsHandled := true
                else
                    if ChangedFieldNo = PurchaseHeader.FieldNo("Promised Receipt Date") then
                        IsHandled := true;
        end;
    end;

    #Region Skip to create warehouse Receive GNA purchase line++++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", OnBeforePurchaseLineOnAfterGetRecord, '', false, false)]
    local procedure OnBeforePurchaseLineOnAfterGetRecord(PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        if PurchaseLine."Unable to Receive" <> '' then
            IsHandled := true;
    end;
    #EndRegion Skip to create warehouse Receive GNA purchase line++++

    #Region Skip Error meesage at the time of Release Purchase order from Upload Template+++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Batch Processing Mgt.", 'OnBatchProcessOnBeforeResetBatchID', '', false, false)]
    local procedure OnBatchProcessOnBeforeResetBatchID(var RecRef: RecordRef)
    var
        L_PurchaseHeader: Record "Purchase Header";
    begin
        if RecRef.Number = 38 then begin
            Clear(G_PurchaseOrderNo);
            L_PurchaseHeader.Reset();
            RecRef.SetTable(L_PurchaseHeader);
            G_PurchaseOrderNo := L_PurchaseHeader."No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Batch Processing Mgt.", 'OnBatchProcessOnBeforeShowMessage', '', false, false)]
    local procedure OnBatchProcessOnBeforeShowMessage(var IsHandled: Boolean)
    var
        L_PurchaseHeader: Record "Purchase Header";
    begin
        L_PurchaseHeader.Reset();
        L_PurchaseHeader.SetRange("Document Type", L_PurchaseHeader."Document Type"::Order);
        L_PurchaseHeader.SetRange("No.", G_PurchaseOrderNo);
        if L_PurchaseHeader.FindFirst() then begin
            if L_PurchaseHeader."Sheet Name" <> '' then
                IsHandled := true;
        end;
    end;
    #endregion Skip Error meesage at the time of Release Purchase order from Upload Template+++



    #Region Bin code Warehouse Class Code Missmatch Customization+++
    //Step1+++ Purchase Line Location Code not mandatory++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeMandatoryFields', '', false, false)]
    local procedure OnBeforeMandatoryFields(PurchaseHeader: Record "Purchase Header")
    var
        InvtSetup: Record "Inventory Setup";
    begin
        // Check Header location if line location is not mandatory++
        // This is code for skip default error meesage for Variant code++
        Clear(G_LocationCode);
        //Clear(G_FromPOScreen);
        InvtSetup.Get();
        if not InvtSetup."Location Mandatory" then begin
            if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) OR (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Quote) then begin
                G_LocationCode := PurchaseHeader."Location Code";
                //G_FromPOScreen := true;


                //Check Warehouse class code missmatch+++
                // Check Header location if line location is not mandatory++
                CheckWarehouseClassCodePOHeaderlevel(PurchaseHeader);

            end;
        end;
    end;

    //Step1+++ Purchase Line Location Code mandatory++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnCheckPurchLineLocationCode', '', false, false)]
    local procedure OnCodeOnCheckPurchLineLocationCode(var PurchaseLine: Record "Purchase Line")
    var
        InvtSetup: Record "Inventory Setup";
        tes: Codeunit 1620;
    //tes: Codeunit 80;
    begin
        // Check Line location if line location is mandatory++
        // This is code for skip default error meesage for Variant code++
        Clear(G_LocationCode);
        //Clear(G_FromPOScreen);
        InvtSetup.Get();
        if InvtSetup."Location Mandatory" then begin
            if (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) OR (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Quote) then begin
                G_LocationCode := PurchaseLine."Location Code";
                //G_FromPOScreen := true;

                //Check Warehouse class code missmatch+++
                // Check Line location if line location is mandatory++
                CheckWarehouseClassCodePOLinelevel(PurchaseLine);

            end;
        end;
    end;

    // //Step2++
    // [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeIsVariantMandatory', '', false, false)]
    // local procedure OnBeforeIsVariantMandatory(var IsHandled: Boolean; var Result: Boolean)
    // var
    //     L_Location: Record Location;
    // begin
    //     //This is code for skip default error meesage for Variant code + +
    //     //if G_FromPOScreen = true then begin
    //     if G_LocationCode <> '' then begin
    //         L_Location.Reset();
    //         if L_Location.Get(G_LocationCode) then begin
    //             if L_Location."Require Receive" = true then begin
    //                 IsHandled := true;
    //                 Result := false;
    //             end;
    //         end;
    //     end;
    //     Clear(G_LocationCode);
    //     //end;
    // end;


    local procedure CheckWarehouseClassCodePOHeaderlevel(_PurchaseHeader: Record "Purchase Header")
    var
        Bin: Record Bin;
        L_PurchaseLine: Record "Purchase Line";
    begin
        L_PurchaseLine.Reset();
        L_PurchaseLine.SetRange("Document No.", _PurchaseHeader."No.");
        L_PurchaseLine.SetRange("Document Type", _PurchaseHeader."Document Type");
        L_PurchaseLine.SetRange(Type, L_PurchaseLine.Type::Item);
        if L_PurchaseLine.FindSet() then begin
            repeat
                Bin.Reset();
                Bin.SetRange("Location Code", _PurchaseHeader."Location Code");
                Bin.SetRange("Warehouse Class Code", L_PurchaseLine."Warehouse Class Code");
                if not Bin.FindFirst() then
                    Error('Warehouse class Code: %1 missmatch for Location: %2. Puchase Line No. %3', L_PurchaseLine."Warehouse Class Code", _PurchaseHeader."Location Code", L_PurchaseLine."Line No.");
            until L_PurchaseLine.Next() = 0;
        end;

    end;

    procedure CheckWarehouseClassCodePOLinelevel(_PurchaseLine: Record "Purchase Line")
    var
        Bin: Record Bin;
    begin
        Bin.Reset();
        Bin.SetRange("Location Code", _PurchaseLine."Location Code");
        Bin.SetRange("Warehouse Class Code", _PurchaseLine."Warehouse Class Code");
        if not Bin.FindFirst() then
            Error('Warehouse class Code: %1 missmatch for Location: %2. Puchase Line No. %3', _PurchaseLine."Warehouse Class Code", _PurchaseLine."Location Code", _PurchaseLine."Line No.");
    end;
    #endregion Bin code Warehouse Class Code Missmatch Customization+++

    #Region Check Min Order Validation on PO+++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnPerformManualReleaseOnBeforeTestPurchasePrepayment', '', false, false)]
    local procedure OnPerformManualReleaseOnBeforeTestPurchasePrepayment(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if PurchaseHeader."Min Order Value" > 0 then begin
                PurchaseHeader.CalcFields(Amount);
                if PurchaseHeader.Amount < PurchaseHeader."Min Order Value" then
                    Error('Total order amount %1 is less than Min Order Value %2', PurchaseHeader.Amount, PurchaseHeader."Min Order Value");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    local procedure OnAfterCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if PurchaseHeader."Min Order Value" > 0 then begin
                PurchaseHeader.CalcFields(Amount);
                if PurchaseHeader.Amount < PurchaseHeader."Min Order Value" then
                    Error('Total order amount %1 is less than Min Order Value %2', PurchaseHeader.Amount, PurchaseHeader."Min Order Value");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostInvoice', '', false, false)]
    local procedure OnAfterPostInvoice(var PurchHeader: Record "Purchase Header"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var

    begin

        VendorLedgerEntry."Purchase Order No." := PurchHeader."Purchase Order No.";
        VendorLedgerEntry.Modify();

    end;

    #endregion Check Min Order Validation on PO+++

    #Region Update Transfer Line Fields to Posted Document++++
    [EventSubscriber(ObjectType::Table, database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure OnAfterCopyFromTransferShpLine(TransferLine: Record "Transfer Line"; var TransferShipmentLine: Record "Transfer Shipment Line")
    begin
        TransferShipmentLine.Brand := TransferLine.Brand;
        TransferShipmentLine."Pack Size" := TransferLine."Pack Size";
        TransferShipmentLine."Warehouse Class Code" := TransferLine."Warehouse Class Code";
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Receipt Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure OnAfterCopyFromTransferRcpLine(TransferLine: Record "Transfer Line"; var TransferReceiptLine: Record "Transfer Receipt Line")
    begin
        TransferReceiptLine.Brand := TransferLine.Brand;
        TransferReceiptLine."Pack Size" := TransferLine."Pack Size";
        TransferReceiptLine."Warehouse Class Code" := TransferLine."Warehouse Class Code";
    end;
    #endregion Update Transfer Line Fields to Posted Document++++

    #Region Check Reason Code On Item journal Post+++
    [EventSubscriber(ObjectType::Page, Page::"Item Journal", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure CheckingReason(var Rec: Record "Item Journal Line")
    var
    begin
        if Rec.FindSet then begin
            repeat
                if Rec."Reason Code" = '' then begin
                    Error('Please enter Reason code Item Line No.:%1', Rec."Line No.");
                end
            until Rec.Next = 0;
        end;

    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Journal", 'OnBeforeActionEvent', 'Post and &Print', false, false)]
    local procedure CheckingReasonPP(var Rec: Record "Item Journal Line")
    var
    begin
        if Rec.FindSet then begin
            repeat
                if Rec."Reason Code" = '' then begin
                    Error('Please enter Reason code Item Line No.:%1', Rec."Line No.");
                end
            until Rec.Next = 0;
        end;

    end;
    #endregion Check Reason Code On Item journal Post+++

    #Region Update Customized Fields on Warehouse Recpt Header & line From Purchase Order+++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateRcptHeader', '', false, false)]
    local procedure OnAfterCreateRcptHeader(PurchaseLine: Record "Purchase Line"; var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        L_PurchaseHeader: Record "Purchase Header";
    begin
        L_PurchaseHeader.Reset();
        L_PurchaseHeader.SetRange("Document Type", PurchaseLine."Document Type");
        L_PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
        if L_PurchaseHeader.FindFirst() then begin
            WarehouseReceiptHeader."Purchase Order No." := L_PurchaseHeader."No.";
            WarehouseReceiptHeader."Purchase Order Date" := L_PurchaseHeader."Order Date";
            WarehouseReceiptHeader."Supplier Name" := L_PurchaseHeader."Buy-from Vendor Name";
            WarehouseReceiptHeader."Requested Receipt Date" := L_PurchaseHeader."Requested Receipt Date";
            WarehouseReceiptHeader.Locationcode := L_PurchaseHeader."Location Code";
            WarehouseReceiptHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterPostDataItemPurchaseHeader', '', false, false)]
    local procedure OnAfterPostDataItemPurchaseHeader(var WhseReceiptHeader: Record "Warehouse Receipt Header"; var PurchaseHeader: Record "Purchase Header")
    var
        L_WarehouseRecptLine: Record "Warehouse Receipt Line";
        L_WarehouseClasses: Record "Warehouse Class";
        L_CDFound: Boolean;
        L_FridgeFound: Boolean;
    begin
        Clear(L_CDFound);
        Clear(L_FridgeFound);
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if WhseReceiptHeader."No." = '' then
                exit;

            L_WarehouseRecptLine.Reset();
            L_WarehouseRecptLine.SetRange("No.", WhseReceiptHeader."No.");
            if L_WarehouseRecptLine.FindSet() then begin
                WhseReceiptHeader."No. of Items" := L_WarehouseRecptLine.Count;

                L_WarehouseRecptLine.CalcSums(Quantity);
                WhseReceiptHeader."Total Order Qty" := L_WarehouseRecptLine.Quantity;
            end;


            L_WarehouseRecptLine.Reset();
            L_WarehouseRecptLine.SetRange("No.", WhseReceiptHeader."No.");
            if L_WarehouseRecptLine.FindSet() then begin
                repeat
                    L_WarehouseClasses.Reset();
                    L_WarehouseClasses.SetRange(Code, L_WarehouseRecptLine."Warehouse Class Code");
                    if L_WarehouseClasses.FindFirst() then begin
                        if L_WarehouseClasses.CD = true then begin
                            WhseReceiptHeader.CD := WhseReceiptHeader.CD::Yes;
                            WhseReceiptHeader."CD Qty" += L_WarehouseRecptLine.Quantity;
                            L_CDFound := true;
                        end;

                        if L_WarehouseClasses.Fridge = true then begin
                            WhseReceiptHeader.Fridge := WhseReceiptHeader.Fridge::Yes;
                            WhseReceiptHeader."Fridge Qty." += L_WarehouseRecptLine.Quantity;
                            L_FridgeFound := true;
                        end;

                    end;
                until L_WarehouseRecptLine.Next() = 0;

                //Update if Not CD and Fridge Product found++
                if L_CDFound = false then
                    WhseReceiptHeader.CD := WhseReceiptHeader.CD::No;
                if L_FridgeFound = false then
                    WhseReceiptHeader.Fridge := WhseReceiptHeader.Fridge::No;
            end;

            WhseReceiptHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchases Warehouse Mgt.", 'OnAfterCreateRcptLineFromPurchLine', '', false, false)]
    local procedure OnAfterCreateRcptLineFromPurchLine(PurchaseLine: Record "Purchase Line"; var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        L_Item: Record Item;
    begin
        if L_Item.Get(PurchaseLine."No.") then begin
            WarehouseReceiptLine."Pack Size" := L_Item."Pack Size";
            WarehouseReceiptLine.Brand := L_Item.Brand;
            WarehouseReceiptLine."Warehouse Class Code" := L_Item."Warehouse Class Code";
            WarehouseReceiptLine."Item Category Code" := L_Item."Item Category Code";
            WarehouseReceiptLine.Modify();
        end;
    end;
    #endregion Update Customized Fields on Warehouse Recpt Header From Purchase Order+++

    #Region Update Customized Fields on Warehouse Recpt Line & From Transfer Line+++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Warehouse Mgt.", 'OnAfterCreateRcptLineFromTransLine', '', false, false)]
    local procedure OnAfterCreateRcptLineFromTransLine(TransferLine: Record "Transfer Line"; var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        L_Item: Record Item;
    begin
        if L_Item.Get(TransferLine."Item No.") then begin
            WarehouseReceiptLine."Pack Size" := L_Item."Pack Size";
            WarehouseReceiptLine.Brand := L_Item.Brand;
            WarehouseReceiptLine."Warehouse Class Code" := L_Item."Warehouse Class Code";
            WarehouseReceiptLine."Item Category Code" := L_Item."Item Category Code";
            WarehouseReceiptLine.Modify();
        end;
    end;
    #endregion Update Customized Fields on Warehouse Recpt Line & From Transfer Line+++

    // #Region Update Customized Fields on Warehouse Recp Header and Line From Tranfer Header and Line+++
    // [EventSubscriber(ObjectType::Page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'Post and &Print', true, true)]
    // local procedure UpdatingTransferHeaderNew(var Rec: Record "Warehouse Shipment Header")
    // var
    //     transferRelease: Codeunit "Release Transfer Document";
    //     RecTransferHeader: Record "Transfer Header";
    //     WhseShptLine: Record "Warehouse Shipment Line";
    //     WhseShptLine1: Record "Warehouse Shipment Line";
    //     RectransferLine: Record "Transfer Line";
    // //RecCustomer: Record Customer;
    // begin
    //     //finding Whse. Shp header++
    //     WhseShptLine.Reset();
    //     WhseShptLine.SetRange("No.", Rec."No.");
    //     if WhseShptLine.FindSet() then begin
    //         repeat
    //             //finding Whse. recpt header--

    //             //Finding saeles Header++
    //             RecTransferHeader.Reset();
    //             RecTransferHeader.SetRange("No.", WhseShptLine."Source No.");
    //             if RecTransferHeader.FindFirst() then begin
    //                 RecTransferHeader.VALIDATE("Requested By", Rec."Requested By");
    //                 RecTransferHeader.Validate("Time of Shipment", Rec."Time of Shipment");
    //                 RecTransferHeader.Validate("Time of Receipt", Rec."Time of Receipt");
    //                 RecTransferHeader.Validate("Vehicle Reg No.", Rec."Vehicle Reg No.");
    //                 RecTransferHeader.Validate("Pallet ID", Rec."Pallet ID");
    //                 RecTransferHeader.Validate("Shipped By", Rec."Shipped By");
    //                 RecTransferHeader.Validate("Receipted By", Rec."Receipted By");
    //                 RecTransferHeader.Validate(Comments, Rec.Comments);
    //                 RecTransferHeader.Validate("Seal No.", Rec."Seal No.");
    //                 RecTransferHeader.MODIFY;
    //             end;
    //         until WhseShptLine.Next() = 0;
    //     end;
    //     //Commit();
    // end;

    // [EventSubscriber(ObjectType::Page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'P&ost Shipment', true, true)]
    // local procedure UpdatingtrnHeaderNew(var Rec: Record "Warehouse Shipment Header")
    // var
    //     transferRelease: Codeunit "Release Transfer Document";
    //     RecTransferHeader: Record "Transfer Header";
    //     WhseShptLine: Record "Warehouse Shipment Line";
    //     WhseShptLine1: Record "Warehouse Shipment Line";
    //     RectransferLine: Record "Transfer Line";
    // //RecCustomer: Record Customer;
    // begin
    //     //finding Whse. Shp header++
    //     WhseShptLine.Reset();
    //     WhseShptLine.SetRange("No.", Rec."No.");
    //     if WhseShptLine.FindSet() then begin
    //         repeat
    //             //finding Whse. recpt header--

    //             //Finding saeles Header++
    //             RecTransferHeader.Reset();
    //             RecTransferHeader.SetRange("No.", WhseShptLine."Source No.");
    //             if RecTransferHeader.FindFirst() then begin
    //                 RecTransferHeader.VALIDATE("Requested By", Rec."Requested By");
    //                 RecTransferHeader.Validate("Time of Shipment", Rec."Time of Shipment");
    //                 RecTransferHeader.Validate("Time of Receipt", Rec."Time of Receipt");
    //                 RecTransferHeader.Validate("Vehicle Reg No.", Rec."Vehicle Reg No.");
    //                 RecTransferHeader.Validate("Pallet ID", Rec."Pallet ID");
    //                 RecTransferHeader.Validate("Shipped By", Rec."Shipped By");
    //                 RecTransferHeader.Validate("Receipted By", Rec."Receipted By");
    //                 RecTransferHeader.Validate(Comments, Rec.Comments);
    //                 RecTransferHeader.Validate("Seal No.", Rec."Seal No.");
    //                 RecTransferHeader.MODIFY;
    //             end;
    //         until WhseShptLine.Next() = 0;
    //     end;
    //     //Commit();
    // end;
    // #endregion Update Customized Fields on Warehouse shipment Header and Line From Tranfer Header and Line+++

    #Region Clear Fields on Transfer Line++
    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure clearFileds(CurrFieldNo: Integer; var Rec: Record "Transfer Line")
    var
        Recitem: Record Item;
    begin
        Rec.Validate("Transfer-from Bin Code", '');
        Rec.Validate("Transfer-To Bin Code", '');
        Recitem.Reset();
        Recitem.SetRange("No.", Rec."Item No.");
        if Recitem.FindFirst() then begin
            Rec.Validate("Warehouse Class Code", Recitem."Warehouse Class Code");
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Transfer-from Bin Code', false, false)]
    local procedure clearFiledsFrmQty(CurrFieldNo: Integer; var Rec: Record "Transfer Line")
    begin
        Rec.Validate(Quantity, 0);
        // Rec.Validate("Transfer-To Bin Code", '');
    end;
    #endregion Clear Fields on Transfer Line++


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnInitPurchOrderLineOnBeforeValidateLineDiscount', '', false, false)]
    local procedure OnInitPurchOrderLineOnBeforeValidateLineDiscount(RequisitionLine: Record "Requisition Line"; var PurchOrderLine: Record "Purchase Line")
    begin
        PurchOrderLine.Validate("Direct Unit Cost", RequisitionLine."Direct Unit Cost");
        //PurchOrderLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnBeforePostPurchLine', '', false, false)]
    local procedure CheckVariantQAUApproval(var PurchLine: Record "Purchase Line")
    var
        ItemVariant: Record "Item Variant";
    begin
        if (PurchLine."Variant Code" <> '') AND (PurchLine."Qty. to Receive" <> 0) then begin

            if ItemVariant.Get(PurchLine."No.", PurchLine."Variant Code") then begin
                if not ItemVariant."Variant Approval" then
                    Error('Variant %1 for Item %2 is not Variant Approved. Receipt cannot be posted.', PurchLine."Variant Code", PurchLine."No.");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', false, false)]
    local procedure OnBeforeInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line")
    begin
        TransShptLine."Orignial Transfer Order Qty" := TransLine.Quantity;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', false, false)]
    local procedure OnBeforeInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line")
    begin
        TransRcptLine."Orignial Transfer Order Qty" := TransLine.Quantity;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure OnBeforeInsertTransShptHdr(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header")
    begin
        TransShptHeader."Transfer-To Zone Code" := TransHeader."Transfer-To Zone Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeInsertTransRcptHdr(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Transfer-To Zone Code" := TransferHeader."Transfer-To Zone Code";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeModifyEvent', '', true, true)]
    local procedure RestrictPurchInvModify(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        UserSetup: Record "User Setup";
        ErrTxt: Label 'You are not allowed to modify Purchase Invoices. Contact your administrator.';
    begin
        if Rec."Document Type" = Rec."Document Type"::Invoice then begin
            if UserSetup.Get(UserId) then begin
                if not UserSetup."Allow Purch Inv Edit" then
                    Error(ErrTxt);
            end else
                Error(ErrTxt);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeModifyEvent', '', true, true)]
    local procedure RestrictPurchInvLineModify(var Rec: Record "Purchase Line")
    var
        UserSetup: Record "User Setup";
        ErrTxt: Label 'You are not allowed to modify Purchase Invoices. Contact your administrator.';
    begin
        if Rec."Document Type" = Rec."Document Type"::Invoice then begin
            if UserSetup.Get(UserId) then begin
                if not UserSetup."Allow Purch Inv Edit" then
                    Error(ErrTxt);
            end else
                Error(ErrTxt);
        end;
    end;
}
