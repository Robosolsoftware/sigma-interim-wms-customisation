pageextension 85095 "SC Payment Methods " extends "Payment Methods"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Fin Option"; Rec."Fin Option")
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