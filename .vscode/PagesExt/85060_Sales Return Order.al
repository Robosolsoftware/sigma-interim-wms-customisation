pageextension 85060 "SC Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field(Rejection; Rec.Rejection)
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipping Agent Service Code")
        {
            field("Weekend Shipping Agent Code"; Rec."Weekend Shipping Agent Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Weekend Ship. Agnt. Serv. Code"; Rec."Weekend Ship. Agnt. Serv. Code")
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
        tes: Page "Posted Sales Document Lines";
}