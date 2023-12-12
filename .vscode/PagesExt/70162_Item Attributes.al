pageextension 70162 "SC Item Attributes" extends "Item Attributes"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("CD Schedule"; Rec."CD Schedule")
            {
                ApplicationArea = All;
            }
            field(Fridge; Rec.Fridge)
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