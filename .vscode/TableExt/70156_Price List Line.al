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