pageextension 85122 "SC Posted Sales Shipment Lines" extends "Posted Sales Shipment Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Order Line No."; Rec."Order Line No.")
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
}