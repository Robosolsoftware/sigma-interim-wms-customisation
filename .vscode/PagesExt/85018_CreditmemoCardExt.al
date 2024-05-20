pageextension 85018 SalesCreditMemoCard extends "Sales Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = all;
                Editable = false;
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