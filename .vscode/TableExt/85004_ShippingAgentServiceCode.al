tableextension 85004 ShippingAgentServices extends "Shipping Agent Services"
{
    fields
    {
        field(85000; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released;
        }
        field(85001; "Driver ePOD ID"; Integer)
        {

        }
        field(85002; "Driver Name"; Text[100])
        {

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