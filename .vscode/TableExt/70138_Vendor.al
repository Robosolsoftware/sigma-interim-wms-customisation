tableextension 70138 "SC Vendor" extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(70138; "PO Approval required"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Yes,No;
        }
        field(70139; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
    }

    var
        myInt: Integer;
}