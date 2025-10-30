tableextension 85073 "SC Cash Flow Worksheet Line" extends "Cash Flow Worksheet Line"
{
    fields
    {
        // Add changes to table fields here
        field(85000; "Posting Date"; Date)
        {

        }
        field(85001; "Vendor Group"; Option)
        {
            OptionMembers = " ","Week 1","Week 2","Week 3","Week 4","Weekly";
        }
        field(85002; "Vendor Name"; Text[100])
        {
        }
        field(85004; "Expected Receipt Date"; Date)
        {

        }
        field(85005; "Cashflow Date (2)"; Date)
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
}