tableextension 70147 "SC Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
        field(70133; "Min Sell Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70138; "Last Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70141; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70142; "Pallet Qty."; Decimal)
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