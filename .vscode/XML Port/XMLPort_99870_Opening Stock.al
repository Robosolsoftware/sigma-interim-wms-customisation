xmlport 70120 "Opning Stock_To Use"
{
    Format = VariableText;
    UseRequestPage = false;
    Direction = Import;
    Caption = 'Import Adjst. Excel';
    schema
    {
        textelement(Tables)
        {
            tableelement(integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                SourceTableView = SORTING(Number)
                                  WHERE(Number = CONST(1));
                UseTemporary = false;
                textelement(EntryType)
                {

                }
                textelement(ItemNo)
                {

                }
                textelement(PostingDate)
                {

                }
                textelement(DocumentDate)
                {

                }
                textelement(Document)
                {
                    XmlName = 'DocumentNo';
                }
                textelement(BatchNo)
                {

                }
                // textelement(Salespersoncode)
                // {

                // }

                textelement(expirationdatet)
                {
                    XmlName = 'ExpirationDate';
                }
                textelement(quantityt)
                {
                    XmlName = 'Quantity';
                }
                textelement(locationt)
                {
                    XmlName = 'Location';
                }
                textelement(bint)
                {
                    XmlName = 'Bin';
                }
                textelement(ReasonCode)
                {
                    XmlName = 'ReasonCode';
                }
                // textelement(unitcostt)
                // {
                //     MinOccurs = Zero;
                //     XmlName = 'UnitCost';
                // }
                trigger OnAfterInsertRecord()
                begin
                    if Headerfound = false then begin
                        Headerfound := true;
                        currXMLport.Skip();
                    end;

                    CLEAR(ExpirationDateD);
                    CLEAR(QtyD);
                    //Clear(UnitCostD);
                    Clear(LotNo);
                    Clear(Document_Date);

                    // IF (UnitCostT <> '') THEN
                    //     EVALUATE(UnitCostD, UnitCostT);

                    If (Document <> '') then
                        Evaluate(DocumentNoD, Document);

                    if (DocumentDate <> '') then
                        Evaluate(Document_Date, DocumentDate);

                    if (PostingDate <> '') then
                        Evaluate(PostingDateD, PostingDate);

                    IF QuantityT <> '' THEN
                        EVALUATE(QtyD, QuantityT);

                    if BatchNo <> '' then
                        Evaluate(LotNo, BatchNo);

                    if expirationdatet <> '' then
                        Evaluate(ExpirationDateD, expirationdatet);


                    //Insert Item Journal++
                    ItemJnlLine.INIT;
                    ItemJnlLine."Journal Template Name" := 'ITEM';
                    ItemJnlLine."Journal Batch Name" := 'DEFAULT';
                    ItemJnlLine."Source Code" := 'ITEMJNL';
                    ItemJnlLine.Validate("Document No.", DocumentNoD);
                    ItemJnlLine.VALIDATE("Posting Date", PostingDateD);
                    ItemJnlLine.VALIDATE("Document Date", Document_Date);
                    ItemJnlLine.VALIDATE("Salespers./Purch. Code", Salesperson_code);
                    Evaluate(Entry_Type, EntryType);
                    ItemJnlLine.VALIDATE("Entry Type", Entry_Type);

                    ItemJnlLine2.Reset();
                    ItemJnlLine2.SetFilter("Journal Template Name", 'ITEM');
                    ItemJnlLine2.SetRange("Journal Batch Name", 'DEFAULT');
                    If ItemJnlLine2.FindLast() then
                        ItemJnlLine.Validate("Line No.", ItemJnlLine2."Line No." + 10000)
                    else
                        ItemJnlLine.Validate("Line No.", 10000);


                    ItemJnlLine.VALIDATE("Item No.", ItemNo);
                    Item.GET(ItemJnlLine."Item No.");

                    // if QtyD > 0 then begin
                    //     ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                    ItemJnlLine.VALIDATE(Quantity, QtyD);

                    // end;


                    // IF QtyD < 0 THEN BEGIN
                    //     ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
                    //     ItemJnlLine.VALIDATE(Quantity, -QtyD);

                    // END;

                    ItemJnlLine.VALIDATE("Location Code", LocationT);
                    ItemJnlLine.VALIDATE("Bin Code", BinT);

                    IF UnitCostD <> 0 THEN BEGIN
                        ItemJnlLine.VALIDATE("Unit Cost", UnitCostD);
                        ItemJnlLine.VALIDATE("Unit Amount", UnitCostD);
                        // ItemJnlLine.Validate("External Document No.", ExternalDocNoD);
                        //ItemJnlLine.VALIDATE("Unit Cost",UnitCostD);
                        //ItemJnlLine.VALIDATE("Unit Amount",UnitCostD);

                    END;
                    if ReasonCode <> '' then begin
                        ItemJnlLine.Validate("Reason Code", ReasonCode);
                    end;
                    ItemJnlLine.INSERT(TRUE);


                    //Insert Tracking Lines++
                    ItemTrackingLines.INIT;
                    CLEAR(ItemTrackingLines."Entry No.");
                    IF LotNo <> '' THEN BEGIN
                        ItemTrackingLines.VALIDATE("Item No.", ItemJnlLine."Item No.");
                        ItemTrackingLines."Reservation Status" := ItemTrackingLines."Reservation Status"::Prospect;
                        ItemTrackingLines."Source Batch Name" := ItemJnlLine."Journal Batch Name";
                        ItemTrackingLines."Source ID" := 'ITEM';
                        ItemTrackingLines."Source Ref. No." := ItemJnlLine."Line No.";
                        ItemTrackingLines."Source Type" := 83;

                        ItemTrackingLines."Location Code" := ItemJnlLine."Location Code";
                        ItemTrackingLines."Item Tracking" := ItemTrackingLines."Item Tracking"::"Lot No.";
                        ItemTrackingLines.VALIDATE("Lot No.", LotNo);
                        IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Positive Adjmt." THEN BEGIN
                            ItemTrackingLines.VALIDATE("Quantity (Base)", ItemJnlLine.Quantity);
                            ItemTrackingLines."Source Subtype" := 2;
                            ItemTrackingLines."Expected Receipt Date" := ItemJnlLine."Posting Date";
                            ItemTrackingLines.Positive := TRUE;
                            ItemTrackingLines.VALIDATE("Expiration Date", ExpirationDateD);
                        END ELSE BEGIN
                            ItemTrackingLines.VALIDATE("Quantity (Base)", -ItemJnlLine.Quantity);
                            ItemTrackingLines."Source Subtype" := 3;
                            ItemTrackingLines."Shipment Date" := ItemJnlLine."Posting Date";
                        END;
                        ItemTrackingLines.VALIDATE("Variant Code", ItemJnlLine."Variant Code");

                        ItemTrackingLines."Creation Date" := ItemJnlLine."Posting Date";
                        ItemTrackingLines."Created By" := USERID;
                        ItemTrackingLines.INSERT(TRUE);
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        Line := 10000;
        Headerfound := false;
    end;

    procedure SampleTemplate()
    var
        //excelbuffer2: Record "Excel Buffer" temporary;
        Csvbuffer: Record "CSV Buffer" temporary;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;
    begin
        Csvbuffer.DeleteAll();
        Csvbuffer.InsertEntry(1, 1, 'EntryType');
        Csvbuffer.InsertEntry(1, 2, 'Item Number');
        Csvbuffer.InsertEntry(1, 3, 'Posting Date');
        Csvbuffer.InsertEntry(1, 4, 'Document Date');
        Csvbuffer.InsertEntry(1, 5, 'Document Number');
        Csvbuffer.InsertEntry(1, 6, 'Lot Number');
        Csvbuffer.InsertEntry(1, 7, 'Expiration Date');
        Csvbuffer.InsertEntry(1, 8, 'Qty');
        Csvbuffer.InsertEntry(1, 9, 'Location');
        Csvbuffer.InsertEntry(1, 10, 'Bin');
        Csvbuffer.InsertEntry(1, 11, 'Reason Code');

        Csvbuffer.SaveDataToBlob(TempBLOB, ',');
        TempBLOB.CreateOutStream(outs);
        TempBLOB.CreateInStream(ins);
        filename := 'SampleAdjsTemplate.csv';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
        // excelbuffer2.DeleteAll();
        // excelbuffer2.AddColumn('Document Number' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        // excelbuffer2.CreateNewBook('Sample Template');
        // excelbuffer2.WriteSheet('Sample Template', CompanyName, UserId);
        // excelbuffer2.CloseBook();
        // excelbuffer2.SetFriendlyFilename(StrSubstNo('Sample Template', CurrentDateTime, UserId));
        // excelbuffer2.OpenExcel();
    end;

    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlLine2: Record "Item Journal Line";
        Line: Integer;
        QtyD: Decimal;
        ExpirationDateD: Date;
        ItemTrackingLines: Record 337;
        ItemtrackingLine2: Record 336;
        Item: Record Item;
        UnitCostD: Decimal;
        ItemUnitOfMeasure: Record 5404;
        PostingDateD: Date;
        DocumentNoD: Code[20];
        Document_Date: Date;
        Posting_Date: Date;
        Salesperson_code: Code[20];

        CoseCenterD: Code[20];
        ExternalDocNoD: Code[20];
        DocumentNoT: Code[20];
        LotNo: Code[20];
        Entry_Type: Enum "Item Ledger Entry Type";


        NoSeriesManagement: Codeunit NoSeriesManagement;
        Salesreceivalsetup: Record "Sales & Receivables Setup";
        Headerfound: Boolean;
}

