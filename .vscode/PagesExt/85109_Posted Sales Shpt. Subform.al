pageextension 85109 "SC Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(Reclassified; Rec.Reclassified)
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