codeunit 85009 SalesReturnOrderChanges
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;


    #Region Update Line Location+++
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterGetPstdDocLinesToReverse', '', true, true)]
    local procedure UpdateLocationCode(var SalesHeader: Record "Sales Header")
    var
        L_SalesLine: Record "Sales Line";
        L_Location: Record Location;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
            L_Location.Reset();
            L_Location.SetRange("Sales Return Location", true);
            if L_Location.FindFirst() then begin
                L_SalesLine.Reset();
                L_SalesLine.SetRange("Document No.", SalesHeader."No.");
                L_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                if L_SalesLine.FindFirst() then
                    repeat
                        L_SalesLine.Validate("Location Code", L_Location.Code);
                        L_SalesLine.Modify;
                    until L_SalesLine.Next() = 0;
            end else begin
                L_SalesLine.Reset();
                L_SalesLine.SetRange("Document No.", SalesHeader."No.");
                L_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                if L_SalesLine.FindFirst() then
                    repeat
                        L_SalesLine.Validate("Location Code", SalesHeader."Location Code");
                        L_SalesLine.Modify;
                    until L_SalesLine.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEvent_SellCustomerNo(var Rec: Record "Sales Header")
    var
        L_Location: Record Location;
    begin
        if Rec."Document Type" = Rec."Document Type"::"Return Order" then begin
            L_Location.Reset();
            L_Location.SetRange("Sales Return Location", true);
            if L_Location.FindFirst() then begin
                Rec.Validate("Location Code", L_Location.Code);
            end;
        end;
    end;
    #EndRegion Update Line Location+++


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesInvLine', '', true, true)]
    local procedure UpdateSaleLine(var FromSalesInvLine: Record "Sales Invoice Line"; var TempDocSalesLine: Record "Sales Line" temporary; var FromSalesLineBuf: Record "Sales Line"; var ToSalesHeader: Record "Sales Header")
    begin
        if ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::"Return Order" then begin
            FromSalesLineBuf."Sales Return Order Invoice No." := FromSalesInvLine."Document No.";
            FromSalesLineBuf."Sales Return Order Line No." := FromSalesInvLine."Line No.";
            FromSalesLineBuf.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", 'OnAfterCreateRcptLineFromSalesLine', '', true, true)]
    local procedure UpdateWhseRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; SalesLine: Record "Sales Line")
    var
        L_Item: Record Item;
    begin
        if WarehouseReceiptLine."Source Document" = WarehouseReceiptLine."Source Document"::"Sales Return Order" then begin
            WarehouseReceiptLine."Return Invoice No." := SalesLine."Sales Return Order Invoice No.";
            WarehouseReceiptLine."Return Invoice Line No." := SalesLine."Sales Return Order Line No.";

            L_Item.Reset();
            L_Item.SetRange("No.", SalesLine."No.");
            if L_Item.FindFirst() then begin
                WarehouseReceiptLine."Warehouse Class Code" := L_Item."Warehouse Class Code";
                WarehouseReceiptLine."Pack Size" := L_Item."Pack Size";
                WarehouseReceiptLine.Brand := L_Item.Brand;
            end;
            WarehouseReceiptLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnSalesLineOnAfterCreateRcptHeader', '', true, true)]
    local procedure OnSalesLineOnAfterCreateRcptHeader(SalesHeader: Record "Sales Header"; var WhseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
            WhseReceiptHeader."Sales Return Order" := SalesHeader."No.";
            WhseReceiptHeader."Customer No." := SalesHeader."Sell-to Customer No.";
            WhseReceiptHeader."Customer Name" := SalesHeader."Sell-to Customer Name";
            WhseReceiptHeader.Modify();
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Return Receipts", 'OnCreateInvLinesOnAfterReturnRcptLoop', '', true, true)]
    local procedure ReturnOrderNoONSaleCreditMemo(SalesLine: Record "Sales Line"; ReturnReceiptLine: Record "Return Receipt Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine."Return Order No." := ReturnReceiptLine."Return Order No.";
        SalesLine."Return Order Line No." := ReturnReceiptLine."Return Order Line No.";
        SalesLine.Modify();
    end;



    //As discussed with team - Sigma will use sigle invoice to return order+++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLinesToDoc', '', false, false)]
    local procedure OnAfterCopySalesLinesToDoc(var ToSalesHeader: Record "Sales Header"; var FromSalesInvoiceLine: Record "Sales Invoice Line")
    var
        L_SalesInvoiceHeader: Record "Sales Invoice Header";
        L_ToSalesHeader: Record "Sales Header";
    begin
        if ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::"Return Order" then begin
            L_SalesInvoiceHeader.Reset();
            L_SalesInvoiceHeader.SetRange("No.", FromSalesInvoiceLine."Document No.");
            if L_SalesInvoiceHeader.FindFirst() then begin
                L_ToSalesHeader.Reset();
                L_ToSalesHeader.SetRange("Document Type", ToSalesHeader."Document Type");
                L_ToSalesHeader.SetRange("No.", ToSalesHeader."No.");
                if L_ToSalesHeader.FindFirst() then begin
                    L_ToSalesHeader.Validate("Shipping Agent Code", L_SalesInvoiceHeader."Shipping Agent Code");
                    L_ToSalesHeader.Validate("Shipping Agent Service Code", L_SalesInvoiceHeader."Shipping Agent Service Code 2");
                    L_ToSalesHeader.Validate("Weekend Shipping Agent Code", L_SalesInvoiceHeader."Weekend Shipping Agent Code");
                    L_ToSalesHeader.Validate("Weekend Ship. Agnt. Serv. Code", L_SalesInvoiceHeader."Weekend Ship. Agnt. Serv. Code");
                    L_ToSalesHeader.Modify();
                end;
            end;
        end;
    end;

}