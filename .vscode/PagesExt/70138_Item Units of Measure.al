pageextension 70138 "SC Item Units of Measure" extends "Item Units of Measure"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Sales Order multiple"; Rec."Sales Order multiple")
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