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
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}