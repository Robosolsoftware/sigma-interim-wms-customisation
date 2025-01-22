pageextension 85125 "SC Dimension Values" extends "Dimension Values"
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