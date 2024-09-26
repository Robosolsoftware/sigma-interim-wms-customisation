codeunit 85012 "Sales Event & Function"
{
    Permissions = tabledata 7320 = m, tabledata 7322 = m, tabledata 112 = m, tabledata 110 = m;
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_InvePickNo: Code[20]; //It is for Posted Sales Invoice Header++



    #Region Checking Min Order Validation on Sales Order and Return Reason Code on Sales Return Order+++ 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualReleaseProcedure', '', false, false)]
    local procedure OnBeforePerformManualReleaseProcedure(var SalesHeader: Record "Sales Header")
    var
        L_SalesLine: Record "Sales Line";
        L_UserSetup: Record "User Setup";
    begin
        // L_UserSetup.Reset();
        // L_UserSetup.SetRange("User ID", UserId);
        // L_UserSetup.SetRange("SO Override Min Order Value", true);
        // if not L_UserSetup.FindFirst() then begin
        //     if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
        //         if SalesHeader."Min Order Value" > 0 then begin
        //             SalesHeader.CalcFields(Amount);
        //             if SalesHeader.Amount < SalesHeader."Min Order Value" then
        //                 Error('Total order amount %1 is less than Min Order Value %2', SalesHeader.Amount, SalesHeader."Min Order Value");
        //         end;
        //     end;
        // end;

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
        L_UserSetup: Record "User Setup";
    begin
        /*L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        L_UserSetup.SetRange("SO Override Min Order Value", true);
        if not L_UserSetup.FindFirst() then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                if SalesHeader."Min Order Value" > 0 then begin
                    SalesHeader.CalcFields(Amount);
                    if SalesHeader.Amount < SalesHeader."Min Order Value" then
                        Error('Total order amount %1 is less than Min Order Value %2', SalesHeader.Amount, SalesHeader."Min Order Value");
                end;
            end;
        end;*///


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
                            ShippingAgentRestrictItem.SetRange("QAU Approved", true);
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

    #Region Update Customize Fields on Warehouse Shipment from Sales Header and Transfer Header and move fields on Posted Warehouse Shipment Header++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateShptHeader', '', false, false)]
    local procedure OnAfterCreateShptHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; WarehouseRequest: Record "Warehouse Request")
    var
        L_SalesHeader: Record "Sales Header";
        L_TransferHeader: Record "Transfer Header";
    begin
        //Sales Header Fields++
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then begin
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

        //Transfer Header fields++
        if WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Outbound Transfer" then begin
            L_TransferHeader.Reset();
            L_TransferHeader.SetRange("No.", WarehouseRequest."Source No.");
            if L_TransferHeader.FindFirst() then begin
                WarehouseShipmentHeader.VALIDATE("Requested By", L_TransferHeader."Requested By");
                WarehouseShipmentHeader.Validate("Time of Shipment", L_TransferHeader."Time of Shipment");
                WarehouseShipmentHeader.Validate("Time of Receipt", L_TransferHeader."Time of Receipt");
                WarehouseShipmentHeader.Validate("Vehicle Reg No.", L_TransferHeader."Vehicle Reg No.");
                WarehouseShipmentHeader.Validate("Pallet ID", L_TransferHeader."Pallet ID");
                WarehouseShipmentHeader.Validate("Shipped By", L_TransferHeader."Shipped By");
                WarehouseShipmentHeader.Validate("Receipted By", L_TransferHeader."Receipted By");
                WarehouseShipmentHeader.Validate(Comments, L_TransferHeader.Comments);
                WarehouseShipmentHeader.Validate("Seal No.", L_TransferHeader."Seal No.");
                WarehouseShipmentHeader.Modify();
            end;
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
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if ShipToOptions = 2 then
                Error('You cannot select Custom Address');

            if ShipToOptions = 1 then
                Error('You cannot select Alternate Shipping Address');
        end;
    end;
    #endregion Not allow to select Custom Ship to Adderess on Sales Order++

    #Region Update Customize Fields on Warehouse Shipment line from Sales line and Transfer line and move fields on Posted Warehouse Shipment lin++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Warehouse Mgt.", 'OnAfterCreateShptLineFromTransLine', '', false, false)]
    local procedure OnAfterCreateShptLineFromTransLine(TransferLine: Record "Transfer Line"; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        L_wareshipment: page "Warehouse Shipment";
    begin
        if WarehouseShipmentLine."Source Document" = WarehouseShipmentLine."Source Document"::"Outbound Transfer" then begin
            WarehouseShipmentLine."Warehouse Class Code" := TransferLine."Warehouse Class Code";
            WarehouseShipmentLine.Brand := TransferLine.Brand;
            WarehouseShipmentLine."Pack Size" := TransferLine."Pack Size";
            WarehouseShipmentLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", 'OnAfterCreateShptLineFromSalesLine', '', false, false)]
    local procedure OnAfterCreateShptLineFromSalesLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SalesLine: Record "Sales Line")
    var
        L_Item: Record Item;
    begin
        if WarehouseShipmentLine."Source Document" = WarehouseShipmentLine."Source Document"::"Sales Order" then begin
            L_Item.Reset();
            L_Item.SetRange("No.", WarehouseShipmentLine."Item No.");
            if L_Item.FindFirst() then begin
                WarehouseShipmentLine."Warehouse Class Code" := L_Item."Warehouse Class Code";
                WarehouseShipmentLine.Brand := L_Item.Brand;
                WarehouseShipmentLine."Pack Size" := L_Item."Pack Size";
                WarehouseShipmentLine.Modify();
            end;
        end;
    end;
    #endregion Update Customize Fields on Warehouse Shipment line from Sales line and Transfer line and move fields on Posted Warehouse Shipment lin++

    #Region Check Duplicate Customer Price+++
    procedure CheckDulicatePriceGroup(_CallFromGroup: Integer; _Rec: Record Customer)
    begin
        case _CallFromGroup of
            1:
                begin
                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');
                end;
            2:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                end;
            3:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                end;
            4:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                end;
            5:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');
                end;
            6:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 6" then
                        Error('Customer Price Group already exist');
                end;
            7:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 7" then
                        Error('Customer Price Group already exist');
                end;
            8:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 8" then
                        Error('Customer Price Group already exist');
                end;
            9:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 10" = _Rec."Customer Price Group 9" then
                        Error('Customer Price Group already exist');
                end;
            10:
                begin
                    if _Rec."Customer Price Group" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 2" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 3" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 4" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 5" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 6" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 7" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 8" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');

                    if _Rec."Customer Price Group 9" = _Rec."Customer Price Group 10" then
                        Error('Customer Price Group already exist');
                end;
        end;
    end;
    #endregion Check Duplicate Customer Price+++


    //Update Shipping agenet service code on posted sales invoice header++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; SalesInvHdrNo: Code[20]; SalesShptHdrNo: Code[20])
    var
        L_SalesInvoiceHeader: Record "Sales Invoice Header";
        L_SalesShipmentHeader: Record "Sales Shipment Header";
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        SalesRecSetup.Get();
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then begin
            L_SalesInvoiceHeader.Reset();
            L_SalesInvoiceHeader.SetRange("No.", SalesInvHdrNo);
            if L_SalesInvoiceHeader.FindFirst() then begin
                L_SalesInvoiceHeader.Validate("Shipping Agent Service Code", SalesHeader."Shipping Agent Service Code");
                if SalesRecSetup."Inv./Ship Default Posting Date" = SalesRecSetup."Inv./Ship Default Posting Date"::"Work Date" then begin
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
                        L_SalesInvoiceHeader."Posting Date" := WorkDate();
                end;
                L_SalesInvoiceHeader.Modify();
            end;

            if SalesRecSetup."Inv./Ship Default Posting Date" = SalesRecSetup."Inv./Ship Default Posting Date"::"Work Date" then begin
                if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                    L_SalesShipmentHeader.Reset();
                    L_SalesShipmentHeader.SetRange("No.", SalesShptHdrNo);
                    if L_SalesShipmentHeader.FindFirst() then begin
                        L_SalesShipmentHeader."Posting Date" := WorkDate();
                        L_SalesShipmentHeader.Modify();
                    end;
                end;
            end;
        end;
    end;


    //Update Inv. Pick No. on Posted Sales Shipment+++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterPostWhseActivityLine', '', false, false)]
    local procedure OnAfterPostWhseActivityLine(WhseActivHeader: Record "Warehouse Activity Header"; PostedSourceNo: Code[20]; PostedSourceType: Integer)
    var
        L_PostedSalesShipmentHeader: Record "Sales Shipment Header";
        tes: Page "Inventory Pick";
    begin
        if PostedSourceType = 110 then begin
            L_PostedSalesShipmentHeader.Reset();
            L_PostedSalesShipmentHeader.SetRange("No.", PostedSourceNo);
            if L_PostedSalesShipmentHeader.FindFirst() then begin
                L_PostedSalesShipmentHeader."Inv. Pick No." := WhseActivHeader."No.";
                L_PostedSalesShipmentHeader.Modify();
            end;
        end;
    end;



    #Region Update Inv. Pick No on posted sales Invoice No +++
    //Step1++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnPostSourceDocumentOnBeforeSalesPostRun', '', false, false)]
    local procedure OnPostSourceDocumentOnBeforeSalesPostRun(var SalesHeader: Record "Sales Header"; WarehouseActivityHeader: Record "Warehouse Activity Header")
    begin
        Clear(G_InvePickNo);
        G_InvePickNo := WarehouseActivityHeader."No.";
    end;

    //Step2++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure UpdateInvPickNo_OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; SalesInvHdrNo: Code[20])
    var
        L_SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if G_InvePickNo <> '' then begin
            L_SalesInvoiceHeader.Reset();
            L_SalesInvoiceHeader.SetRange("No.", SalesInvHdrNo);
            if L_SalesInvoiceHeader.FindFirst() then begin
                L_SalesInvoiceHeader."Inv. Pick No." := G_InvePickNo;
                L_SalesInvoiceHeader.Modify();
            end;
        end;

        Clear(G_InvePickNo);
    end;

    #endregion Update Inv. Pick No on posted sales Invoice No +++



    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        L_Customer: Record Customer;
    begin
        L_Customer.Reset();
        L_Customer.SetRange("No.", CustLedgerEntry."Customer No.");
        if L_Customer.FindFirst() then begin
            CustLedgerEntry."Assigned Credit Controller" := L_Customer."Assigned Credit Controller";
        end;
    end;
}
