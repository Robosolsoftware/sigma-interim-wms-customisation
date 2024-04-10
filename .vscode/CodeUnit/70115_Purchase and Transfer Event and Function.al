codeunit 70115 "Purchase Event & Function"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_LocationCode: Code[20];

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
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
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
    begin
        // Check Line location if line location is mandatory++
        // This is code for skip default error meesage for Variant code++
        Clear(G_LocationCode);
        //Clear(G_FromPOScreen);
        InvtSetup.Get();
        if InvtSetup."Location Mandatory" then begin
            if PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order then begin
                G_LocationCode := PurchaseLine."Location Code";
                //G_FromPOScreen := true;

                //Check Warehouse class code missmatch+++
                // Check Line location if line location is mandatory++
                CheckWarehouseClassCodePOLinelevel(PurchaseLine);

            end;
        end;
    end;

    //Step2++
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeIsVariantMandatory', '', false, false)]
    local procedure OnBeforeIsVariantMandatory(var IsHandled: Boolean; var Result: Boolean)
    var
        L_Location: Record Location;
    begin
        //This is code for skip default error meesage for Variant code + +
        //if G_FromPOScreen = true then begin
        if G_LocationCode <> '' then begin
            L_Location.Reset();
            if L_Location.Get(G_LocationCode) then begin
                if L_Location."Require Receive" = true then begin
                    IsHandled := true;
                    Result := false;
                end;
            end;
        end;
        Clear(G_LocationCode);
        //end;
    end;


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

    #Region Update Customized Fields on Warehouse Recpt Header From PO header+++
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
        end;
    end;
    #endregion Update Customized Fields on Warehouse Recpt Header From PO header+++


    #Region Update Customized Fields on Warehouse shipment Header and Line From Tranfer Header and Line+++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateWhseDocuments', '', false, false)]
    local procedure UpdateWarehouseReceipt(var WhseShipmentHeader: Record "Warehouse Shipment Header"; var WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        TransferHeader: Record "Transfer Header";
        RecWhseShpLine: Record "Warehouse Shipment Line";
        RecWhseRcpLine: Record "Warehouse Receipt Line";
        TransferLineLine1: Record "Transfer Line";
        PurchaseLine: Record "Purchase Line";
        warehouseClassCode: Boolean;
        warehouseClasses: Record "Warehouse Class";
        WhseRcptLine: Record "Warehouse Receipt Line";
        PurchaseHeader: Record "Purchase Header";
        i: Integer;

    begin
        RecWhseShpLine.Reset();
        RecWhseShpLine.SetRange("No.", WhseShipmentHeader."No.");
        if RecWhseShpLine.FindFirst() then begin
            TransferHeader.Reset();
            //TransferHeader.SetRange("Document Type", PurchaseLine."Document Type");
            TransferHeader.SetRange("No.", RecWhseShpLine."Source No.");
            if TransferHeader.FindFirst() then begin
                WhseShipmentHeader.VALIDATE("Requested By", TransferHeader."Requested By");
                WhseShipmentHeader.Validate("Time of Shipment", TransferHeader."Time of Shipment");
                WhseShipmentHeader.Validate("Time of Receipt", TransferHeader."Time of Receipt");
                WhseShipmentHeader.Validate("Vehicle Reg No.", TransferHeader."Vehicle Reg No.");
                WhseShipmentHeader.Validate("Pallet ID", TransferHeader."Pallet ID");
                WhseShipmentHeader.Validate("Shipped By", TransferHeader."Shipped By");
                WhseShipmentHeader.Validate("Receipted By", TransferHeader."Receipted By");
                WhseShipmentHeader.Validate(Comments, TransferHeader.Comments);
                WhseShipmentHeader.Validate("Seal No.", TransferHeader."Seal No.");
                WhseShipmentHeader.Modify();
            end;


            TransferLineLine1.Reset();
            //TransferLineLine1.SetRange("Document Type", PurchaseLine1."Document Type"::Order);
            TransferLineLine1.SetRange("Document No.", RecWhseShpLine."Source No.");
            if TransferLineLine1.FindSet() then begin
                repeat
                    RecWhseShpLine.Reset();
                    RecWhseShpLine.SetRange("Source No.", TransferLineLine1."Document No.");
                    RecWhseShpLine.SetRange("Source Line No.", TransferLineLine1."Line No.");
                    //RecWhseShpLine.SetRange("Source Document", TransferLineLine1."Source Document"::"Purchase Order");
                    if RecWhseShpLine.FindFirst() then begin
                        RecWhseShpLine."Warehouse Class Code" := TransferLineLine1."Warehouse Class Code";
                        RecWhseShpLine.Brand := TransferLineLine1.Brand;
                        RecWhseShpLine."Pack Size" := TransferLineLine1."Pack Size";
                        RecWhseShpLine.Modify();
                    end;
                until TransferLineLine1.Next = 0;
            end;
        end;

        RecWhseRcpLine.Reset();
        RecWhseRcpLine.SetRange("No.", WhseReceiptHeader."No.");
        if RecWhseRcpLine.FindFirst() then begin

            TransferLineLine1.Reset();
            //TransferLineLine1.SetRange("Document Type", PurchaseLine1."Document Type"::Order);
            TransferLineLine1.SetRange("Document No.", RecWhseRcpLine."Source No.");
            if TransferLineLine1.FindSet() then begin
                repeat
                    RecWhseRcpLine.Reset();
                    RecWhseRcpLine.SetRange("Source No.", TransferLineLine1."Document No.");
                    RecWhseRcpLine.SetRange("Source Line No.", TransferLineLine1."Line No.");
                    //RecWhseShpLine.SetRange("Source Document", TransferLineLine1."Source Document"::"Purchase Order");
                    if RecWhseRcpLine.FindFirst() then begin
                        RecWhseRcpLine."Warehouse Class Code" := TransferLineLine1."Warehouse Class Code";
                        RecWhseRcpLine.Brand := TransferLineLine1.Brand;
                        RecWhseRcpLine."Pack Size" := TransferLineLine1."Pack Size";
                        RecWhseRcpLine.Modify();
                    end;
                until TransferLineLine1.Next = 0;
            end;
        end;

        RecWhseRcpLine.Reset();
        RecWhseRcpLine.SetRange("No.", WhseReceiptHeader."No.");
        if RecWhseRcpLine.FindFirst() then begin

            PurchaseLine.Reset();
            //TransferLineLine1.SetRange("Document Type", PurchaseLine1."Document Type"::Order);
            PurchaseLine.SetRange("Document No.", RecWhseRcpLine."Source No.");
            if PurchaseLine.FindSet() then begin
                repeat
                    RecWhseRcpLine.Reset();
                    RecWhseRcpLine.SetRange("Source No.", PurchaseLine."Document No.");
                    RecWhseRcpLine.SetRange("Source Line No.", PurchaseLine."Line No.");
                    //RecWhseShpLine.SetRange("Source Document", TransferLineLine1."Source Document"::"Purchase Order");
                    if RecWhseRcpLine.FindFirst() then begin
                        RecWhseRcpLine."Warehouse Class Code" := PurchaseLine."Warehouse Class Code";
                        RecWhseRcpLine.Brand := PurchaseLine.Brand;
                        RecWhseRcpLine."Pack Size" := PurchaseLine."Pack Size";

                        RecWhseRcpLine.Modify();
                    end;
                until PurchaseLine.Next = 0;
            end;
        end;

        i := 0;
        PurchaseHeader.Reset();
        WhseRcptLine.Reset();
        WhseRcptLine.SetRange("No.", WhseReceiptHeader."No.");
        WhseRcptLine.SetRange("Source Document", WhseRcptLine."Source Document"::"Purchase Order");
        if WhseRcptLine.FindFirst() then begin
            PurchaseHeader.SetRange("No.", WhseRcptLine."Source No.");
            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
            if PurchaseHeader.FindFirst() then begin
                WhseReceiptHeader."Purchase Order No." := PurchaseHeader."No.";
                WhseReceiptHeader."Purchase Order Date" := PurchaseHeader."Order Date";
                WhseReceiptHeader."Supplier Name" := PurchaseHeader."Buy-from Vendor Name";
                WhseReceiptHeader."Requested Receipt Date" := PurchaseHeader."Requested Receipt Date";
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                if PurchaseLine.FindSet() then begin
                    WhseReceiptHeader."No. of Items" := PurchaseLine.Count;
                    repeat
                        if i = 0 then begin
                            WhseReceiptHeader."Item Category Code" := PurchaseLine."Item Category Code";
                            WhseReceiptHeader."Warehouse Class Code" := PurchaseLine."Warehouse Class Code";
                            WhseReceiptHeader.Locationcode := PurchaseLine."Location Code";
                        end;
                        WhseReceiptHeader."Total Order Qty" += PurchaseLine.Quantity;
                        i += 1;
                    until PurchaseLine.Next() = 0;
                end;
                warehouseClassCode := false;
                RecWhseRcpLine.Reset();
                RecWhseRcpLine.SetRange("No.", WhseReceiptHeader."No.");
                if RecWhseRcpLine.FindSet() then begin
                    repeat
                        warehouseClasses.Reset();
                        warehouseClasses.SetRange(Code, RecWhseRcpLine."Warehouse Class Code");
                        if warehouseClasses.FindFirst() then begin
                            if warehouseClasses.CD = true then begin
                                warehouseClassCode := true;
                                WhseReceiptHeader."CD Qty" += RecWhseRcpLine.Quantity;
                            end;
                        end;
                    until RecWhseRcpLine.Next() = 0;
                end;
                if warehouseClassCode = true then
                    WhseReceiptHeader.CD := WhseReceiptHeader.CD::Yes
                else
                    WhseReceiptHeader.CD := WhseReceiptHeader.CD::No;
                WhseReceiptHeader.Modify();
            end;
        end;
        WhseReceiptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'Post and &Print', true, true)]
    local procedure UpdatingTransferHeaderNew(var Rec: Record "Warehouse Shipment Header")
    var
        transferRelease: Codeunit "Release Transfer Document";
        RecTransferHeader: Record "Transfer Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseShptLine1: Record "Warehouse Shipment Line";
        RectransferLine: Record "Transfer Line";
    //RecCustomer: Record Customer;
    begin
        //finding Whse. Shp header++
        WhseShptLine.Reset();
        WhseShptLine.SetRange("No.", Rec."No.");
        if WhseShptLine.FindSet() then begin
            repeat
                //finding Whse. recpt header--

                //Finding saeles Header++
                RecTransferHeader.Reset();
                RecTransferHeader.SetRange("No.", WhseShptLine."Source No.");
                if RecTransferHeader.FindFirst() then begin
                    RecTransferHeader.VALIDATE("Requested By", Rec."Requested By");
                    RecTransferHeader.Validate("Time of Shipment", Rec."Time of Shipment");
                    RecTransferHeader.Validate("Time of Receipt", Rec."Time of Receipt");
                    RecTransferHeader.Validate("Vehicle Reg No.", Rec."Vehicle Reg No.");
                    RecTransferHeader.Validate("Pallet ID", Rec."Pallet ID");
                    RecTransferHeader.Validate("Shipped By", Rec."Shipped By");
                    RecTransferHeader.Validate("Receipted By", Rec."Receipted By");
                    RecTransferHeader.Validate(Comments, Rec.Comments);
                    RecTransferHeader.Validate("Seal No.", Rec."Seal No.");
                    RecTransferHeader.MODIFY;
                end;
            until WhseShptLine.Next() = 0;
        end;
        //Commit();
    end;

    [EventSubscriber(ObjectType::Page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'P&ost Shipment', true, true)]
    local procedure UpdatingtrnHeaderNew(var Rec: Record "Warehouse Shipment Header")
    var
        transferRelease: Codeunit "Release Transfer Document";
        RecTransferHeader: Record "Transfer Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseShptLine1: Record "Warehouse Shipment Line";
        RectransferLine: Record "Transfer Line";
    //RecCustomer: Record Customer;
    begin
        //finding Whse. Shp header++
        WhseShptLine.Reset();
        WhseShptLine.SetRange("No.", Rec."No.");
        if WhseShptLine.FindSet() then begin
            repeat
                //finding Whse. recpt header--

                //Finding saeles Header++
                RecTransferHeader.Reset();
                RecTransferHeader.SetRange("No.", WhseShptLine."Source No.");
                if RecTransferHeader.FindFirst() then begin
                    RecTransferHeader.VALIDATE("Requested By", Rec."Requested By");
                    RecTransferHeader.Validate("Time of Shipment", Rec."Time of Shipment");
                    RecTransferHeader.Validate("Time of Receipt", Rec."Time of Receipt");
                    RecTransferHeader.Validate("Vehicle Reg No.", Rec."Vehicle Reg No.");
                    RecTransferHeader.Validate("Pallet ID", Rec."Pallet ID");
                    RecTransferHeader.Validate("Shipped By", Rec."Shipped By");
                    RecTransferHeader.Validate("Receipted By", Rec."Receipted By");
                    RecTransferHeader.Validate(Comments, Rec.Comments);
                    RecTransferHeader.Validate("Seal No.", Rec."Seal No.");
                    RecTransferHeader.MODIFY;
                end;
            until WhseShptLine.Next() = 0;
        end;
        //Commit();
    end;
    #endregion Update Customized Fields on Warehouse shipment Header and Line From Tranfer Header and Line+++

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

}
