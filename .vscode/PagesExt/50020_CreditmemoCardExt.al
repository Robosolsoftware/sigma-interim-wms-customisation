pageextension 50020 SalesCreditMemoCard extends "Sales Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}