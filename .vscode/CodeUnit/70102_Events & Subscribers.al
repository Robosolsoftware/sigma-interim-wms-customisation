codeunit 70102 "SC Events & Subscriber"
{

    Permissions = tabledata 7320 = m, tabledata 7322 = m;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

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


}