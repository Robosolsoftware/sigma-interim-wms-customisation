tableextension 70129 "SC Item Unit of Measure" extends "Item Unit of Measure"
{
    fields
    {
        // Add changes to table fields here
        field(70129; "Sales Order multiple"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}