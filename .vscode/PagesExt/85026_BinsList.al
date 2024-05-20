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
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}