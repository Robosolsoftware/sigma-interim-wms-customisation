
report 70544 "Create Warehouse Shipment V2"
{
    UsageCategory = Tasks;
    ApplicationArea = Warehouse;
    ProcessingOnly = true;
    Caption = 'Create Warehouse Shipment Version2';

    dataset
    {
        dataitem("Warehouse Request"; "Warehouse Request")
        {
            DataItemTableView = sorting("Source Document", "Source No.") where(Type = const(Outbound), "Document Status" = const(Released));
            RequestFilterFields = "Source Document", "Source No.", "Location Code";

            trigger OnPostDataItem()
            var
                L_WarehouseRequest: Record "Warehouse Request";
                Location: Record Location;
            begin
                Clear(L_WarehouseRequest);
                L_WarehouseRequest.Reset();
                L_WarehouseRequest.Copy("Warehouse Request");

                L_WarehouseRequest.SetCurrentKey("Location Code");
                L_WarehouseRequest.Ascending(true);
                if L_WarehouseRequest.FindSet() then begin
                    repeat
                        if Location.RequireShipment("Location Code") then begin
                            case L_WarehouseRequest."Source Document" of
                                L_WarehouseRequest."Source Document"::"Purchase Return Order":
                                    CreateWarehouseShipmentForPurchaseReturnOrder(L_WarehouseRequest);
                                L_WarehouseRequest."Source Document"::"Sales Order":
                                    CreateWarehouseShipmentForSalesOrder(L_WarehouseRequest);
                                L_WarehouseRequest."Source Document"::"Outbound Transfer":
                                    CreateWarehouseShipmentForTransferOrder(L_WarehouseRequest);
                                L_WarehouseRequest."Source Document"::"Service Order":
                                    CreateWarehouseShipmentForServiceOrder(L_WarehouseRequest);
                            end;
                        end;
                    until L_WarehouseRequest.Next() = 0;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field("Do Not Fill Qty. to Handle"; DoNotFillQtytoHandle)
                    {
                        Caption = 'Do not fill Qty. to Handle';
                        ApplicationArea = All;
                        ToolTip = 'Specifies if the Quantity to Handle field in the warehouse document is prefilled according to the source document quantities.';
                    }
                    field("Reserved Stock Only"; ReservedFromStock)
                    {
                        Caption = 'Reserved stock only';
                        ToolTip = 'Specifies if you want to include only source document lines that are fully or partially reserved from current stock.';
                        ValuesAllowed = " ", "Full and Partial", Full;
                        ApplicationArea = All;
                    }
                    field(G_SkipBlockedItem; G_SkipBlockedItem)
                    {
                        Caption = 'SkipBlockedItem';
                        ApplicationArea = All;
                    }
                    field(G_SkipBlockedCustomer; G_SkipBlockedCustomer)
                    {
                        Caption = 'SkipBlockedCustomer';
                        ApplicationArea = All;
                    }
                    field(G_NoOfOrderToProcess; G_NoOfOrderToProcess)
                    {
                        ApplicationArea = All;
                        Caption = 'NoOfOrderToProcess';
                    }
                }
            }
        }

    }

    var
        DoNotFillQtytoHandle: Boolean;
        ReservedFromStock: Enum "Reservation From Stock";
        G_SkipBlockedItem: Boolean;
        G_SkipBlockedCustomer: Boolean;
        G_NoOfOrderToProcess: Integer;

    trigger OnPreReport()
    var
        ConsolidateWarehouseShipment: Codeunit "Consolidate Warehouse Shipment";
    begin
        ConsolidateWarehouseShipment.ClearGLVariable(G_SkipBlockedItem, G_SkipBlockedCustomer, G_NoOfOrderToProcess);
    end;

    procedure InitializeRequest(NewDoNotFillQtyToHandle: Boolean; NewReservedFromStock: Enum "Reservation From Stock")
    begin
        DoNotFillQtytoHandle := NewDoNotFillQtyToHandle;
        ReservedFromStock := NewReservedFromStock;
    end;

    local procedure CreateWarehouseShipmentForSalesOrder(_WarehouseRequest: Record "Warehouse Request")
    var
        SalesHeader: Record "Sales Header";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        SalesHeader.Get(SalesHeader."Document Type"::Order, _WarehouseRequest."Source No.");
        if SalesHeader.Status <> SalesHeader.Status::Released then
            exit;

        if not SalesHeader.IsApprovedForPostingBatch() then
            exit;

        if SalesHeader.WhseShipmentConflict(SalesHeader."Document Type", SalesHeader."No.", SalesHeader."Shipping Advice") then
            exit;

        if GetSourceDocOutbound.CheckSalesHeader(SalesHeader, false) then
            exit;

        CreateWarehouseShipmentFromWhseRequest(_WarehouseRequest);
    end;

    local procedure CreateWarehouseShipmentForPurchaseReturnOrder(_WarehouseRequest: Record "Warehouse Request")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Get(PurchaseHeader."Document Type"::"Return Order", _WarehouseRequest."Source No.");
        if PurchaseHeader.Status <> PurchaseHeader.Status::Released then
            exit;

        CreateWarehouseShipmentFromWhseRequest(_WarehouseRequest);
    end;

    local procedure CreateWarehouseShipmentForTransferOrder(_WarehouseRequest: Record "Warehouse Request")
    var
        TransferHeader: Record "Transfer Header";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        TransferHeader.Get(_WarehouseRequest."Source No.");
        if TransferHeader.Status <> TransferHeader.Status::Released then
            exit;

        if GetSourceDocOutbound.CheckTransferHeader(TransferHeader, false) then
            exit;

        CreateWarehouseShipmentFromWhseRequest(_WarehouseRequest);
    end;

    local procedure CreateWarehouseShipmentForServiceOrder(_WarehouseRequest: Record "Warehouse Request")
    var
        ServiceHeader: Record "Service Header";
    begin
        ServiceHeader.Get(ServiceHeader."Document Type"::Order, _WarehouseRequest."Source No.");
        if ServiceHeader."Release Status" <> ServiceHeader."Release Status"::"Released to Ship" then
            exit;

        CreateWarehouseShipmentFromWhseRequest(_WarehouseRequest);
    end;

    local procedure CreateWarehouseShipmentFromWhseRequest(var WarehouseRequest: Record "Warehouse Request")
    var
        GetSourceDocuments: Report "Get Source Documents";
    begin
        WarehouseRequest.SetRecFilter();
        GetSourceDocuments.SetDoNotFillQtytoHandle(DoNotFillQtytoHandle);
        GetSourceDocuments.SetReservedFromStock(ReservedFromStock);
        GetSourceDocuments.UseRequestPage(false);
        GetSourceDocuments.SetTableView(WarehouseRequest);
        GetSourceDocuments.SetHideDialog(true);
        GetSourceDocuments.RunModal();
    end;
}