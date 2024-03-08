tableextension 70156 "SC Price List Line" extends "Price List Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                Rec.TestField("Variant Code", '');
            end;
        }

        field(70156; "Special Price Daily"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Price List Header"."Special Price Daily" where(Code = field("Price List Code")));
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