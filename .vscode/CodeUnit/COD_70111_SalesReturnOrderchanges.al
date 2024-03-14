codeunit 70111 SalesReturnOrderChanges
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
    begin
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

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnAfterCreateWhseReceiptHeaderFromWhseRequest', '', true, true)]
    // local procedure UpdateReturnorderNo(var WhseReceiptHeader: Record "Warehouse Receipt Header")
    // var
    //     L_WareRcptLine: Record "Warehouse Receipt Line";
    //     L_saleline: Record "Sales Line";
    //     tes:
    // begin
    //     L_WareRcptLine.Reset();
    //     L_saleline.Reset();
    //     L_WareRcptLine.SetRange("No.", WhseReceiptHeader."No.");
    //     if L_WareRcptLine.FindFirst() then begin
    //         L_saleline.SetRange("Document Type", L_saleline."Document Type"::"Return Order");
    //         L_saleline.SetRange("Document No.", L_WareRcptLine."Source No.");
    //         L_WareRcptLine."Return Invoice No." := L_saleline."Sales Return Order Invoice No.";
    //         L_WareRcptLine."Return Invoice Line No." := L_saleline."Sales Return Order Line No.";
    //         L_WareRcptLine.Modify();
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesInvLine', '', true, true)]
    local procedure UpdateSaleLine(var FromSalesInvLine: Record "Sales Invoice Line"; var TempDocSalesLine: Record "Sales Line" temporary; var FromSalesLineBuf: Record "Sales Line")
    begin
        FromSalesLineBuf."Sales Return Order Invoice No." := FromSalesInvLine."Document No.";
        FromSalesLineBuf."Sales Return Order Line No." := FromSalesInvLine."Line No.";
        FromSalesLineBuf.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", 'OnAfterCreateRcptLineFromSalesLine', '', true, true)]
    local procedure UpdateWhseRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; SalesLine: Record "Sales Line")
    begin
        WarehouseReceiptLine."Return Invoice No." := SalesLine."Sales Return Order Invoice No.";
        WarehouseReceiptLine."Return Invoice Line No." := SalesLine."Sales Return Order Line No.";
        WarehouseReceiptLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Return Receipts", 'OnCreateInvLinesOnAfterReturnRcptLoop', '', true, true)]
    local procedure ReturnOrderNoONSaleCreditMemo(SalesLine: Record "Sales Line"; ReturnReceiptLine: Record "Return Receipt Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine."Return Order No." := ReturnReceiptLine."Return Order No.";
        SalesLine."Return Order Line No." := ReturnReceiptLine."Return Order Line No.";
        SalesLine.Modify();
    end;
}