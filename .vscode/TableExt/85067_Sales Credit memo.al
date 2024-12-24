tableextension 85067 "SC Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        // Add changes to table fields here
        field(85173; "Email Sent"; Boolean)
        {

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
        sales: Record "Sales Header";
}