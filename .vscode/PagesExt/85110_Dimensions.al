pageextension 85110 "SC Dimensions" extends Dimensions
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Mandatory For Customer"; Rec."Mandatory For Customer")
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