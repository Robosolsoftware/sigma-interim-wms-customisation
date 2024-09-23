pageextension 85115 GenBatch extends "General Journal Batches"
{
    layout
    {
        // Add changes to page layout here
        addafter("Suggest Balancing Amount")
        {
            field("Direct Debit Batch"; Rec."Direct Debit Batch")
            {
                ApplicationArea = All;
            }
        }
    }
    var
        myInt: Integer;
}
