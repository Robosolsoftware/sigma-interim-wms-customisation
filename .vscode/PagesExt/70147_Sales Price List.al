pageextension 70147 "SC Sales Price List" extends "Sales Price List"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Special Price Daily"; Rec."Special Price Daily")
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