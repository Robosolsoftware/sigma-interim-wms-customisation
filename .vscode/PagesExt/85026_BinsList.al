pageextension 85026 MyExtension extends Bins
{
    layout
    {
        addafter(Dedicated)
        {
            field("Exclude from Fact box"; Rec."Exclude from Fact box")
            {
                ApplicationArea = all;
                Caption = 'Exclude from Fact box & Qty(Aval.)';
            }
            field("Exclude from free Qty."; Rec."Exclude from free Qty.")
            {
                ApplicationArea = all;
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