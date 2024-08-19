pageextension 85108 "SC Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Customer Name")
        {
            field("Assigned Credit Controller"; Rec."Assigned Credit Controller")
            {
                ApplicationArea = ALl;
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