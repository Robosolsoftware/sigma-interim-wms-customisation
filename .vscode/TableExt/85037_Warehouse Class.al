tableextension 85037 "SC Warehouse Class" extends "Warehouse Class"
{
    fields
    {
        field(85155; "CD"; Boolean)
        {
            trigger OnValidate()
            begin
                if Rec.CD = true then
                    rec.TestField(Fridge, false);
            end;
        }
        field(85156; Fridge; Boolean)
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