tableextension 70146 "SC Sales Shipment Line" extends "Sales Shipment Line"
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