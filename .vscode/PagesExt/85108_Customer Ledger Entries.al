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

        addbefore("Entry No.")
        {
            field("Closed By Doc. No."; Rec."Closed By Doc. No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

    }


    var
        myInt: Integer;
}