pageextension 70123 LocationExt extends "Location Card"
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
            field("Manual Picking"; Rec."Manual Picking")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    L_Location: Record Location;
                begin
                    L_Location.Reset();
                    L_Location.SetFilter(Code, '<>%1', Rec.Code);
                    L_Location.SetRange("Manual Picking", true);
                    if L_Location.FindFirst() then
                        Error('Manual Picking Location Should not be more than one');

                end;

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