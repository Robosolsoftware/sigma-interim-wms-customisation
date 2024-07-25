tableextension 85053 "SC Bank Account" extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(85053; "Serial No."; Text[6])
        {

        }
        field(85054; "Bureau Number"; Text[6])
        {

        }
        field(85055; "Fin Option"; Option)
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