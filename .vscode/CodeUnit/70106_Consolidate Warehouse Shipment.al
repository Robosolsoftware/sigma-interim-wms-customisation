//Dont Use this codeunit for any customization++
codeunit 70106 "Consolidate Warehouse Shipment"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        G_FromSalesOrderScreen: Boolean;
        G_OneHeaderCreated: Boolean;
        G_SkipBlockedItem: Boolean;
        G_SkipBlockedCustomer: Boolean;
        G_WhseHeaderCreated: Boolean;
        G_Location: Code[20];
        G_WhseShptHeader: Record "Warehouse Shipment Header";
        G_NoOfOrderToProcess: Integer;


    //No Of Records Customization +++++++++++++
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Source Filter", 'OnBeforeSetTableView', '', false, false)]
    local procedure OnBeforeSetTableView(var WarehouseRequest: Record "Warehouse Request"; var WarehouseSourceFilter: Record "Warehouse Source Filter"; var SalesHeader: Record "Sales Header")
    var
        NoOfRecord: Integer;
        L_SH: Record "Sales Header";
    begin
        Clear(NoOfRecord);
        if (WarehouseSourceFilter."Sales Orders" = true) AND (WarehouseSourceFilter."Source No. Filter" <> '') AND ((WarehouseSourceFilter."Number of Records" > 0)) then begin
            NoOfRecord := WarehouseSourceFilter."Number of Records";
            SalesHeader.SetRange(Status, SalesHeader.Status::Released);
            if SalesHeader.FindSet() then begin
                repeat
                    SalesHeader.Mark(true);
                    NoOfRecord := NoOfRecord - 1;
                until (SalesHeader.Next() = 0) OR (NoOfRecord = 0);
                SalesHeader.MarkedOnly(true);
                SalesHeader.FindSet();
            end;
        end;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Warehouse Source Filter", 'OnBeforeSetTableView', '', false, false)]
    // local procedure OnBeforeSetTableView(var WarehouseRequest: Record "Warehouse Request"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var PurchaseLine: Record "Purchase Line"; var TransferLine: Record "Transfer Line"; var ServiceHeader: Record "Service Header"; var ServiceLine: Record "Service Line"; var WarehouseSourceFilter: Record "Warehouse Source Filter"; var PurchaseHeader: Record "Purchase Header")
    // begin
    //     Clear(G_NoOfOrderToProcess);
    //     G_NoOfOrderToProcess := WarehouseSourceFilter."Number of Records";
    // end;


    // [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterSalesHeaderOnAfterGetRecord', '', false, false)]
    // local procedure OnAfterSalesHeaderOnAfterGetRecord(SalesHeader: Record "Sales Header"; var SkipRecord: Boolean; var BreakReport: Boolean; var WarehouseRequest: Record "Warehouse Request")
    // var
    //     L_SalesLine: Record "Sales Line";
    // begin
    //     if (G_FromSalesOrderScreen = false) then begin
    //         if (AgentCode = WarehouseRequest."Shipping Agent Code") and (CustomerCode = SalesHeader."Sell-to Customer No.") then begin
    //             if (ServiceCode = WarehouseRequest."Shipping Agent Service Code") or (ServiceCode = '') then begin
    //                 if NoOfOrderToProcess <= 0 then
    //                     BreakReport := true;
    //                 NoOfOrderToProcess -= 1;
    //             end;
    //         end;
    //     end;
    // end;
    //No Of Records Customization -------------



    //Step1++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    procedure ClearGLVariable(_SakipBlockedItem: Boolean; _SkipBlockedCustomer: Boolean; _NoOfOrderToProcess: Integer)
    begin
        Clear(G_FromSalesOrderScreen);
        Clear(G_Location);
        Clear(G_NoOfOrderToProcess);
        G_NoOfOrderToProcess := _NoOfOrderToProcess;
        G_WhseShptHeader.Reset();
        G_SkipBlockedCustomer := _SkipBlockedCustomer;
        G_SkipBlockedItem := _SakipBlockedItem;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnBeforeCreateFromSalesOrder', '', false, false)]
    local procedure OnBeforeCreateFromSalesOrder()
    begin
        G_FromSalesOrderScreen := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnAfterCreateWhseShipmentHeaderFromWhseRequest', '', false, false)]
    local procedure OnAfterCreateWhseShipmentHeaderFromWhseRequest()
    begin
        G_FromSalesOrderScreen := false;
    end;
    // //Step1++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    //Step2++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterSalesLineOnPreDataItem', '', false, false)]
    local procedure OnAfterSalesLineOnPreDataItem(OneHeaderCreated: Boolean)
    begin
        G_OneHeaderCreated := OneHeaderCreated;
    end;

    //Step3++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeSalesLineOnAfterGetRecord', '', false, false)]
    local procedure OnBeforeSalesLineOnAfterGetRecord(RequestType: Option; SalesLine: Record "Sales Line"; var IsHandled: Boolean; WarehouseRequest: Record "Warehouse Request")
    var
        L_Item: Record Item;
    begin
        if (G_FromSalesOrderScreen = false) AND (G_OneHeaderCreated = false) then begin
            //Skip Blocked Item
            if G_SkipBlockedItem = true then begin
                L_Item.Reset();
                L_Item.SetRange("No.", SalesLine."No.");
                if L_Item.FindFirst() then begin
                    if L_Item.Blocked = true then begin
                        IsHandled := true;
                        //SkipBlockedItem := true;
                    end;
                end;
            end;
        end;
    end;

    //Step4++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeSalesHeaderOnAfterGetRecord', '', false, false)]
    local procedure OnBeforeSalesHeaderOnAfterGetRecord(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        L_Customer: Record Customer;
    begin
        if (G_FromSalesOrderScreen = false) AND (G_OneHeaderCreated = false) then begin
            //Skip Blocked Customer
            if G_SkipBlockedCustomer = true then begin
                L_Customer.Reset();
                L_Customer.SetRange("No.", SalesHeader."Sell-to Customer No.");
                if L_Customer.FindFirst() then begin
                    if L_Customer.Blocked <> L_Customer.Blocked::" " then
                        IsHandled := true;
                end;
            end;
        end;
    end;


    //Step5++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnSalesLineOnAfterCreateShptHeader', '', false, false)]
    local procedure OnSalesLineOnAfterCreateShptHeader(WarehouseRequest: Record "Warehouse Request"; var WhseShptHeader: Record "Warehouse Shipment Header")
    begin
        if (G_FromSalesOrderScreen = false) AND (G_OneHeaderCreated = false) then begin
            Clear(G_Location);
            G_Location := WarehouseRequest."Location Code";

            G_WhseShptHeader.Reset();
            G_WhseShptHeader.Copy(WhseShptHeader);
        end;
    end;

    //Step6++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnSalesLineOnAfterGetRecordOnBeforeCreateShptHeader', '', false, false)]
    local procedure OnSalesLineOnAfterGetRecordOnBeforeCreateShptHeader(SalesLine: Record "Sales Line"; var WarehouseRequest: Record "Warehouse Request"; var WhseHeaderCreated: Boolean; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        if (G_FromSalesOrderScreen = false) AND (G_OneHeaderCreated = false) then begin
            WarehouseShipmentHeader.Reset();
            WarehouseShipmentHeader.Copy(G_WhseShptHeader);

            //This code to manage Step7++
            if G_WhseHeaderCreated = true then
                WhseHeaderCreated := G_WhseHeaderCreated;

            //This Code to create Different Header++ 
            if G_Location <> WarehouseRequest."Location Code" then
                WhseHeaderCreated := false;
        end;
    end;

    //Step7++
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterProcessDocumentLine', '', false, false)]
    local procedure OnAfterProcessDocumentLine(WhseHeaderCreated: Boolean; var WarehouseRequest: Record "Warehouse Request")
    begin
        if (G_FromSalesOrderScreen = false) AND (G_OneHeaderCreated = false) then begin
            Clear(G_WhseHeaderCreated);
            G_WhseHeaderCreated := WhseHeaderCreated;
        end;
    end;
}