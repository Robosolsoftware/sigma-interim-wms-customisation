pageextension 85130 PostedPurchCreditMemoExt extends "Posted Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = All;
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