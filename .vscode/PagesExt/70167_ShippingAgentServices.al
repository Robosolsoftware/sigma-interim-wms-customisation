pageextension 70167 ShippingAgentServices extends "Shipping Agent Services"
{
    layout
    {
        addlast(content)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
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