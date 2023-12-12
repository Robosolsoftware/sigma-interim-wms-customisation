pageextension 70153 "SC Vendor List" extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("PO Approval required"; Rec."PO Approval required")
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