pageextension 85148 "SC Posted Transfer Shipments" extends "Posted Transfer Shipments"
{
    layout
    {
        // Add changes to page layout here
        addafter("Transfer Order No.")
        {
            field("Transfer Order Printed"; Rec."Transfer Order Printed")
            {
                Caption = 'Transfer Order Printed';
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