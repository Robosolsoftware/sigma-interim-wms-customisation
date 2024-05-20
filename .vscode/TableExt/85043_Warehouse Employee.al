tableextension 85043 "SC Warehouse Employee" extends "Warehouse Employee"
{
    fields
    {
        // Add changes to table fields here
        field(85000; "Allow selection on PO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85001; "Allow selection on SO"; Boolean)
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