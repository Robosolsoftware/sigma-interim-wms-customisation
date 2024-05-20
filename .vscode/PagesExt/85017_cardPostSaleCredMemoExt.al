pageextension 85017 PostSaleCreditMemoCardExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Your Reference")
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