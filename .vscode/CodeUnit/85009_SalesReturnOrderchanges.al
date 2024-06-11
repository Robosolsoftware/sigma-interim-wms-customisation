codeunit 85009 SalesReturnOrderChanges
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterGetPstdDocLinesToReverse', '', true, true)]
    local procedure UpdateLocationCode(var SalesHeader: Record "Sales Header")
    var
        L_SalesLine: Record "Sales Line";
        L_Location: Record Location;
    begin
        //Update Line Location+++
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
}