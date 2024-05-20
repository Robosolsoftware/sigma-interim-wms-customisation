codeunit 85014 "Miscellaneous Charges"
{

    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    #Region Get UserName++
    procedure GetUserName(UserSecurityId: Code[50]): Text[100]
    var
        Users: Record User;
    begin
        Users.Reset();
        Users.SetRange("User Security ID", UserSecurityId);
        if Users.FindFirst() then
            exit(Users."User Name");
    end;
    #endregion Get UserName++




    procedure CheckWarehouseShipmetExist(_salesHear: Record "Sales Header")
    var
        L_WarehouseShipmetLine: Record "Warehouse Shipment Line";
    begin
        L_WarehouseShipmetLine.Reset();
        L_WarehouseShipmetLine.SetRange("Source No.", _salesHear."No.");
        L_WarehouseShipmetLine.SetRange("Source Document", L_WarehouseShipmetLine."Source Document"::"Sales Order");
        if not L_WarehouseShipmetLine.IsEmpty then
            Error('You cannot update variant code because warehouse shipment number %1 exist for this order.', L_WarehouseShipmetLine."No.");

    end;

    // [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', "Create &Whse. Receipt", true, true)]
    // local procedure UpdateFieldsFromOrdertoWhseRcpt(var Rec: Record "Purchase Header")
    // var
    //     WhseRcptHeader: Record "Warehouse Receipt Header";
    //     WhseRcptLine: Record "Warehouse Receipt Line";
    //     PurchaseLine: Record "Purchase Line";
    //     i: Integer;
    // begin
    //     i := 0;
    //     WhseRcptLine.Reset();
    //     WhseRcptLine.SetRange("Source No.", Rec."No.");
    //     if WhseRcptLine.FindFirst() then begin
    //         WhseRcptHeader.Reset();
    //         WhseRcptHeader.SetRange("No.", WhseRcptLine."No.");
    //         if WhseRcptHeader.FindFirst() then begin
    //             WhseRcptHeader."Purchase Order No." := Rec."No.";
    //             WhseRcptHeader."Purchase Order Date" := Rec."Order Date";
    //             WhseRcptHeader."Supplier Name" := Rec."Buy-from Vendor Name";
    //             PurchaseLine.Reset();
    //             PurchaseLine.SetRange("Document No.", Rec."No.");
    //             PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
    //             if PurchaseLine.FindSet() then begin
    //                 WhseRcptHeader."No. of Items" := PurchaseLine.Count;
    //                 repeat
    //                     if i = 0 then begin
    //                         WhseRcptHeader."Item Category Code" := PurchaseLine."Item Category Code";
    //                         WhseRcptHeader."Warehouse Class Code" := PurchaseLine."Warehouse Class Code";
    //                         WhseRcptHeader.Locationcode := PurchaseLine."Location Code";
    //                     end;
    //                     WhseRcptHeader."Total Order Qty" += PurchaseLine.Quantity;
    //                     i += 1;
    //                 until PurchaseLine.Next() = 0;
    //             end;


    //         end;
    //     end;
    //     WhseRcptHeader.Modify();
    // end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterProcessDocumentLine', '', true, true)]
    local procedure OnAfterProcessDocumentLine(WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        //WhseRcptHeader: Record "Warehouse Receipt Header";
        WhseRcptLine: Record "Warehouse Receipt Line";
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        i: Integer;
        warehouseClassCode: Boolean;
        warehouseClasses: Record "Warehouse Class";
        //WhseReceiptHeader: Record "Warehouse Receipt Header";
        RecWhseRcpLine: Record "Warehouse Receipt Line";
    begin
        // i := 0;
        // PurchaseHeader.Reset();
        // WhseRcptLine.Reset();
        // WhseRcptLine.SetRange("No.", WarehouseReceiptHeader."No.");
        // WhseRcptLine.SetRange("Source Document", WhseRcptLine."Source Document"::"Purchase Order");
        // if WhseRcptLine.FindFirst() then begin
        //     PurchaseHeader.SetRange("No.", WhseRcptLine."Source No.");
        //     PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        //     if PurchaseHeader.FindFirst() then begin
        //         WarehouseReceiptHeader."Purchase Order No." := PurchaseHeader."No.";
        //         WarehouseReceiptHeader."Purchase Order Date" := PurchaseHeader."Order Date";
        //         WarehouseReceiptHeader."Supplier Name" := PurchaseHeader."Buy-from Vendor Name";
        //         WarehouseReceiptHeader."Requested Receipt Date" := PurchaseHeader."Requested Receipt Date";
        //         PurchaseLine.Reset();
        //         PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        //         PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        //         PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        //         if PurchaseLine.FindSet() then begin
        //             WarehouseReceiptHeader."No. of Items" := PurchaseLine.Count;
        //             repeat
        //                 if i = 0 then begin
        //                     WarehouseReceiptHeader."Item Category Code" := PurchaseLine."Item Category Code";
        //                     WarehouseReceiptHeader."Warehouse Class Code" := PurchaseLine."Warehouse Class Code";
        //                     WarehouseReceiptHeader.Locationcode := PurchaseLine."Location Code";
        //                 end;
        //                 WarehouseReceiptHeader."Total Order Qty" += PurchaseLine.Quantity;
        //                 i += 1;
        //             until PurchaseLine.Next() = 0;
        //         end;
        //         // warehouseClassCode := false;
        //         // RecWhseRcpLine.Reset();
        //         // RecWhseRcpLine.SetRange("No.", WarehouseReceiptHeader."No.");
        //         // if RecWhseRcpLine.FindSet() then begin
        //         //     repeat
        //         //         warehouseClasses.Reset();
        //         //         warehouseClasses.SetRange(Code, RecWhseRcpLine."Warehouse Class Code");
        //         //         if warehouseClasses.FindFirst() then begin
        //         //             if warehouseClasses.CD = true then begin
        //         //                 warehouseClassCode := true;
        //         //                 WarehouseReceiptHeader."CD Qty" += RecWhseRcpLine.Quantity;
        //         //             end;
        //         //         end;
        //         //     until RecWhseRcpLine.Next() = 0;
        //         // end;
        //         // if warehouseClassCode = true then
        //         //     WarehouseReceiptHeader.CD := WarehouseReceiptHeader.CD::Yes
        //         // else
        //         //     WarehouseReceiptHeader.CD := WarehouseReceiptHeader.CD::No;
        //         WarehouseReceiptHeader.Modify();
        //     end;
        // end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnCodeOnAfterWhseRcptHeaderModify', '', true, true)]
    // local procedure CopyWhseRcptHeaderField(WhseReceiptHeader: Record "Warehouse Receipt Header")
    // var
    //     POWhseRcptHeader: Record "Posted Whse. Receipt Header";
    // begin
    //     POWhseRcptHeader.Reset();
    //     POWhseRcptHeader.SetRange("Whse. Receipt No.", WhseReceiptHeader."No.");
    //     if POWhseRcptHeader.FindFirst() then
    //         POWhseRcptHeader.Reset();
    //     POWhseRcptHeader.Init();
    //     POWhseRcptHeader.Validate("Purchase Order No.", WhseReceiptHeader."Purchase Order No.");
    //     POWhseRcptHeader.Validate("Purchase Order Date", WhseReceiptHeader."Purchase Order Date");
    //     POWhseRcptHeader.Validate("Supplier Name", WhseReceiptHeader."Supplier Name");
    //     POWhseRcptHeader.Validate("Warehouse Class Code", WhseReceiptHeader."Warehouse Class Code");
    //     POWhseRcptHeader.Validate(Locationcode, WhseReceiptHeader.Locationcode);
    //     POWhseRcptHeader.Validate("Item Category Code", WhseReceiptHeader."Item Category Code");
    //     POWhseRcptHeader.Validate("No. of Items", WhseReceiptHeader."No. of Items");
    //     POWhseRcptHeader.Validate("Total Order Qty", WhseReceiptHeader."Total Order Qty");
    //     POWhseRcptHeader.Validate(Carrier, WhseReceiptHeader.Carrier);
    //     POWhseRcptHeader.Validate("Booking Requested Date", WhseReceiptHeader."Booking Requested Date");
    //     POWhseRcptHeader.Validate("Expected Delivery Date", WhseReceiptHeader."Expected Delivery Date");
    //     POWhseRcptHeader.Validate("Expected Delivery Time", WhseReceiptHeader."Expected Delivery Time");
    //     POWhseRcptHeader.Validate("Booked Pallets", WhseReceiptHeader."Booked Pallets");
    //     POWhseRcptHeader.Validate(Lifts, WhseReceiptHeader.Lifts);
    //     POWhseRcptHeader.Validate("Loose Boxes", WhseReceiptHeader."Loose Boxes");
    //     POWhseRcptHeader.Validate("Curtain Side", WhseReceiptHeader."Curtain Side");
    //     POWhseRcptHeader.Validate(Comments, WhseReceiptHeader.Comments);
    //     POWhseRcptHeader.Validate("Receipt Status", WhseReceiptHeader."Receipt Status");
    //     POWhseRcptHeader.Validate("Actual Receipt Date", WhseReceiptHeader."Actual Receipt Date");
    //     POWhseRcptHeader.Validate("Actual Receipt Time", WhseReceiptHeader."Actual Receipt Time");
    //     POWhseRcptHeader.Insert();
    // end;




}