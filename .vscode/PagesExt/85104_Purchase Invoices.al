pageextension 85104 "SC Purchase Invoices" extends "Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here

        modify(AttachedDocuments)
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