pageextension 85109 "SC Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Unable to Pick"; Rec."Unable to Pick")
            {
                ApplicationArea = ALl;
                Editable = false;
            }
        }
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