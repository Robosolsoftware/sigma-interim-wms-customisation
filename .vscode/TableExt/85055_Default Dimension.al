tableextension 85055 "SC Default Dimension" extends "Default Dimension"
{
    fields
    {
        // Add changes to table fields here
        field(85055; "Dimension Value Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Dimension Value Code")));
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