codeunit 70103 "Import Sales Order"
{
    trigger OnRun()
    begin
        ImportSalesOrder();
    end;

    var
        myInt: Integer;
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        DialoCaption: Text;
        UploadResult: Boolean;
        InStr: InStream;
        FileName: Text[100];
        SheetName: Text[100];
        LineNo: Integer;
        RowNo: Integer;
        FindCustomerNo: Code[20];
        ExterNalIdType: Code[10];
        str: Text[100];
        pos: Integer;
        FINALSTRING: Text[100];
        GetString: Text[100];
        InsertSalesHeader: Record "Sales Header";
        InsertSalesLine: Record "Sales Line";
        RequestDelivryDate: Date;
        G_Quantity: Decimal;
        G_UnitPrice: Decimal;
        ReleaseSalesHeader: Record "Sales Header";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        G_Type: Option Comment,"G/L Account","Item","Resource","Fixed Asset","Charge (Item)";
        G_Item: Record Item;
        G_ExpiryDate: Date;
        G_SupplierCost: Decimal;
        G_DocumentDate: Date;
        G_Discount: Decimal;
        G_DocumentType: Enum "Sales Document Type";

    local procedure ImportSalesOrder()
    begin
        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialoCaption := 'Select File to upload';

        UploadResult := UploadIntoStream(DialoCaption, '', '', FileName, InStr);

        if FileName <> '' then
            SheetName := Rec_ExcelBuffer.SelectSheetsNameStream(InStr)
        else
            exit;

        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.OpenBookStream(InStr, SheetName);
        Rec_ExcelBuffer.ReadSheet();
        Commit();

        //Finiding Total No of Rows to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        If Rec_ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until Rec_ExcelBuffer.Next() = 0;

        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;

        for RowNo := 2 to Rows do begin
            if GetValueAtIndex(RowNo, 2) <> '' then begin
                //Insert Sales Header+++++
                InsertSalesHeader.Reset();
                InsertSalesHeader.SetRange("No.", GetValueAtIndex(RowNo, 2));
                Clear(G_DocumentType);
                Evaluate(G_DocumentType, GetValueAtIndex(RowNo, 1));
                InsertSalesHeader.SetRange("Document Type", G_DocumentType);
                if not InsertSalesHeader.FindFirst() then begin
                    InsertSalesHeader.Init();
                    InsertSalesHeader.Validate("Document Type", G_DocumentType);
                    InsertSalesHeader.Validate("No.", GetValueAtIndex(RowNo, 2));
                    InsertSalesHeader.Validate("Sell-to Customer No.", GetValueAtIndex(RowNo, 3));
                    if GetValueAtIndex(RowNo, 4) <> '' then
                        InsertSalesHeader.Validate("Bill-to Customer No.", GetValueAtIndex(RowNo, 4));
                    if GetValueAtIndex(RowNo, 6) <> '' then
                        InsertSalesHeader.Validate("Ship-to Code", GetValueAtIndex(RowNo, 6));

                    if GetValueAtIndex(RowNo, 12) <> '' then
                        InsertSalesHeader.Validate("Currency Code", GetValueAtIndex(RowNo, 12));

                    if GetValueAtIndex(RowNo, 12) <> '' then begin
                        Clear(RequestDelivryDate);
                        Evaluate(RequestDelivryDate, GetValueAtIndex(RowNo, 14));
                        InsertSalesHeader.Validate("Requested Delivery Date", RequestDelivryDate);
                    end;
                    InsertSalesHeader.Validate("External Document No.", GetValueAtIndex(RowNo, 15));

                    InsertSalesHeader.Validate("Location Code", GetValueAtIndex(RowNo, 5));
                    InsertSalesHeader."Sheet Name" := SheetName;
                    InsertSalesHeader."Import Date" := Today;
                    InsertSalesHeader.Insert(true);

                    if GetValueAtIndex(RowNo, 13) <> '' then begin
                        Clear(G_DocumentDate);
                        Evaluate(G_DocumentDate, GetValueAtIndex(RowNo, 13));
                        //InsertSalesHeader.Validate("Posting Date", G_DocumentDate);
                        //InsertSalesHeader.Validate("Order Date", G_DocumentDate);
                        InsertSalesHeader.Validate("Document Date", G_DocumentDate);
                        InsertSalesHeader.Modify(true);
                    end;
                end;


                //Insert Sales Line++++++++
                InsertSalesLine.Reset();
                InsertSalesLine.Init();
                InsertSalesLine.Validate("Document Type", G_DocumentType);
                InsertSalesLine.Validate("Document No.", GetValueAtIndex(RowNo, 2));
                InsertSalesLine.Validate("Line No.", GetLastLineNo(GetValueAtIndex(RowNo, 2)));
                Clear(G_Type);
                Evaluate(G_Type, GetValueAtIndex(RowNo, 7));
                if G_Type = G_Type::Comment then
                    InsertSalesLine.Validate(Type, InsertSalesLine.Type::" ")
                else
                    InsertSalesLine.Validate(Type, G_Type);

                InsertSalesLine.Validate("No.", GetValueAtIndex(RowNo, 8));
                if GetValueAtIndex(RowNo, 9) <> '' then
                    InsertSalesLine.Validate(Description, GetValueAtIndex(RowNo, 9));

                InsertSalesLine.Validate("Location Code", GetValueAtIndex(RowNo, 5));
                if GetValueAtIndex(RowNo, 10) <> '' then begin
                    Clear(G_Quantity);
                    Evaluate(G_Quantity, GetValueAtIndex(RowNo, 10));
                    InsertSalesLine.Validate(Quantity, G_Quantity);
                end else
                    InsertSalesLine.Validate(Quantity, 0);

                if GetValueAtIndex(RowNo, 11) <> '' then begin
                    Clear(G_UnitPrice);
                    Evaluate(G_UnitPrice, GetValueAtIndex(RowNo, 11));
                    InsertSalesLine.Validate("Unit Price", G_UnitPrice);
                end;

                // if GetValueAtIndex(RowNo, 20) <> '' then begin
                //     Clear(G_SupplierCost);
                //     Evaluate(G_SupplierCost, GetValueAtIndex(RowNo, 20));
                //     InsertSalesLine.Validate("Supplier cost", G_SupplierCost);
                // end;

                // G_Item.Reset();
                // G_Item.SetRange("No.", GetValueAtIndex(RowNo, 7));
                // if G_Item.FindFirst() then begin
                //     if GetValueAtIndex(RowNo, 22) <> '' then
                //         InsertSalesLine.Validate("_Manufacturer Code", GetValueAtIndex(RowNo, 22))
                //     else
                //         InsertSalesLine.Validate("_Manufacturer Code", G_Item."_Manufacturer Code");

                // end;

                // if GetValueAtIndex(RowNo, 21) <> '' then begin
                //     Clear(G_Discount);
                //     Evaluate(G_Discount, GetValueAtIndex(RowNo, 21));
                //     InsertSalesLine.Validate("Line Discount %", G_Discount);
                // end;
                InsertSalesLine.Insert(true);
            end else
                Error('Sales Order No. should not be blank in Row No. %1', Rows);
        end; //Do Begin++

        // //After All data imported+++
        // //Change Status to Release+++
        // ReleaseSalesHeader.Reset();
        // ReleaseSalesHeader.SetRange("Sheet Name", SheetName);
        // ReleaseSalesHeader.SetRange("Import Date", Today);
        // if ReleaseSalesHeader.FindSet() then
        //     repeat
        //         if ReleaseSalesHeader.Status = ReleaseSalesHeader.Status::Open then begin
        //             ReleaseSalesDoc.PerformManualRelease(ReleaseSalesHeader);
        //         end;
        //     until ReleaseSalesHeader.Next() = 0;
        // Message('Imported SuccessFully');


    end;


    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text

    var

        Rec_ExcelBuffer: Record "Excel Buffer";

    begin

        Rec_ExcelBuffer.Reset();

        If Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");

    end;


    local procedure GetLastLineNo(OrderNo: Code[50]): Integer
    var
        LastaSalesLine: Record "Sales Line";
    begin
        LastaSalesLine.Reset();
        LastaSalesLine.SetRange("Document Type", LastaSalesLine."Document Type"::Order);
        LastaSalesLine.SetRange("Document No.", OrderNo);
        if LastaSalesLine.FindLast() then
            exit(LastaSalesLine."Line No." + 10000)
        else
            exit(10000);
    end;

}