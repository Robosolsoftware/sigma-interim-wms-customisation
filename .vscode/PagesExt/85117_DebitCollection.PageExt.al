pageextension 85117 DebitCollection extends "Direct Debit Collect. Entries"
{
    actions
    {
        modify(Post)
        {
            Visible = false;
        }
        addafter(Export)
        {
            action(PostConsolidation)
            {
                ApplicationArea = Suite;
                Caption = 'Post Consolidation Payment Receipts';
                //Promoted = true;
                Ellipsis = true;
                Image = ReceivablesPayables;
                ToolTip = 'Post receipts of a payment for sales invoices. You can this after the direct debit collection is successfully processed by the bank.';

                trigger OnAction()
                var
                    DirectDebitCollection: Record "Direct Debit Collection";
                    PostDirectDebitCollection: Report "Post Direct Debit Collection2";
                begin
                    Rec.TestField("Direct Debit Collection No.");
                    DirectDebitCollection.Get(Rec."Direct Debit Collection No.");
                    DirectDebitCollection.TestField(Status, DirectDebitCollection.Status::"File Created");
                    PostDirectDebitCollection.SetCollectionEntry(Rec."Direct Debit Collection No.");
                    PostDirectDebitCollection.SetTableView(Rec);
                    PostDirectDebitCollection.Run();
                end;
            }
        }
    }
    var
        myInt: Integer;
}
