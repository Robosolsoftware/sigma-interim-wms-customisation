tableextension 85004 ShippingAgentServices extends "Shipping Agent Services"
{
    fields
    {
        field(85000; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released;
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}