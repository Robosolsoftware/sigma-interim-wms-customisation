pageextension 85123 "SC Posted Purch Inv Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here  
        addafter(Quantity)
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                Editable = false;
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