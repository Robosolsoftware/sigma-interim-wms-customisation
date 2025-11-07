pageextension 85132 PurchaseCreditMemosEXT extends "Purchase Credit Memos"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = all;
                Visible = true;
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