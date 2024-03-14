tableextension 70152 "SC Warehouse Class" extends "Warehouse Class"
{
    fields
    {
        // field(70152; "Restrict CD 2,3"; Boolean)
        // {

        // }
        // field(70153; "Restrict CD 4,5"; Boolean)
        // {

        // }
        // field(70154; "Restrict Fridge"; Boolean)
        // {

        // }
        field(70155; "CD"; Boolean)
        {
            trigger OnValidate()
            begin
                if Rec.CD = true then
                    rec.TestField(Fridge, false);
            end;
        }
        field(70156; Fridge; Boolean)
        {
            trigger OnValidate()
            begin
                if Rec.Fridge = true then
                    rec.TestField(CD, false);
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