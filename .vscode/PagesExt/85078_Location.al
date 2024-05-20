pageextension 85078 LocationExt extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("GLN Number"; Rec."GLN Number")
            {
                ApplicationArea = All;
            }
            field("Saleable Location"; Rec."Saleable Location")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Home Page")
        {
            field(Deliveryadd; rec.Deliveryadd)
            {
                Caption = 'Delivery Address 1';
                ApplicationArea = all;
            }
            field(Deliveryadd2; rec.Deliveryadd2)
            {
                Caption = 'Delivery Address 2';
                ApplicationArea = all;
            }
            field("Disable for Lot Fact Box"; Rec."Skip for Lot FB")
            {
                ApplicationArea = all;
                Caption = 'Disable for Lot Fact Box';
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