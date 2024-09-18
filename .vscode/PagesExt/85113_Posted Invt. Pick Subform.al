pageextension 85113 "SC Posted Invt. Pick Subform" extends "Posted Invt. Pick Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Unable to Pick"; Rec."Unable to Pick")
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