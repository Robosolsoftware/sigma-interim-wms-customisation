pageextension 85120 "SC Apply Customer Entries" extends "Apply Customer Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
            {
                ApplicationArea = All;
                Editable = true;
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