codeunit 70102 "SC Events & Subscriber"
{

    Permissions = tabledata 7320 = m, tabledata 7322 = m;
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        PurchHeaderNo: Code[20];

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateShptHeader', '', false, false)]
    local procedure OnAfterCreateShptHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line")
    var
        L_SalesHeader: Record "Sales Header";
    begin
        L_SalesHeader.Reset();
        L_SalesHeader.SetRange("Document Type", SalesLine."Document Type");
        L_SalesHeader.SetRange("No.", SalesLine."Document No.");
        if L_SalesHeader.FindFirst() then begin
            WarehouseShipmentHeader.Validate("Delivery Note", L_SalesHeader."Delivery Note");
            WarehouseShipmentHeader.Validate("Collection Note", L_SalesHeader."Collection Note");
            WarehouseShipmentHeader.Validate(_Invoice, L_SalesHeader._Invoice);
            WarehouseShipmentHeader.Validate("Packing list", L_SalesHeader."Packing list");
            WarehouseShipmentHeader.Validate("Export Checklist", L_SalesHeader."Export Checklist");
            WarehouseShipmentHeader.Validate("Data logger", L_SalesHeader."Data logger");
            WarehouseShipmentHeader.Validate(Labels, L_SalesHeader.Labels);
            WarehouseShipmentHeader.Validate("Custom Documents", L_SalesHeader."Custom Documents");
            WarehouseShipmentHeader.Modify();
        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterCreatePostedShptHeader', '', true, true)]
    local procedure UpdatePostedWareHouseShpHeader(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShptHeader.Validate("Delivery Note", WarehouseShipmentHeader."Delivery Note");
        PostedWhseShptHeader.Validate("Collection Note", WarehouseShipmentHeader."Collection Note");
        PostedWhseShptHeader.Validate(_Invoice, WarehouseShipmentHeader._Invoice);
        PostedWhseShptHeader.Validate("Packing list", WarehouseShipmentHeader."Packing list");
        PostedWhseShptHeader.Validate("Export Checklist", WarehouseShipmentHeader."Export Checklist");
        PostedWhseShptHeader.Validate("Data logger", WarehouseShipmentHeader."Data logger");
        PostedWhseShptHeader.Validate(Labels, WarehouseShipmentHeader.Labels);
        PostedWhseShptHeader.Validate("Custom Documents", WarehouseShipmentHeader."Custom Documents");
        PostedWhseShptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeValidateShipToOptions', '', false, false)]
    local procedure OnBeforeValidateShipToOptions(ShipToOptions: Option; var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            if ShipToOptions = 2 then
                Error('You cannot select Custom Address');
    end;


    procedure UpdateAvaibleQty(_SalesLine: Record "Sales Line")
    var
        L_ItemVariant: Record "Item Variant";
    begin
        L_ItemVariant.Reset();
        L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        if L_ItemVariant.FindSet() then
            repeat
                L_ItemVariant.CalcFields(Inventory, "Total Requested Quantity");
                L_ItemVariant.Quantity := L_ItemVariant.Inventory - L_ItemVariant."Total Requested Quantity";
                L_ItemVariant.Modify();
            until L_ItemVariant.Next() = 0;
    end;

    procedure SetPriorityWithoutZero(_SalesLine: Record "Sales Line"; var _ItemVariant: Record "Item Variant")
    begin
        Clear(_ItemVariant);
        _ItemVariant.Reset();
        _ItemVariant.SetRange("Item No.", _SalesLine."No.");
        _ItemVariant.SetFilter(Priority, '<>%1', 0);
        _ItemVariant.SetCurrentKey(Priority);
        _ItemVariant.Ascending(true);
        if _ItemVariant.FindFirst() then;
    end;

    procedure SetPriorityWithZeroandHigherQty(_SalesLine: Record "Sales Line"; var _ItemVariant: Record "Item Variant")
    begin
        Clear(_ItemVariant);
        _ItemVariant.Reset();
        _ItemVariant.SetRange("Item No.", _SalesLine."No.");
        _ItemVariant.SetFilter(Priority, '%1', 0);
        _ItemVariant.SetFilter(Quantity, '>%1', 0); //Quantity equal to Availble Quantity++
        _ItemVariant.SetCurrentKey(Quantity);
        _ItemVariant.Ascending(false);
        if _ItemVariant.FindFirst() then;
    end;



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

    procedure CheckTotalAvailablityQty(_SalesLine: Record "Sales Line"): Decimal
    var
        L_ItemVariant: Record "Item Variant";
        L_TotalInventory: Decimal;
        L_TotalRequestedQty: Decimal;
    begin
        Clear(L_TotalInventory);
        Clear(L_TotalRequestedQty);
        L_ItemVariant.Reset();
        L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        if L_ItemVariant.FindSet() then begin
            repeat
                L_ItemVariant.CalcFields(Inventory, "Total Requested Quantity");
                L_TotalInventory += L_ItemVariant.Inventory;
                L_TotalRequestedQty += L_ItemVariant."Total Requested Quantity";
            until L_ItemVariant.Next() = 0;
            if L_TotalInventory > 0 then
                exit(L_TotalInventory - L_TotalRequestedQty)
            else
                exit(0);
        end else
            exit(0);

    end;

    procedure CheckTotalAvailablityQtyVariantWise(_SalesLine: Record "Sales Line"; _ItemVariant: Record "Item Variant"): Decimal
    var
        L_ItemVariant: Record "Item Variant";
        L_TotalInventory: Decimal;
        L_TotalRequestedQty: Decimal;
    begin
        Clear(L_TotalInventory);
        Clear(L_TotalRequestedQty);
        L_ItemVariant.Reset();
        L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        L_ItemVariant.SetRange(Code, _ItemVariant.Code);
        if L_ItemVariant.FindSet() then begin
            repeat
                L_ItemVariant.CalcFields(Inventory, "Total Requested Quantity");
                L_TotalInventory += L_ItemVariant.Inventory;
                L_TotalRequestedQty += L_ItemVariant."Total Requested Quantity";
            until L_ItemVariant.Next() = 0;
            if L_TotalInventory > 0 then
                exit(L_TotalInventory - L_TotalRequestedQty)
            else
                exit(0);
        end else
            exit(0);

    end;

    procedure InsertNewSalesLine(_SalesLine: Record "Sales Line"; _ItemVariant: Record "Item Variant"; _QtytoApply: Decimal): Decimal
    var
        L_SalesLine: Record "Sales Line";
    begin
        L_SalesLine.Init();
        L_SalesLine.Validate("Document Type", _SalesLine."Document Type");
        L_SalesLine.Validate("Document No.", _SalesLine."Document No.");
        L_SalesLine.Validate(Type, _SalesLine.Type);
        L_SalesLine.Validate("Line No.", FindLastLineNo(_SalesLine));
        L_SalesLine.Validate("No.", _SalesLine."No.");
        L_SalesLine.Validate(Quantity, _QtytoApply);
        L_SalesLine.Validate("Original Quantity", _SalesLine.Quantity);
        L_SalesLine.Validate("Location Code", _SalesLine."Location Code");
        L_SalesLine.Validate("Unit Price", _SalesLine."Unit Price");
        L_SalesLine.Validate("Variant Created By", _SalesLine."Line No."); //Original Line Number
        L_SalesLine.Insert();
    end;

    local procedure FindLastLineNo(_SalesLine: Record "Sales Line"): Integer
    var
        L_SalesLine: Record "Sales Line";
    begin
        L_SalesLine.Reset();
        L_SalesLine.SetRange("Document Type", _SalesLine."Document Type");
        L_SalesLine.SetRange("Document No.", _SalesLine."Document No.");
        if L_SalesLine.FindLast() then
            exit(L_SalesLine."Line No." + 10000)
        else
            exit(10000);

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
    local procedure MyProcedure(WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        //WhseRcptHeader: Record "Warehouse Receipt Header";
        WhseRcptLine: Record "Warehouse Receipt Line";
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        i: Integer;
    begin

        i := 0;
        PurchaseHeader.Reset();
        WhseRcptLine.Reset();
        WhseRcptLine.SetRange("No.", WarehouseReceiptHeader."No.");
        WhseRcptLine.SetRange("Source Document", WhseRcptLine."Source Document"::"Purchase Order");
        if WhseRcptLine.FindFirst() then begin
            PurchaseHeader.SetRange("No.", WhseRcptLine."Source No.");
            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
            if PurchaseHeader.FindFirst() then begin
                WarehouseReceiptHeader."Purchase Order No." := PurchaseHeader."No.";
                WarehouseReceiptHeader."Purchase Order Date" := PurchaseHeader."Order Date";
                WarehouseReceiptHeader."Supplier Name" := PurchaseHeader."Buy-from Vendor Name";
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                if PurchaseLine.FindSet() then begin
                    WarehouseReceiptHeader."No. of Items" := PurchaseLine.Count;
                    repeat
                        if i = 0 then begin
                            WarehouseReceiptHeader."Item Category Code" := PurchaseLine."Item Category Code";
                            WarehouseReceiptHeader."Warehouse Class Code" := PurchaseLine."Warehouse Class Code";
                            WarehouseReceiptHeader.Locationcode := PurchaseLine."Location Code";
                        end;
                        WarehouseReceiptHeader."Total Order Qty" += PurchaseLine.Quantity;
                        i += 1;
                    until PurchaseLine.Next() = 0;
                end;
                WarehouseReceiptHeader.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnCodeOnAfterWhseRcptHeaderModify', '', true, true)]
    local procedure CopyWhseRcptHeaderField(WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        POWhseRcptHeader: Record "Posted Whse. Receipt Header";
    begin
        POWhseRcptHeader.Reset();
        POWhseRcptHeader.SetRange("Whse. Receipt No.", WhseReceiptHeader."No.");
        if POWhseRcptHeader.FindFirst() then
            POWhseRcptHeader.Reset();
        POWhseRcptHeader.Init();
        POWhseRcptHeader.Validate("Purchase Order No.", WhseReceiptHeader."Purchase Order No.");
        POWhseRcptHeader.Validate("Purchase Order Date", WhseReceiptHeader."Purchase Order Date");
        POWhseRcptHeader.Validate("Supplier Name", WhseReceiptHeader."Supplier Name");
        POWhseRcptHeader.Validate("Warehouse Class Code", WhseReceiptHeader."Warehouse Class Code");
        POWhseRcptHeader.Validate(Locationcode, WhseReceiptHeader.Locationcode);
        POWhseRcptHeader.Validate("Item Category Code", WhseReceiptHeader."Item Category Code");
        POWhseRcptHeader.Validate("No. of Items", WhseReceiptHeader."No. of Items");
        POWhseRcptHeader.Validate("Total Order Qty", WhseReceiptHeader."Total Order Qty");
        POWhseRcptHeader.Validate(Carrier, WhseReceiptHeader.Carrier);
        POWhseRcptHeader.Validate("Booking Requested Date", WhseReceiptHeader."Booking Requested Date");
        POWhseRcptHeader.Validate("Expected Delivery Date", WhseReceiptHeader."Expected Delivery Date");
        POWhseRcptHeader.Validate("Expected Delivery Time", WhseReceiptHeader."Expected Delivery Time");
        POWhseRcptHeader.Validate("Booked Pallets", WhseReceiptHeader."Booked Pallets");
        POWhseRcptHeader.Validate(Lifts, WhseReceiptHeader.Lifts);
        POWhseRcptHeader.Validate("Loose Boxes", WhseReceiptHeader."Loose Boxes");
        POWhseRcptHeader.Validate("Curtain Side", WhseReceiptHeader."Curtain Side");
        POWhseRcptHeader.Validate(Comments, WhseReceiptHeader.Comments);
        POWhseRcptHeader.Validate("Receipt Status", WhseReceiptHeader."Receipt Status");
        POWhseRcptHeader.Validate("Actual Receipt Date", WhseReceiptHeader."Actual Receipt Date");
        POWhseRcptHeader.Validate("Actual Receipt Time", WhseReceiptHeader."Actual Receipt Time");
        POWhseRcptHeader.Insert();
    end;


    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", OnBeforePostPurchLine, '', false, false)]
    // local procedure VariantMandatory(var PurchHeader: Record "Purchase Header")
    // var
    //     PLine: Record "Purchase Line";
    //     item: Record Item;
    // //d: Codeunit 90;
    // begin
    //     PLine.Reset();
    //     PLine.SetRange("Document No.", PurchHeader."No.");
    //     PLine.SetRange(Type, PLine.Type::Item);
    //     if PLine.FindSet() then
    //         repeat
    //             item.Reset();
    //             item.SetRange("No.", PLine."No.");
    //             if item.FindFirst() then begin
    //                 if item."Variant Mandatory if Exists" = item."Variant Mandatory if Exists"::Yes then begin
    //                     if PLine."Variant Code" = '' then
    //                         Error('Variant Code is mandatory for item No. %1', PLine."No.");
    //                 end;
    //             end;
    //         until PLine.Next() = 0;

    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeMandatoryFields', '', false, false)]
    // local procedure OnBeforeMandatoryFields(PurchaseHeader: Record "Purchase Header")
    // var

    // begin
    //     Clear(PurchHeaderNo);
    //     PurchHeaderNo := PurchaseHeader."No.";

    // end;

    // [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeIsVariantMandatory', '', false, false)]
    // local procedure OnBeforeIsVariantMandatory(var IsHandled: Boolean)
    // var
    //     PHeader: Record "Purchase Header";
    //     Location: Record Location;
    // begin
    //     PHeader.Reset();
    //     PHeader.SetRange("Document Type", PHeader."Document Type"::Order);
    //     PHeader.SetRange("No.", PurchHeaderNo);
    //     if PHeader.FindFirst() then begin
    //         Location.Reset();
    //         if Location.Get(PHeader."Location Code") then begin
    //             if Location."Require Receive" = true then
    //                 IsHandled := true;
    //         end;
    //     end;
    // end;

}