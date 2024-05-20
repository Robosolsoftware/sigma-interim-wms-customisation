tableextension 85032 "SC Item Unit of Measure" extends "Item Unit of Measure"
{
    fields
    {
        // Add changes to table fields here
        field(85129; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85130; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85131; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}