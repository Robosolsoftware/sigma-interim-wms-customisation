pageextension 85105 "SC Posted Purchase Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        modify("Attached Documents")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}