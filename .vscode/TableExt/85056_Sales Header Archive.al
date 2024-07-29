tableextension 85056 "SC Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        // Add changes to table fields here
        field(85056; "Sales Order Created By"; Text[100])
        {

        }
        field(85057; "Web Order"; Boolean)
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