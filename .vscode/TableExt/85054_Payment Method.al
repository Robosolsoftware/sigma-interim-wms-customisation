tableextension 85054 "SC Payment Method" extends "Payment Method"
{
    fields
    {
        // Add changes to table fields here
        field(85054; "Fin Option"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","DD Notified","DD Non-Notified";
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