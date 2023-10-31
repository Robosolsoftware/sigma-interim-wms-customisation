tableextension 70105 "Ext Lot No. by binBuffer" extends 7351
{
    fields
    {

        field(80098; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(80099; "Qty (Available)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
