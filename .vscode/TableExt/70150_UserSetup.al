tableextension 70150 UserSetupExt extends "User Setup"
{
    fields
    {
        field(50003; "Edit Vendor Bank Accounts"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Edit Master Data"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Min Sell Price"; Boolean)
        {
            DataClassification = ToBeClassified;
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