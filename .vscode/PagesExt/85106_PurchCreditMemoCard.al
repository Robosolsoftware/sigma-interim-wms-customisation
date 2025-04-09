pageextension 85106 PurchCreditMemoCard extends "Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("PO Approval required"; Rec."PO Approval required")
            {
                ApplicationArea = all;
                Caption = 'Approval required';
            }
            field("Purchase Order No."; Rec."Purchase Order No.")
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