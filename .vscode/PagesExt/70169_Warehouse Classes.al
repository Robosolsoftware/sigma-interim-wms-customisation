pageextension 70169 "SC Warehouse Classes" extends "Warehouse Classes"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            // field("CD Schedule"; Rec."CD Schedule")
            // {
            //     ApplicationArea = All;
            // }
            // field(Fridge; Rec.Fridge)
            // {
            //     ApplicationArea = All;
            // }

            field("Restrict CD 2,3"; Rec."Restrict CD 2,3")
            {
                ApplicationArea = all;
            }
            field("Restrict CD 4,5"; Rec."Restrict CD 4,5")
            {
                ApplicationArea = all;
            }
            field("Restrict Fridge"; Rec."Restrict Fridge")
            {
                ApplicationArea = all;
            }
            field(CD; Rec.CD)
            {
                ApplicationArea = all;
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