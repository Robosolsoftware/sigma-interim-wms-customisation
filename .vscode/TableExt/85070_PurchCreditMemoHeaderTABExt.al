tableextension 85070 PurchCreditMemoHeaderExt extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(85000; "Purchase Order No."; Text[100])
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