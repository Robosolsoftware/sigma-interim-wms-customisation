report 85000 "Direct Debit Payments"
{
    Caption = 'Direct Debit Payments';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = Blocked, Balance, "Payment Method Code";
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");

                trigger OnAfterGetRecord()
                var
                begin
                    CurrCount += 1;
                    Window.Update(1, "Cust. Ledger Entry"."Customer No.");
                    if CreateJnlLine("Cust. Ledger Entry") then begin
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Due Date", FromDate, ToDate);
                    SetFilter("Document Type", '%1|%2', "Cust. Ledger Entry"."Document Type"::"Credit Memo", "Cust. Ledger Entry"."Document Type"::Invoice);
                    if OnlyCustomersWithMandate then
                        SetFilter("Direct Debit Mandate ID", '<>%1', '');
                    TotalCount := Count;
                    Window.Open(ProgressMsg);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(FromDueDate; FromDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'From Due Date';
                    ToolTip = 'Specifies the earliest payment due date that you want to create a cash receipt journal for.';
                }
                field(ToDueDate; ToDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'To Due Date';
                    ToolTip = 'Specifies the latest payment due date that you want to create a cash receipt journal for.';

                    trigger OnValidate()
                    begin
                        if (ToDate <> 0D) and (FromDate > ToDate) then
                            Error(WrongDateErr);
                    end;
                }
                field(OnlyCustomerValidMandate; OnlyCustomersWithMandate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Only Customers With Valid Mandate';
                    ToolTip = 'Specifies if a cash receipt journal is created for customers who have a valid direct-debit mandate.';
                }
                field(BankAccNo; BankAccount."No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Bank Account No.';
                    TableRelation = "Bank Account";
                    ToolTip = 'Specifies which of your company''s bank accounts the collected payment will be transferred to from the customer''s bank account.';

                    trigger OnValidate()
                    begin
                        if BankAccount."No." = '' then
                            exit;
                        BankAccount.Get(BankAccount."No.");
                        if BankAccount."Direct Debit Msg. Nos." = '' then
                            Error(DirectDebitMsgNosErr, BankAccount."No.")
                    end;
                }
                field(BankAccName; BankAccount.Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bank Account Name';
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the name of the bank account that you select in the Bank Account No. field. This field is filled automatically.';
                }
                field(GeneralJournalTemplateName; GeneralJournalTemplateName)
                {
                    ApplicationArea = Suite;
                    Caption = 'General Journal Template';
                    TableRelation = "Gen. Journal Template";
                    ToolTip = 'Specifies the general journal template that the entries are placed in.';

                    trigger OnValidate()
                    var
                        GenJournalTemplate: Record "Gen. Journal Template";
                    begin
                        if GeneralJournalTemplateName = '' then begin
                            GeneralJournalBatchName := '';
                            exit;
                        end;
                        GenJournalTemplate.Get(GeneralJournalTemplateName);
                        if not (GenJournalTemplate.Type in [GenJournalTemplate.Type::General, GenJournalTemplate.Type::Purchases, GenJournalTemplate.Type::Payments, GenJournalTemplate.Type::Sales, GenJournalTemplate.Type::"Cash Receipts"]) then Error(TemplateTypeErr, GenJournalTemplate.Type::General, GenJournalTemplate.Type::Purchases, GenJournalTemplate.Type::Payments, GenJournalTemplate.Type::Sales, GenJournalTemplate.Type::"Cash Receipts");
                        GenJournalTemplate.TestField("No. Series");
                    end;
                }
                field(GeneralJournalBatchName; GeneralJournalBatchName)
                {
                    ApplicationArea = Suite;
                    Caption = 'General Journal Batch';
                    TableRelation = "Gen. Journal Batch";
                    ToolTip = 'Specifies the general journal batch that the entries are placed in.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        GeneralJournalBatches: Page "General Journal Batches";
                    begin
                        GenJournalBatch.SetRange("Journal Template Name", GeneralJournalTemplateName);
                        GeneralJournalBatches.SetTableView(GenJournalBatch);
                        if GeneralJournalBatches.RunModal() = ACTION::OK then begin
                            GeneralJournalBatches.GetRecord(GenJournalBatch);
                            GeneralJournalBatchName := GenJournalBatch.Name;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        GenJournalBatch.Get(GeneralJournalTemplateName, GeneralJournalBatchName);
                        GenJournalBatch.TestField(Recurring, false);
                        GenJournalBatch.TestField("No. Series");
                    end;
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        Window.Close();
        Message('Journal Created');
    end;

    trigger OnPreReport()
    begin
        GenJnlBatch.Get(GeneralJournalTemplateName, GeneralJournalBatchName);
        GenJnlLine.SetRange("Journal Template Name", GeneralJournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", GeneralJournalBatchName);
        if GenJnlLine.FindLast() then;
        LastLineNo := GenJnlLine."Line No.";
    end;

    var
        TemplateTypeErr: Label 'Only General Journal templates of type %1, %2, %3, %4, or %5 are allowed.', Comment = '%1..5 lists Type=General,Purchases,Payments,Sales,Cash Receipts';
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        GeneralJournalTemplateName: Code[10];
        GeneralJournalBatchName: Code[10];
        LastLineNo: Integer;
        TotalCount: Integer;
        CurrCount: Integer;
        ProgressMsg: Label '#1##################';


    procedure SetJnlBatch(NewGenJnlTemplateName: Code[10]; NewGenJnlBachName: Code[10])
    begin
        GeneralJournalTemplateName := NewGenJnlTemplateName;
        GeneralJournalBatchName := NewGenJnlBachName;
        CurrReport.UseRequestPage := false;
    end;

    local procedure CreateJnlLine(var CustomerLedgerEntry: Record "Cust. Ledger Entry"): Boolean
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        NoSeries: Codeunit "No. Series";
        L_CustomerLedgerEntries: Record "Cust. Ledger Entry";
        Rec_CustomerLedgerEntry: Record "Cust. Ledger Entry";
        L_TransferAmount: Decimal;
        LastGenLine: Record "Gen. Journal Line";
    begin
        // code added to add the totatl transfer Amount for 1 Customer ++
        IF L_CustomerNo <> CustomerLedgerEntry."Customer No." then begin
            Clear(L_TransferAmount);
            Clear(L_CustomerNo);
            Rec_CustomerLedgerEntry.Reset();
            Rec_CustomerLedgerEntry.SetRange("Customer No.", "Cust. Ledger Entry"."Customer No.");
            Rec_CustomerLedgerEntry.SetRange("Due Date", FromDate, ToDate);
            Rec_CustomerLedgerEntry.SetFilter("Document Type", '%1|%2', "Cust. Ledger Entry"."Document Type"::"Credit Memo", "Cust. Ledger Entry"."Document Type"::Invoice);
            if OnlyCustomersWithMandate then
                Rec_CustomerLedgerEntry.SetFilter("Direct Debit Mandate ID", '<>%1', '');
            if Rec_CustomerLedgerEntry.FindSet() then begin
                repeat
                    Rec_CustomerLedgerEntry.CalcFields("Remaining Amount");
                    L_TransferAmount := L_TransferAmount + Rec_CustomerLedgerEntry."Remaining Amount";
                until Rec_CustomerLedgerEntry.Next() = 0;
            end;

            L_CustomerNo := CustomerLedgerEntry."Customer No.";
            LastLineNo += 10000;
            LastGenLine := GenJnlLine;
            Clear(GenJnlLine);
            GenJnlLine."Journal Template Name" := GeneralJournalTemplateName;
            GenJnlLine."Journal Batch Name" := GeneralJournalBatchName;
            GenJnlLine."Line No." := LastLineNo;
            if GenJnlBatch."No. Series" <> '' then begin
                GenJnlLine.SetUpNewLine(LastGenLine, LastGenLine."Balance (LCY)", true)
            end;

            GenJnlLine.SetSuppressCommit(true);
            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.Validate("Account No.", CustomerLedgerEntry."Customer No.");
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
            GenJnlLine.Validate("Bal. Account No.", BankAccount."No.");
            SetGenJnlLineDim(CustomerLedgerEntry);
            GenJnlLine.Validate("Posting Date", WorkDate());
            GenJnlLine.Description := StrSubstNo('Autopay BACS %1', WorkDate());
            GenJnlLine.Validate("Currency Code", CustomerLedgerEntry."Currency Code");
            GenJnlLine.Validate(Amount, -L_TransferAmount);
            GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
            GenJnlLine."Direct Debit Mandate ID" := "Cust. Ledger Entry"."Direct Debit Mandate ID";
            GenJnlLine.SetSuppressCommit(false);
            OnAfterCreateJnlLine(GenJnlLine, CustomerLedgerEntry);
            GenJnlLine.Insert(true);
            LastGenLine := GenJnlLine;

            Rec_CustomerLedgerEntry.Reset();
            Rec_CustomerLedgerEntry.SetRange("Customer No.", "Cust. Ledger Entry"."Customer No.");
            Rec_CustomerLedgerEntry.SetRange("Due Date", FromDate, ToDate);
            Rec_CustomerLedgerEntry.SetFilter("Document Type", '%1|%2', "Cust. Ledger Entry"."Document Type"::"Credit Memo", "Cust. Ledger Entry"."Document Type"::Invoice);
            if OnlyCustomersWithMandate then
                Rec_CustomerLedgerEntry.SetFilter("Direct Debit Mandate ID", '<>%1', '');
            if Rec_CustomerLedgerEntry.FindSet() then begin
                repeat
                    Rec_CustomerLedgerEntry.CalcFields("Remaining Amount");
                    Rec_CustomerLedgerEntry.Validate("Applies-to ID", GenJnlLine."Document No.");
                    Rec_CustomerLedgerEntry.Validate("Amount to Apply", Rec_CustomerLedgerEntry."Remaining Amount");
                    Rec_CustomerLedgerEntry.Modify(true);
                until Rec_CustomerLedgerEntry.Next() = 0;
            end;

            exit(true);
        end;
    end;

    local procedure SetGenJnlLineDim(CustLedgEntry: Record "Cust. Ledger Entry")
    var
        DimensionSetIDArr: array[10] of Integer;
    begin
        DimensionSetIDArr[1] := GenJnlLine."Dimension Set ID";
        DimensionSetIDArr[2] := CustLedgEntry."Dimension Set ID";
        GenJnlLine."Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr, GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
        OnAfterSetGenJnlLineDim(GenJnlLine, CustLedgEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateJnlLine(var GenJournalLine: Record "Gen. Journal Line"; CustomerLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetGenJnlLineDim(var GenJournalLine: Record "Gen. Journal Line"; CustLedgEntry: Record "Cust. Ledger Entry")
    begin
    end;

    var
        L_CustomerNo: Code[35];
        FromDate: Date;
        ToDate: Date;
        WrongDateErr: Label 'To Date must be equal to or greater than From Date.';
        OnlyCustomersWithMandate: Boolean;
        BankAccount: Record "Bank Account";
        DirectDebitMsgNosErr: Label 'The bank account %1 is not set up for direct debit collections. It needs a number series for direct debit files. You specify the number series on the card for the bank account.', Comment = '%1=Code, the No. of Bank Account';
}