pageextension 85137 PostedSalesInvoiceLinesEXT extends "Posted Sales Invoice Lines"
{
    layout
    {
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
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