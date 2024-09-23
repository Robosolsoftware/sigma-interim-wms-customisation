pageextension 85116 DebitCollectionlist extends "Direct Debit Collections"
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
                Ellipsis = true;
                //Promoted = true;
                Image = ReceivablesPayables;
                ToolTip = 'Post receipts of a payment for sales invoices. You can this after the direct debit collection is successfully processed by the bank.';

                trigger OnAction()
                var
                    PostDirectDebitCollection: Report "Post Direct Debit Collection2";
                begin
                    Rec.TestField(Status, Rec.Status::"File Created");
                    PostDirectDebitCollection.SetCollectionEntry(Rec."No.");
                    PostDirectDebitCollection.Run();
                end;
            }
        }
    }
    var
        myInt: Integer;
}
