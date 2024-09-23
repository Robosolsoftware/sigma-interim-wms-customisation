tableextension 85064 GenBatch extends "Gen. Journal Batch"
{
    fields
    {
        // Add changes to table fields here
        field(59000; "Direct Debit Batch"; Boolean)
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
