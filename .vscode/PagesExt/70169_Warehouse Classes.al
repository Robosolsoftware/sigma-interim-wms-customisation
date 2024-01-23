pageextension 70169 "SC Warehouse Classes" extends "Warehouse Classes"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
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