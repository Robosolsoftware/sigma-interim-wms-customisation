pageextension 70138 "SC Item Units of Measure" extends "Item Units of Measure"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Outer Qty."; Rec."Outer Qty.")
            {
                ApplicationArea = All;
            }
            field("Shipper Qty."; Rec."Shipper Qty.")
            {
                ApplicationArea = All;
            }
            field("Pallet Qty."; Rec."Pallet Qty.")
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