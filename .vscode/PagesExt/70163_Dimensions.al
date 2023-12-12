pageextension 70163 "SC Dimensions" extends Dimensions
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Sales warning"; Rec."Sales warning")
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