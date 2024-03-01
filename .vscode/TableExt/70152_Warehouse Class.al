tableextension 70152 "SC Warehouse Class" extends "Warehouse Class"
{
    fields
    {
        // Add changes to table fields here
        /*field(70152; "CD Schedule"; Boolean)
        {

        }
        field(70153; "Fridge"; Boolean)
        {

        }*/
        field(70152; "Restrict CD 2,3"; Boolean)
        {

        }
        field(70153; "Restrict CD 4,5"; Boolean)
        {

        }
        field(70154; "Restrict Fridge"; Boolean)
        {

        }
        field(70155; "CD"; Boolean)
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