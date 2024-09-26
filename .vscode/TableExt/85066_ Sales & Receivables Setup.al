tableextension 85066 "SC Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(85066; "Inv./Ship Default Posting Date"; Enum "Default Posting Date")
        {
            Caption = 'Invoice/Shipment Default Posting Date';
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