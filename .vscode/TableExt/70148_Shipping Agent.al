tableextension 70148 "SC Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        // Add changes to table fields here
        field(70148; "Restrict CD & Fridge"; Boolean)
        {

        }


    }

    fieldgroups
    {
        addlast(DropDown; "Restrict CD & Fridge")
        {

        }
    }

    var
        myInt: Integer;
}