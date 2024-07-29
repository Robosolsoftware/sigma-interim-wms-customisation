pageextension 85100 "SC Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("PO Approval required"; Rec."PO Approval required")
            {
                Caption = 'Approval Required';
                ApplicationArea = All;
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