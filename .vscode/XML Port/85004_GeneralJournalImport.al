xmlport 85004 "Import General Journal"
{
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Import';
                UseTemporary = true;

                textelement(TemplateNameT)
                {
                }
                textelement(BatchNameT)
                {
                }
                textelement(PostingDateT)
                {
                }
                textelement(DocumentTypeT)
                {
                }
                textelement(DocumentNoT)
                {
                }
                textelement(AccountTypeT)
                {
                }
                textelement(AccountNoT)
                {
                }
                textelement(DescriptionT)
                {
                }
                textelement(AmountT)
                {
                }
                textelement(BalanceAccountTypeT)
                {
                }
                textelement(BalanceT)
                {

                }
                textelement(CostCodeT)
                {
                    MinOccurs = Zero;
                }
                textelement(ShortcutDim2T)
                {
                    MinOccurs = Zero;
                }
                textelement(DocumentDateT)
                {
                }
                textelement(pmtdisdateT)
                {
                    MinOccurs = Zero;
                }
                textelement(pymentmethod)
                {
                    MinOccurs = Zero;
                }
                textelement(exdocno)
                {
                    MinOccurs = Zero;
                }
                textelement(DueDateT)
                {

                }
                textelement(CurrencyCodeT)
                {

                }
                trigger OnBeforeInsertRecord()
                begin
                    IF firstline THEN BEGIN
                        firstline := FALSE;
                        currXMLport.SKIP;
                    END;
                    EVALUATE(TemplateName, TemplateNameT);
                    EVALUATE(BatchName, BatchNameT);
                    EVALUATE(PostingDate, PostingDateT);
                    EVALUATE(DocumentType, DocumentTypeT);
                    EVALUATE(DocumentNo, DocumentNoT);
                    EVALUATE(AccountType, AccountTypeT);
                    EVALUATE(AccountNo, AccountNoT);
                    EVALUATE(Description, DescriptionT);
                    EVALUATE(Amount, AmountT);
                    Evaluate(BalanceAccType, BalanceAccountTypeT);
                    EVALUATE(Balance, BalanceT);
                    EVALUATE(CostCode, CostCodeT);
                    EVALUATE(ShorcutDim2, ShortcutDim2T);
                    if DocumentDateT <> '' then EVALUATE(DocumentDate, DocumentDateT) Else Clear(DocumentDate);

                    if DueDateT <> '' then
                        Evaluate(DueDate, DueDateT)
                    else
                        Clear(DueDate);

                    if pmtdisdateT <> '' then EVALUATE(pmtdisdate, pmtdisdateT) Else Clear(PmtDisDate);
                    GeneralJournal.RESET;
                    GeneralJournal.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
                    GeneralJournal.SETFILTER(GeneralJournal."Journal Template Name", TemplateName);
                    GeneralJournal.SETFILTER(GeneralJournal."Journal Batch Name", BatchName);
                    IF GeneralJournal.FINDLAST THEN BEGIN
                        CNT := GeneralJournal."Line No." + 10000;
                    END
                    ELSE
                        CNT := 10000;
                    GeneralJournal.INIT;
                    GeneralJournal.VALIDATE(GeneralJournal."Journal Template Name", TemplateName);
                    GeneralJournal.VALIDATE(GeneralJournal."Journal Batch Name", BatchName);
                    GeneralJournal.VALIDATE(GeneralJournal."Posting Date", PostingDate);
                    GeneralJournal.VALIDATE(GeneralJournal."Document Date", DocumentDate);
                    GeneralJournal."Line No." := CNT;
                    IF DocumentTypeT = 'Payment' THEN
                        GeneralJournal.VALIDATE(GeneralJournal."Document Type", 1)
                    ELSE
                        IF DocumentTypeT = 'Invoice' THEN
                            GeneralJournal.VALIDATE(GeneralJournal."Document Type", 2)
                        ELSE
                            IF DocumentTypeT = 'Credit Memo' THEN
                                GeneralJournal.VALIDATE(GeneralJournal."Document Type", 3)
                            ELSE
                                IF DocumentTypeT = 'Finance Charge Memo' THEN
                                    GeneralJournal.VALIDATE(GeneralJournal."Document Type", 4)
                                ELSE
                                    IF DocumentTypeT = 'Reminder' THEN
                                        GeneralJournal.VALIDATE(GeneralJournal."Document Type", 5)
                                    ELSE
                                        IF DocumentTypeT = 'Refund' THEN GeneralJournal.VALIDATE(GeneralJournal."Document Type", 6);
                    GeneralJournal.VALIDATE(GeneralJournal."Document No.", DocumentNo);
                    case AccountTypeT of
                        'Customer':
                            GeneralJournal.VALIDATE(GeneralJournal."Account Type", 1);
                        'Vendor':
                            GeneralJournal.VALIDATE(GeneralJournal."Account Type", 2);
                        'G/L Account':
                            GeneralJournal.VALIDATE(GeneralJournal."Account Type", 0);
                        'Bank Account':
                            GeneralJournal.VALIDATE(GeneralJournal."Account Type", 3);
                        'Fixed Asset':
                            GeneralJournal.VALIDATE(GeneralJournal."Account Type", 4);
                        'IC Partner':
                            GeneralJournal.VALIDATE(GeneralJournal."Account Type", 5);
                    End;
                    GeneralJournal.VALIDATE(GeneralJournal."Account No.", AccountNo);
                    IF DescriptionT <> '' THEN GeneralJournal.VALIDATE(GeneralJournal.Description, Description);
                    GeneralJournal.VALIDATE(GeneralJournal.Amount, Amount);
                    case BalanceAccountTypeT of
                        'Customer':
                            GeneralJournal.VALIDATE(GeneralJournal."Bal. Account Type", 1);
                        'Vendor':
                            GeneralJournal.VALIDATE(GeneralJournal."Bal. Account Type", 2);
                        'G/L Account':
                            GeneralJournal.VALIDATE(GeneralJournal."Bal. Account Type", 0);
                        'Bank Account':
                            GeneralJournal.VALIDATE(GeneralJournal."Bal. Account Type", 3);
                        'Fixed Asset':
                            GeneralJournal.VALIDATE(GeneralJournal."Bal. Account Type", 4);
                        'IC Partner':
                            GeneralJournal.VALIDATE(GeneralJournal."Bal. Account Type", 5);
                    End;
                    GeneralJournal.VALIDATE(GeneralJournal."Bal. Account No.", Balance);
                    GeneralJournal.VALIDATE(GeneralJournal."Shortcut Dimension 1 Code", CostCode);
                    GeneralJournal.VALIDATE(GeneralJournal."Shortcut Dimension 2 Code", ShorcutDim2);
                    //IF CustomerGroup <> '' THEN GeneralJournal.ValidateShortcutDimCode(3, CustomerGroup);
                    //IF House <> '' THEN GeneralJournal.ValidateShortcutDimCode(4, House);
                    GeneralJournal.VALIDATE(GeneralJournal."Payment Method Code", pymentmethod);
                    GeneralJournal.VALIDATE(GeneralJournal."Pmt. Discount Date", pmtdisdate);
                    GeneralJournal.VALIDATE(GeneralJournal."External Document No.", exdocno);
                    GeneralJournal.Validate("Due Date", DueDate);
                    GeneralJournal.Validate("Currency Code", CurrencyCodeT);
                    GeneralJournal.INSERT(TRUE);
                    DescriptionT := '';
                    Integer.DELETEALL;
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
        firstline := TRUE;
    end;

    var
        PostingDate: Date;
        TemplateName: Code[10];
        BatchName: Code[10];
        DocumentType: Text[30];
        DocumentNo: Code[20];
        AccountType: Text[30];
        BalanceAccType: Text[30];
        AccountNo: Code[20];
        Description: Text[50];
        Amount: Decimal;
        GeneralJournal: Record 81;
        CNT: Integer;
        Balance: Code[20];
        ReasonCode: Code[10];
        CostCode: Code[10];
        House: Code[10];
        Department: Code[10];
        CustomerGroup: Code[10];
        firstline: Boolean;
        ShorcutDim2: code[10];
        DocumentDate: Date;
        PmtDisDate: Date;
        DueDate: Date;
}
