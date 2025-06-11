tableextension 85066 "SC Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(85066; "Inv./Ship Default Posting Date"; Enum "Default Posting Date")
        {
            Caption = 'Invoice/Shipment Default Posting Date';
        }
        field(85067; "Due Date Buffer"; DateFormula)
        {

        }
        field(85068; "ePOD Job Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
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