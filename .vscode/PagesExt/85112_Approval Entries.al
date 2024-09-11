pageextension 85112 "SC Approval Entries" extends "Approval Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Details)
        {
            field("Approval Code"; Rec."Approval Code")
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