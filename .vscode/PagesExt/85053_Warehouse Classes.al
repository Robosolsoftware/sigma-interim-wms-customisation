pageextension 85053 "SC Warehouse Classes" extends "Warehouse Classes"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(CD; Rec.CD)
            {
                ApplicationArea = all;
                Caption = 'SF';
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