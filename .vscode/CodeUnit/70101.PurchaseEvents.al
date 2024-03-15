codeunit 70101 "Purchase Events"
{
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnBeforeCode', '', false, false)]
    // local procedure CheckingReason(var ItemJournalLine: Record "Item Journal Line")
    // begin
    //     if ItemJournalLine.FindSet then begin
    //         repeat
    //             if ItemJournalLine."Reason Code" = '' then begin
    //                 Error('Please enter Reason code Item Line No.:%1', ItemJournalLine."Line No.");
    //             end
    //         until ItemJournalLine.Next = 0;
    //     end;

    // end;
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

        // warehouseClassCode := false;
        // RecWhseRcpLine.Reset();
        // RecWhseRcpLine.SetRange("No.", WhseReceiptHeader."No.");
        // if RecWhseRcpLine.FindSet() then begin
        //     repeat
        //         warehouseClasses.Reset();
        //         warehouseClasses.SetRange(Code, RecWhseRcpLine."Warehouse Class Code");
        //         if warehouseClasses.FindFirst() then begin
        //             if warehouseClasses.CD = true then begin
        //                 warehouseClassCode := true;
        //                 WhseReceiptHeader."CD Qty" += RecWhseRcpLine.Quantity;
        //             end;
        //         end;
        //     until RecWhseRcpLine.Next() = 0;
        // end;
        // if warehouseClassCode = true then
        //     WhseReceiptHeader.CD := WhseReceiptHeader.CD::Yes
        // else
        //     WhseReceiptHeader.CD := WhseReceiptHeader.CD::No;
        // WhseReceiptHeader.Modify();
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterCreatePostedShptHeader', '', true, true)]
    local procedure UpdatePostedWareHouseShpHeader(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShptHeader."Requested By" := WarehouseShipmentHeader."Requested By";
        PostedWhseShptHeader.Validate("Time of Shipment", WarehouseShipmentHeader."Time of Shipment");
        PostedWhseShptHeader.Validate("Time of Receipt", WarehouseShipmentHeader."Time of Receipt");
        PostedWhseShptHeader.Validate("Vehicle Reg No.", WarehouseShipmentHeader."Vehicle Reg No.");
        PostedWhseShptHeader.Validate("Pallet ID", WarehouseShipmentHeader."Pallet ID");
        PostedWhseShptHeader.Validate("Shipped By", WarehouseShipmentHeader."Shipped By");
        PostedWhseShptHeader.Validate("Receipted By", WarehouseShipmentHeader."Receipted By");
        PostedWhseShptHeader.Validate(Comments, WarehouseShipmentHeader.Comments);
        PostedWhseShptHeader.Validate("Seal No.", WarehouseShipmentHeader."Seal No.");
        PostedWhseShptHeader.Modify()
    end;

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


    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnValidateShipmentDateOnBeforeCalcReceiptDate', '', false, false)]
    local procedure UpdateRecShipDate(var IsHandled: Boolean; var TransferHeader: Record "Transfer Header")
    begin
        // IsHandled := false;
        // TransferHeader."Receipt Date" := 0D;
        // TransferHeader."Shipment Date" := 0D;
        //TransferHeader.Modify();
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment (Yes/No)", 'OnBeforeConfirmWhseShipmentPost', '', false, false)]
    // local procedure OnlyShip(var Invoice: Boolean; var Selection: Integer;var HideDialog: Boolean;var IsPosted: Boolean;var WhseShptLine: Record "Warehouse Shipment Line")
    // begin

    //     Invoice := (Selection = 1);
    // end;
}
