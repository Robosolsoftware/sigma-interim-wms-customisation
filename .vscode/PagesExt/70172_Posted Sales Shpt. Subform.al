pageextension 70172 "SC Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("KNAPP Item"; Rec."KNAPP Item")
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