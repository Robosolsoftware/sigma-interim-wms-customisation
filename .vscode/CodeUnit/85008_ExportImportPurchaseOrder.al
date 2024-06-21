codeunit 85008 "Export & Import Purchase Order"
{
    trigger OnRun()
    begin
        ImportPurchaseOrder();
    end;


    var
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        DialoCaption: Text;
        UploadResult: Boolean;
        InStr: InStream;
        FileName: Text[100];
        SheetName: Text[100];
        PurchHdr: Record "Purchase Header";
        RowNo: Integer;
        RequestReceiptDate: Date;
        G_DocumentDate: Date;
        PurchLn: Record "Purchase Line";
        G_Quantity: Decimal;
        G_UnitCost: Decimal;

    procedure ImportPurchaseOrder()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();

        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialoCaption := 'Select File to upload';

        UploadResult := UploadIntoStream(DialoCaption, '', '', FileName, InStr);

        if FileName <> '' then
            SheetName := Rec_ExcelBuffer.SelectSheetsNameStream(InStr)
        else
            exit;

        PurchHdr.Reset();
        PurchHdr.SetRange("Sheet Name", FileName);
        PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Order);
        if not PurchHdr.IsEmpty then
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
                PurchHdr.Reset();
                PurchHdr.SetRange("Buy-from Vendor No.", GetValueAtIndex(RowNo, 1));
                PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Order);
                PurchHdr.SetRange("Sheet Name", FileName);
                if GetValueAtIndex(RowNo, 7) <> '' then begin
                    Clear(RequestReceiptDate);
                    Evaluate(RequestReceiptDate, GetValueAtIndex(RowNo, 7));
                    PurchHdr.SetRange("Requested Receipt Date", RequestReceiptDate);
                end;
                if GetValueAtIndex(RowNo, 9) <> '' then begin
                    PurchHdr.SetRange("Location Code", GetValueAtIndex(RowNo, 9));
                end;
                if not PurchHdr.FindFirst() then begin
                    PurchHdr.Init();
                    PurchHdr.Validate("Document Type", PurchHdr."Document Type"::Order);
                    PurchHdr.Validate("No.", NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Order Nos.", WORKDATE, TRUE));
                    PurchHdr.Validate("Buy-from Vendor No.", GetValueAtIndex(RowNo, 1));
                    if GetValueAtIndex(RowNo, 7) <> '' then begin
                        Clear(RequestReceiptDate);
                        Evaluate(RequestReceiptDate, GetValueAtIndex(RowNo, 7));
                        PurchHdr.Validate("Requested Receipt Date", RequestReceiptDate);
                    end;
                    PurchHdr.Validate("Vendor Order No.", GetValueAtIndex(RowNo, 8));
                    PurchHdr."Sheet Name" := FileName;
                    PurchHdr."Import Date" := Today;
                    PurchHdr.Insert(true);

                    if GetValueAtIndex(RowNo, 6) <> '' then begin
                        Clear(G_DocumentDate);
                        Evaluate(G_DocumentDate, GetValueAtIndex(RowNo, 7));
                        PurchHdr.Validate("Order Date", G_DocumentDate);
                        //PurchHdr.Modify(true);
                    end;
                    if GetValueAtIndex(RowNo, 9) <> '' then begin
                        PurchHdr.Validate("Location Code", GetValueAtIndex(RowNo, 9));
                        //PurchHdr.Modify(true);
                    end;

                    if GetValueAtIndex(RowNo, 10) <> '' then
                        PurchHdr.Validate("Order Address Code", GetValueAtIndex(RowNo, 10));

                    PurchHdr.Modify(true);

                end;

                //Insert Purchase Line++++++++
                PurchHdr.Reset();
                PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Order);
                PurchHdr.SetRange("Buy-from Vendor No.", GetValueAtIndex(RowNo, 1));
                PurchHdr.SetRange("Sheet Name", FileName);
                if GetValueAtIndex(RowNo, 7) <> '' then begin
                    Clear(RequestReceiptDate);
                    Evaluate(RequestReceiptDate, GetValueAtIndex(RowNo, 7));
                    PurchHdr.SetRange("Requested Receipt Date", RequestReceiptDate);
                end;
                if GetValueAtIndex(RowNo, 9) <> '' then begin
                    PurchHdr.SetRange("Location Code", GetValueAtIndex(RowNo, 9));
                end;
                if PurchHdr.FindFirst() then begin
                    PurchLn.Reset();
                    PurchLn.Init();
                    PurchLn.Validate("Document Type", PurchHdr."Document Type");
                    PurchLn.Validate("Document No.", PurchHdr."No.");
                    PurchLn.Validate("Line No.", GetLastLineNo(PurchHdr."No."));
                    PurchLn.Validate(Type, PurchLn.Type::Item);
                    PurchLn.Validate("No.", GetValueAtIndex(RowNo, 2));
                    if GetValueAtIndex(RowNo, 3) <> '' then
                        PurchLn.Validate("Variant Code", GetValueAtIndex(RowNo, 3));
                    if GetValueAtIndex(RowNo, 4) <> '' then begin
                        Clear(G_Quantity);
                        Evaluate(G_Quantity, GetValueAtIndex(RowNo, 4));
                        PurchLn.Validate(Quantity, G_Quantity);
                    end else
                        PurchLn.Validate(Quantity, 0);
                    if GetValueAtIndex(RowNo, 5) <> '' then begin
                        Clear(G_UnitCost);
                        Evaluate(G_UnitCost, GetValueAtIndex(RowNo, 5));
                        PurchLn.Validate("Direct Unit Cost", G_UnitCost);
                    end;
                    // if GetValueAtIndex(RowNo, 9) <> '' then begin
                    //     PurchLn.Validate("Location Code", GetValueAtIndex(RowNo, 9));
                    // end;
                    PurchLn.Insert(true);
                end;
            end
            else
                Error('Buy-from Vendor No. should not be blank in Row No. %1', Rows);
        end;
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
        L_PurchaseLine: Record "Purchase Line";
    begin
        L_PurchaseLine.Reset();
        L_PurchaseLine.SetRange("Document Type", L_PurchaseLine."Document Type"::Order);
        L_PurchaseLine.SetRange("Document No.", OrderNo);
        if L_PurchaseLine.FindLast() then
            exit(L_PurchaseLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure SamplePOTemplate()
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
        Excelbuffer.AddColumn('Buy-from Vendor No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Item No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Variant Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Quantity', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Unit Cost', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Order Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Requested Receipt Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Vendor Order No', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Location Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Alternate Vendor Address Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.CreateNewBook('Sample Template');
        Excelbuffer.WriteSheet('Sample Template', CompanyName, UserId);
        Excelbuffer.CloseBook();


        TempBLOB.CreateOutStream(outs);
        Excelbuffer.SaveToStream(outs, false);
        TempBLOB.CreateInStream(ins);
        filename := 'SamplePurchaseOrderTemplate_' + Format(CurrentDateTime) + '.xlsx';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
    end;
}
