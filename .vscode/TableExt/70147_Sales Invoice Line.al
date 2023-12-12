tableextension 70147 "SC Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
        field(70138; "Last Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70139; "Shipper Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
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