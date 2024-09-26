pageextension 85090 "Cash Receipt Journal Ext" extends "Cash Receipt Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Apply Entries")
        {
            action("Create Direct Debit Payments")
            {
                ApplicationArea = All;
                Caption = 'Create Direct Debit Payments';
                Image = CashReceiptJournal;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    REP_CreateJournalPayments: Report "Direct Debit Payments";
                begin
                    Clear(REP_CreateJournalPayments);
                    REP_CreateJournalPayments.Run();
                end;
            }


        }
    }
}