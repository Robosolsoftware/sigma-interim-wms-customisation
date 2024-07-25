pageextension 85099 "SC Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify(OrderNo)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}