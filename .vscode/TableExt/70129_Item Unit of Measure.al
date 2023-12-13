tableextension 70129 "SC Item Unit of Measure" extends "Item Unit of Measure"
{
    fields
    {
        // Add changes to table fields here
        field(70129; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70130; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70131; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}