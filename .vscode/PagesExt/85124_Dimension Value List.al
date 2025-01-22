pageextension 85124 "SC Dimension Value List" extends "Dimension Value List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("SO Approval Required"; Rec."SO Approval Required")
            {
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