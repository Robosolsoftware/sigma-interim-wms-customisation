pageextension 70133 WhseRcpSubformRbe extends "Whse. Receipt Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Warehouse Class Code"; Rec."Warehouse Class Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Brand; Rec.Brand)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pack Size"; Rec."Pack Size")

            {
                ApplicationArea = all;
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