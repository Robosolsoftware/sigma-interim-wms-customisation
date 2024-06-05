codeunit 85017 "Export & Import Transfer Order"
{
    trigger OnRun()
    begin
        ImportTransferOrder();
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
        RowNo: Integer;


    procedure ImportTransferOrder()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        InventorySetup: Record "Inventory Setup";
        L_TransferHeader: Record "Transfer Header";
        L_TransferLine: Record "Transfer Line";
        L_ShipmentDate: Date;
        L_Quantity: Decimal;
    begin
        InventorySetup.Get();

        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialoCaption := 'Select File to upload';

        UploadResult := UploadIntoStream(DialoCaption, '', '', FileName, InStr);

        if FileName <> '' then
            SheetName := Rec_ExcelBuffer.SelectSheetsNameStream(InStr)
        else
            exit;

        L_TransferHeader.Reset();
        L_TransferHeader.SetRange("Sheet Name", FileName);
        if not L_TransferHeader.IsEmpty then
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
            //Check Mandotary Fields++
            if GetValueAtIndex(RowNo, 2) = '' then
                Error('Transfer-from Code should not be blank');

            if GetValueAtIndex(RowNo, 3) = '' then
                Error('Transfer-to Code should not be blank');


            L_TransferHeader.Reset();
            L_TransferHeader.SetRange("Transfer-from Code", GetValueAtIndex(RowNo, 2));
            L_TransferHeader.SetRange("Transfer-to Code", GetValueAtIndex(RowNo, 3));
            L_TransferHeader.SetRange("Sheet Name", FileName);
            if GetValueAtIndex(RowNo, 1) <> '' then begin
                Clear(L_ShipmentDate);
                Evaluate(L_ShipmentDate, GetValueAtIndex(RowNo, 1));
                L_TransferHeader.SetRange("Shipment Date", L_ShipmentDate);
            end;
            if not L_TransferHeader.FindFirst() then begin
                L_TransferHeader.Init();
                L_TransferHeader.Validate("Transfer-from Code", GetValueAtIndex(RowNo, 2));
                L_TransferHeader.Validate("Transfer-to Code", GetValueAtIndex(RowNo, 3));
                // L_TransferHeader.Validate("No. Series", InventorySetup."Transfer Order Nos.");
                L_TransferHeader.Validate("No.", NoSeriesManagement.GetNextNo(InventorySetup."Transfer Order Nos.", WORKDATE, TRUE));
                if GetValueAtIndex(RowNo, 4) <> '' then
                    L_TransferHeader.Validate("In-Transit Code", GetValueAtIndex(RowNo, 4));

                // if GetValueAtIndex(RowNo, 7) <> '' then begin
                //     Clear(L_ShipmentDate);
                //     Evaluate(L_ShipmentDate, GetValueAtIndex(RowNo, 1));
                //     L_TransferHeader.Validate("Shipment Date", L_ShipmentDate);
                //     L_TransferHeader.Validate("Receipt Date", L_ShipmentDate);
                // end;
                L_TransferHeader."Sheet Name" := FileName;
                L_TransferHeader."Import Date" := Today;
                L_TransferHeader.Insert(true);

                L_TransferHeader.Validate("No. Series", InventorySetup."Transfer Order Nos.");
                if GetValueAtIndex(RowNo, 1) <> '' then begin
                    Clear(L_ShipmentDate);
                    Evaluate(L_ShipmentDate, GetValueAtIndex(RowNo, 1));
                    L_TransferHeader.Validate("Shipment Date", L_ShipmentDate);
                    L_TransferHeader.Validate("Receipt Date", L_ShipmentDate);
                    // L_TransferHeader.Modify();
                end;
                L_TransferHeader.Modify();
            end;

            //Insert Transfer Line++++++++
            L_TransferHeader.Reset();
            L_TransferHeader.SetRange("Transfer-from Code", GetValueAtIndex(RowNo, 2));
            L_TransferHeader.SetRange("Transfer-to Code", GetValueAtIndex(RowNo, 3));
            L_TransferHeader.SetRange("Sheet Name", FileName);
            if GetValueAtIndex(RowNo, 7) <> '' then begin
                Clear(L_ShipmentDate);
                Evaluate(L_ShipmentDate, GetValueAtIndex(RowNo, 1));
                L_TransferHeader.SetRange("Shipment Date", L_ShipmentDate);
            end;
            if L_TransferHeader.FindFirst() then begin
                L_TransferLine.Reset();
                L_TransferLine.Init();
                L_TransferLine.Validate("Document No.", L_TransferHeader."No.");
                L_TransferLine.Validate("Line No.", GetLastLineNo(L_TransferHeader."No."));
                L_TransferLine.Validate("Item No.", GetValueAtIndex(RowNo, 5));
                if GetValueAtIndex(RowNo, 6) <> '' then
                    L_TransferLine.Validate("Variant Code", GetValueAtIndex(RowNo, 6));

                // if GetValueAtIndex(RowNo, 7) <> '' then begin
                //     Clear(L_Quantity);
                //     Evaluate(L_Quantity, GetValueAtIndex(RowNo, 7));
                //     L_TransferLine.Validate(Quantity, L_Quantity);
                // end else
                //     L_TransferLine.Validate(Quantity, 0);

                L_TransferLine.Validate("Transfer-from Code", GetValueAtIndex(RowNo, 2));
                if GetValueAtIndex(RowNo, 8) <> '' then begin
                    L_TransferLine.Validate("Transfer-from Bin Code", GetValueAtIndex(RowNo, 8));
                end;

                L_TransferLine.Validate("Transfer-to Code", GetValueAtIndex(RowNo, 3));
                L_TransferLine.Insert(true);

                if GetValueAtIndex(RowNo, 7) <> '' then begin
                    Clear(L_Quantity);
                    Evaluate(L_Quantity, GetValueAtIndex(RowNo, 7));
                    L_TransferLine.Validate(Quantity, L_Quantity);
                    L_TransferLine.Modify();
                end;
            end;
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
        L_TransferLine: Record "Transfer Line";
    begin
        L_TransferLine.Reset();
        L_TransferLine.SetRange("Document No.", OrderNo);
        if L_TransferLine.FindLast() then
            exit(L_TransferLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure SamplePOTemplate()
    var
        Excelbuffer: Record "Excel Buffer" temporary;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;
    begin
        Excelbuffer.Reset();
        Excelbuffer.DeleteAll();
        Excelbuffer.NewRow();
        Excelbuffer.AddColumn('Shipment Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Transfer-from Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Transfer-to Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('In-Transit Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Item No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Variant Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Quantity', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Transfer-from Bin Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.CreateNewBook('Sample Template');
        Excelbuffer.WriteSheet('Sample Template', CompanyName, UserId);
        Excelbuffer.CloseBook();


        TempBLOB.CreateOutStream(outs);
        Excelbuffer.SaveToStream(outs, false);
        TempBLOB.CreateInStream(ins);
        filename := 'SampleTransferOrderTemplate_' + Format(CurrentDateTime) + '.xlsx';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
    end;
}