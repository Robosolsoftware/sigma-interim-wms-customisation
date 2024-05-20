codeunit 85005 "Export & Import Blanket SO"
{
    trigger OnRun()
    begin
        ImportBlanketSalesOrder();
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

    local procedure ImportBlanketSalesOrder()
    var
        L_SalesandRecSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        L_Shippingagentservice: Record "Shipping Agent Services";
        L_cust: Record Customer;
    begin
        L_SalesandRecSetup.Get();
        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialoCaption := 'Select File to upload';

        UploadResult := UploadIntoStream(DialoCaption, '', '', FileName, InStr);

        if FileName <> '' then
            SheetName := Rec_ExcelBuffer.SelectSheetsNameStream(InStr)
        else
            exit;

        //Check Duplicate File In sales order++
        InsertSalesHeader.Reset();
        InsertSalesHeader.SetRange("Sheet Name", FileName);
        InsertSalesHeader.SetRange("Document Type", InsertSalesHeader."Document Type"::Order);
        if not InsertSalesHeader.IsEmpty then
            Error('File name %1 already exist', FileName);

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

        //Finiding Total No of Columns to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;


        for RowNo := 2 to Rows do begin
            if GetValueAtIndex(RowNo, 1) <> '' then begin
                //Insert Sales Header+++++
                InsertSalesHeader.Reset();
                InsertSalesHeader.SetRange("Sell-to Customer No.", GetValueAtIndex(RowNo, 1));
                InsertSalesHeader.SetRange("Document Type", InsertSalesHeader."Document Type"::"Blanket Order");
                InsertSalesHeader.SetRange("Sheet Name", FileName);
                if not InsertSalesHeader.FindFirst() then begin
                    InsertSalesHeader.Init();
                    InsertSalesHeader.Validate("Document Type", InsertSalesHeader."Document Type"::"Blanket Order");
                    InsertSalesHeader.Validate("No.", NoSeriesManagement.GetNextNo(L_SalesandRecSetup."Blanket Order Nos.", WORKDATE, TRUE));
                    InsertSalesHeader.Validate("Sell-to Customer No.", GetValueAtIndex(RowNo, 1));
                    if GetValueAtIndex(RowNo, 2) <> '' then
                        InsertSalesHeader.Validate("Ship-to Code", GetValueAtIndex(RowNo, 2));
                    if GetValueAtIndex(RowNo, 8) <> '' then begin
                        Clear(RequestDelivryDate);
                        Evaluate(RequestDelivryDate, GetValueAtIndex(RowNo, 8));
                        InsertSalesHeader.Validate("Requested Delivery Date", RequestDelivryDate);
                    end;
                    InsertSalesHeader.Validate("External Document No.", GetValueAtIndex(RowNo, 9));
                    InsertSalesHeader."Sheet Name" := FileName;
                    InsertSalesHeader."Import Date" := Today;
                    InsertSalesHeader.Insert(true);
                    if GetValueAtIndex(RowNo, 10) <> '' then begin
                        L_Shippingagentservice.Reset();
                        L_Shippingagentservice.SetRange(Code, GetValueAtIndex(RowNo, 10));
                        if L_Shippingagentservice.FindFirst() then begin
                            InsertSalesHeader.Validate("Shipping Agent Code", L_Shippingagentservice."Shipping Agent Code");
                            InsertSalesHeader.Validate("Shipping Agent Service Code", GetValueAtIndex(RowNo, 10));
                        end;
                        L_cust.Reset();
                        L_cust.SetRange("No.", GetValueAtIndex(RowNo, 1));
                        if L_cust.FindFirst() then begin
                            InsertSalesHeader.Validate("Weekend Ship. Agnt. Serv. Code", L_cust."Weekend Ship. Agnt. Serv. Code");
                        end;

                    end;
                    if GetValueAtIndex(RowNo, 11) <> '' then
                        InsertSalesHeader.Validate("Location Code", GetValueAtIndex(RowNo, 11));
                    if GetValueAtIndex(RowNo, 7) <> '' then begin
                        Clear(G_DocumentDate);
                        Evaluate(G_DocumentDate, GetValueAtIndex(RowNo, 7));
                        InsertSalesHeader.Validate("Document Date", G_DocumentDate);
                    end;
                    InsertSalesHeader.Modify(true);
                end;


                //Insert Sales Line++++++++
                InsertSalesHeader.Reset();
                InsertSalesHeader.SetRange("Document Type", InsertSalesHeader."Document Type"::"Blanket Order");
                InsertSalesHeader.SetRange("Sell-to Customer No.", GetValueAtIndex(RowNo, 1));
                InsertSalesHeader.SetRange("Sheet Name", FileName);
                if InsertSalesHeader.FindFirst() then begin
                    InsertSalesLine.Reset();
                    InsertSalesLine.Init();
                    InsertSalesLine.Validate("Document Type", InsertSalesHeader."Document Type");
                    InsertSalesLine.Validate("Document No.", InsertSalesHeader."No.");
                    InsertSalesLine.Validate("Line No.", GetLastLineNo(InsertSalesHeader."No."));
                    InsertSalesLine.Validate(Type, InsertSalesLine.Type::Item);
                    InsertSalesLine.Validate("No.", GetValueAtIndex(RowNo, 3));
                    if GetValueAtIndex(RowNo, 4) <> '' then
                        InsertSalesLine.Validate("Variant Code", GetValueAtIndex(RowNo, 4));
                    if GetValueAtIndex(RowNo, 5) <> '' then begin
                        Clear(G_Quantity);
                        Evaluate(G_Quantity, GetValueAtIndex(RowNo, 5));
                        InsertSalesLine.Validate(Quantity, G_Quantity);
                    end else
                        InsertSalesLine.Validate(Quantity, 0);
                    if GetValueAtIndex(RowNo, 6) <> '' then begin
                        Clear(G_UnitPrice);
                        Evaluate(G_UnitPrice, GetValueAtIndex(RowNo, 6));
                        InsertSalesLine.Validate("Unit Price", G_UnitPrice);
                    end;
                    InsertSalesLine.Insert(true);
                end;
            end else
                Error('Sell-to customer No. should not be blank in Row No. %1', Rows);
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
        LastaSalesLine.SetRange("Document Type", LastaSalesLine."Document Type"::"Blanket Order");
        LastaSalesLine.SetRange("Document No.", OrderNo);
        if LastaSalesLine.FindLast() then
            exit(LastaSalesLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure SampleBlanketSOTemplate()
    var
        //excelbuffer2: Record "Excel Buffer" temporary;
        Excelbuffer: Record "Excel Buffer" temporary;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;
    begin
        Excelbuffer.Reset();
        Excelbuffer.DeleteAll();
        Excelbuffer.NewRow();
        Excelbuffer.AddColumn('Sell to Customer No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Ship to Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Item No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Variant Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Quantity', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Unit Price', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Document Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Requested Delivery Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('External Document No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.CreateNewBook('Sample Template');
        Excelbuffer.WriteSheet('Sample Template', CompanyName, UserId);
        Excelbuffer.CloseBook();


        TempBLOB.CreateOutStream(outs);
        Excelbuffer.SaveToStream(outs, false);
        TempBLOB.CreateInStream(ins);
        filename := 'BlanketSalesOrderTemplate_' + Format(CurrentDateTime) + '.xlsx';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
    end;

}