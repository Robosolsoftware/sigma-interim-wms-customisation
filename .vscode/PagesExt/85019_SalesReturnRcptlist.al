pageextension 85019 returnrcptList extends "Posted Return Receipts"
{
    layout
    {
        addafter("Location Code")
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