tableextension 85037 "SC Warehouse Class" extends "Warehouse Class"
{
    fields
    {
        field(85155; "CD"; Boolean)
        {
            Caption = 'SF';
            trigger OnValidate()
            begin
                if Rec.CD = true then begin
                    rec.TestField(Fridge, false);
                    rec.TestField(Specials, false);
                end;
            end;
        }
        field(85156; Fridge; Boolean)
        {
            trigger OnValidate()
            begin
                if Rec.Fridge = true then begin
                    rec.TestField(CD, false);
                    rec.TestField(Specials, false);
                end;
            end;
        }
        field(85157; "Quota Restriction"; Boolean)
        {

        }
        field(85158; Specials; Boolean)
        {
            trigger OnValidate()
            begin
                if Rec.Specials = true then begin
                    rec.TestField(CD, false);
                    rec.TestField(Fridge, false);
                end;
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