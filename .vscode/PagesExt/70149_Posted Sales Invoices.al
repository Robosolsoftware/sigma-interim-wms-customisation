pageextension 70149 "SC Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            field("Send By"; Rec."Send By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Email Sent"; Rec."Email Sent")
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