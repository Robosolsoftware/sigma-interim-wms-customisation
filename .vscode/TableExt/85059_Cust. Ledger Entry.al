tableextension 85059 "SC Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(85059; "Assigned Credit Controller"; Code[50])
        {

        }
        field(85060; "Closed By Doc. No."; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Document No." where("Closed by Entry No." = field("Closed by Entry No.")));
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