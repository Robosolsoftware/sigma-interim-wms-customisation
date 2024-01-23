pageextension 70171 "SC Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("KNAPP Customer"; Rec."KNAPP Customer")
            {
                ApplicationArea = ALl;
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