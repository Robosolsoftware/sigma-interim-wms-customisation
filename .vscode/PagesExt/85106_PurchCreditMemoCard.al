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
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}