pageextension 85055 "SC Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Inv. Pick No."; Rec."Inv. Pick No.")
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