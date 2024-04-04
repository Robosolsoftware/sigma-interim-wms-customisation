tableextension 70161 "SC Warehouse Employee" extends "Warehouse Employee"
{
    fields
    {
        // Add changes to table fields here
        field(70161; "Allow selection on PO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70162; "Allow selection on SO"; Boolean)
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