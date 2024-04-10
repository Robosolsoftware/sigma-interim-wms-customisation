codeunit 70114 "Sales Event & Function"
{
    Permissions = tabledata 7320 = m, tabledata 7322 = m;
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;



    #Region Checking Min Order Validation on Sales Order and Return Reason Code on Sales Return Order+++ 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualReleaseProcedure', '', false, false)]
    local procedure OnBeforePerformManualReleaseProcedure(var SalesHeader: Record "Sales Header")
    var
        L_SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if SalesHeader."Min Order Value" > 0 then begin
                SalesHeader.CalcFields(Amount);
                if SalesHeader.Amount < SalesHeader."Min Order Value" then
                    Error('Total order amount %1 is less than Min Order Value %2', SalesHeader.Amount, SalesHeader."Min Order Value");
            end;
        end;

        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
            L_SalesLine.Reset();
            L_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            L_SalesLine.SetRange("Document No.", SalesHeader."No.");
            L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
            L_SalesLine.SetFilter("Return Reason Code", '%1', '');
            if L_SalesLine.FindFirst() then
                L_SalesLine.TestField("Return Reason Code");

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCheckSalesApprovalPossible', '', false, false)]
    local procedure OnBeforeCheckSalesApprovalPossible(var SalesHeader: Record "Sales Header")
    var
        L_SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if SalesHeader."Min Order Value" > 0 then begin
                SalesHeader.CalcFields(Amount);
                if SalesHeader.Amount < SalesHeader."Min Order Value" then
                    Error('Total order amount %1 is less than Min Order Value %2', SalesHeader.Amount, SalesHeader."Min Order Value");
            end;
        end;


        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
            L_SalesLine.Reset();
            L_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            L_SalesLine.SetRange("Document No.", SalesHeader."No.");
            L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
            L_SalesLine.SetFilter("Return Reason Code", '%1', '');
            if L_SalesLine.FindFirst() then
                L_SalesLine.TestField("Return Reason Code");

        end;
    end;
    #endregion Checking Min Order Validation on Sales Order and Return Reason Code on Sales Return Order+++ 

    #Region Checking Sales Order warining Validation on Sales Order++++
    procedure SalesOrderWarningMessage(_SalesHeader: Record "Sales Header"; _SalesLine: Record "Sales Line")
    var
        L_RecItemAttValMap: Record "Item Attribute Value Mapping";
        L_ItemAttribute: Record "Item Attribute";
        L_ItemAttributeValue: Record "Item Attribute Value";
        L_SalesOrderwarningMngSetup: Record "Sales Order warning Mng. Setup";
        WareningMessage: Text[250];
        //L_Dimension: Record Dimension;
        L_DimensionEntry: Record "Dimension Set Entry";
    begin
        L_DimensionEntry.Reset();
        L_DimensionEntry.SetRange("Dimension Set ID", _SalesHeader."Dimension Set ID");
        if L_DimensionEntry.FindSet() then begin
            repeat
                //if L_Dimension."Sales warning" = true then begin
                //Validate for All attributes if Attibute is blank in sales warning management Setup++
                ValidateforAllAttribute(L_DimensionEntry);

                //Validate for Specific Attribut if Attribute is defined in sales warning management Setup++
                L_RecItemAttValMap.Reset();
                L_RecItemAttValMap.SetRange("Table ID", 27);
                L_RecItemAttValMap.SetRange("No.", _SalesLine."No.");
                if L_RecItemAttValMap.FindSet() then begin
                    repeat
                        L_ItemAttribute.Reset();
                        L_ItemAttribute.SetRange(ID, L_RecItemAttValMap."Item Attribute ID");
                        if L_ItemAttribute.FindFirst() then begin
                            L_ItemAttributeValue.SetRange("Attribute ID", L_ItemAttribute.ID);
                            L_ItemAttributeValue.SetRange(ID, L_RecItemAttValMap."Item Attribute Value ID");
                            if L_ItemAttributeValue.FindFirst() then begin
                                L_SalesOrderwarningMngSetup.Reset();
                                L_SalesOrderwarningMngSetup.SetRange("Dimension Code", L_DimensionEntry."Dimension Code");
                                L_SalesOrderwarningMngSetup.SetFilter("Dimension Value", L_DimensionEntry."Dimension Value Code");
                                //L_SalesOrderwarningMngSetup.SetRange("Attribute Value", L_ItemAttributeValue.Value);
                                L_SalesOrderwarningMngSetup.SetRange("Attribute value ID", L_ItemAttributeValue.ID);
                                L_SalesOrderwarningMngSetup.SetRange("Attribute ID", L_ItemAttributeValue."Attribute ID");
                                if L_SalesOrderwarningMngSetup.FindFirst() then begin
                                    if L_SalesOrderwarningMngSetup."Warning message" <> '' then begin
                                        if L_SalesOrderwarningMngSetup."Warning Type" = L_SalesOrderwarningMngSetup."Warning Type"::Error then
                                            Error(L_SalesOrderwarningMngSetup."Warning message")
                                        else
                                            Message(L_SalesOrderwarningMngSetup."Warning message");
                                    end;
                                end;
                            end;
                        end;
                    until L_RecItemAttValMap.Next() = 0;
                end;
            until L_DimensionEntry.Next() = 0;
        end;
    end;


    local procedure ValidateforAllAttribute(_DimensionEntry: Record "Dimension Set Entry")
    var
        L_SalesOrderwarningMngSetup: Record "Sales Order warning Mng. Setup";
    begin
        L_SalesOrderwarningMngSetup.Reset();
        L_SalesOrderwarningMngSetup.SetRange("Dimension Code", _DimensionEntry."Dimension Code");
        L_SalesOrderwarningMngSetup.SetRange("Dimension Value", _DimensionEntry."Dimension Value Code");
        L_SalesOrderwarningMngSetup.SetFilter("Attribute Name", '%1', '');
        if L_SalesOrderwarningMngSetup.FindFirst() then begin
            if L_SalesOrderwarningMngSetup."Warning message" <> '' then begin
                if L_SalesOrderwarningMngSetup."Warning Type" = L_SalesOrderwarningMngSetup."Warning Type"::Error then
                    Error(L_SalesOrderwarningMngSetup."Warning message")
                else
                    Message(L_SalesOrderwarningMngSetup."Warning message");
            end;
        end;
    end;
    #endregion Checking Sales Order warining Validation on Sales Order++++

    #Region Checking Shipping Agent Service Restriction++
    procedure CheckShippingAgentServiceRestriction(_ItemNo: Code[20]; _ShippingAgentCode: Code[20]; _ShippingAgentServiceCode: Code[20])
    var
        L_ShippingAgent: Record "Shipping Agent";
        L_RecItemAttValMap: Record "Item Attribute Value Mapping";
        L_ItemAttribute: Record "Item Attribute";
        L_ItemAttributeValue: Record "Item Attribute Value";

        L_WarehouseClassCode: Record "Warehouse Class";
        L_Item: Record Item;
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        L_RecItemAttValMap.Reset();
        L_RecItemAttValMap.SetRange("Table ID", 27);
        L_RecItemAttValMap.SetRange("No.", _ItemNo);
        if L_RecItemAttValMap.FindSet() then begin
            repeat
                L_ItemAttribute.Reset();
                L_ItemAttribute.SetRange(ID, L_RecItemAttValMap."Item Attribute ID");
                if L_ItemAttribute.FindFirst() then begin
                    L_ItemAttributeValue.SetRange("Attribute ID", L_ItemAttribute.ID);
                    L_ItemAttributeValue.SetRange(ID, L_RecItemAttValMap."Item Attribute Value ID");
                    if L_ItemAttributeValue.FindFirst() then begin
                        if L_ItemAttributeValue.Value <> '' then begin
                            ShippingAgentRestrictItem.Reset();
                            ShippingAgentRestrictItem.SetRange("Shipping Agent Code", _ShippingAgentCode);
                            ShippingAgentRestrictItem.SetRange("Shipping Agent Service Code", _ShippingAgentServiceCode);
                            ShippingAgentRestrictItem.SetRange("Attribute ID", L_ItemAttribute.ID);
                            ShippingAgentRestrictItem.SetRange("Attribute value ID", L_RecItemAttValMap."Item Attribute Value ID");
                            if ShippingAgentRestrictItem.FindFirst() then begin
                                Error('CD and Fridge items are not allowed for Shipping agent service code %1.Item No. %2', _ShippingAgentServiceCode, _ItemNo);
                            end;
                        end;
                    end;
                end;
            until L_RecItemAttValMap.Next() = 0;
        end;
    end;
    #endregion Checking Shipping Agent Service Restriction++

    #Region Update WorkDescription on Warehouse Shipment Header from Sales Header++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterPostReport', '', false, false)]
    local procedure OnAfterPostReport(var WhseShptHeader: Record "Warehouse Shipment Header"; RequestType: Option; var WhseHeaderCreated: Boolean)
    var
        L_WareShipmentLine: Record "Warehouse Shipment Line";
        L_RepeatOrderNo: Code[20];
        L_SalesHeader: Record "Sales Header";
        L_WareshouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if RequestType = 1 then begin
            L_WareshouseShipmentHeader.Reset();
            L_WareshouseShipmentHeader.SetRange("No.", WhseShptHeader."No.");
            if L_WareshouseShipmentHeader.FindFirst() then begin
                Clear(L_RepeatOrderNo);
                L_WareShipmentLine.Reset();
                L_WareShipmentLine.SetRange("No.", L_WareshouseShipmentHeader."No.");
                L_WareShipmentLine.SetRange("Source Document", L_WareShipmentLine."Source Document"::"Sales Order");
                L_WareShipmentLine.SetCurrentKey("Source No.");
                L_WareShipmentLine.Ascending(true);
                if L_WareShipmentLine.FindSet() then begin
                    repeat
                        if L_RepeatOrderNo <> L_WareShipmentLine."Source No." then begin
                            L_SalesHeader.Reset();
                            L_SalesHeader.SetRange("Document Type", L_SalesHeader."Document Type"::Order);
                            L_SalesHeader.SetRange("No.", L_WareShipmentLine."Source No.");
                            if L_SalesHeader.FindFirst() then begin
                                if L_WareshouseShipmentHeader."Work Description" <> '' then
                                    L_WareshouseShipmentHeader."Work Description" := L_WareshouseShipmentHeader."Work Description" + CRLFSeparator() + L_SalesHeader.GetWorkDescription()
                                else
                                    L_WareshouseShipmentHeader."Work Description" := L_WareshouseShipmentHeader."Work Description" + L_SalesHeader.GetWorkDescription()
                            end;
                        end;
                        L_RepeatOrderNo := L_WareShipmentLine."Source No.";
                    until L_WareShipmentLine.Next() = 0;
                    L_WareshouseShipmentHeader.Modify();
                end;
            end;
        end;
    end;

    procedure CRLFSeparator(): Text[2]
    var
        CRLF: Text[2];
    begin
        CRLF[1] := 13; // Carriage return, '\r'
        CRLF[2] := 10; // Line feed, '\n'
        exit(CRLF);
    end;
    #endregion Update WorkDescription on Warehouse Shipment Header from Sales Header++

    #Region Update Customize Fields on Warehouse Shipment from Sales Header and Flow all fields on Posted Warehouse Shipment Header++
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
            WarehouseShipmentHeader.Validate("Data Logger Sheet", L_SalesHeader."Data Logger Sheet");
            WarehouseShipmentHeader.Validate(Labels, L_SalesHeader.Labels);
            WarehouseShipmentHeader.Validate("Extra Documents", L_SalesHeader."Extra Documents");
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
        PostedWhseShptHeader.Validate("Data Logger Sheet", WarehouseShipmentHeader."Data Logger Sheet");
        PostedWhseShptHeader.Validate(Labels, WarehouseShipmentHeader.Labels);
        PostedWhseShptHeader.Validate("Extra Documents", WarehouseShipmentHeader."Extra Documents");
        PostedWhseShptHeader."Requested By" := WarehouseShipmentHeader."Requested By";
        PostedWhseShptHeader.Validate("Time of Shipment", WarehouseShipmentHeader."Time of Shipment");
        PostedWhseShptHeader.Validate("Time of Receipt", WarehouseShipmentHeader."Time of Receipt");
        PostedWhseShptHeader.Validate("Vehicle Reg No.", WarehouseShipmentHeader."Vehicle Reg No.");
        PostedWhseShptHeader.Validate("Pallet ID", WarehouseShipmentHeader."Pallet ID");
        PostedWhseShptHeader.Validate("Shipped By", WarehouseShipmentHeader."Shipped By");
        PostedWhseShptHeader.Validate("Receipted By", WarehouseShipmentHeader."Receipted By");
        PostedWhseShptHeader.Validate(Comments, WarehouseShipmentHeader.Comments);
        PostedWhseShptHeader.Validate("Seal No.", WarehouseShipmentHeader."Seal No.");
        PostedWhseShptHeader.Modify();
    end;
    #endregion Update Customize Fields on Warehouse Shipment from Sales Header and Flow all fields on Posted Warehouse Shipment Header++

    #Region Not allow to select Custom Ship to Adderess on Sales Order++
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeValidateShipToOptions', '', false, false)]
    local procedure OnBeforeValidateShipToOptions(ShipToOptions: Option; var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            if ShipToOptions = 2 then
                Error('You cannot select Custom Address');
    end;
    #endregion Not allow to select Custom Ship to Adderess on Sales Order++
}