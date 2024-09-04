tableextension 85061 "SC Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
        // Add changes to table fields here
        field(85061; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
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