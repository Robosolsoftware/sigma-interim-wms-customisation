pageextension 70161 "SC Item Attribute" extends "Item Attribute"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control9)
        {
            field("CD Schedule"; Rec."CD Schedule")
            {
                ApplicationArea = All;
            }
            field(Fridge; Rec.Fridge)
            {
                ApplicationArea = ALl;
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