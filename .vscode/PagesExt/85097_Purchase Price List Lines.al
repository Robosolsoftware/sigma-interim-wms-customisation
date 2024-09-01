pageextension 85097 "SC Purchase Price List Lines" extends "Purchase Price List Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Variant Code")
        {
            field(ARI; Rec.ARI)
            {
                ApplicationArea = All;
            }
            field("Order Volume"; Rec."Order Volume")
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