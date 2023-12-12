tableextension 70148 "SC Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        // Add changes to table fields here
        field(70148; "Restrict CD & Fridge"; Boolean)
        {

        }
        field(70149; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Released;
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