pageextension 85037 "SC Sales Price Lists" extends "Sales Price Lists"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Special Price Daily"; Rec."Special Price Daily")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Daily Promotions';
            }
            field("Master LifeRay"; Rec."Master LifeRay")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Master DC"; Rec."Master DC")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
        tes: Page "Sales Price List";
}