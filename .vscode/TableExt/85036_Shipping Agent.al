tableextension 85036 "SC Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(85149; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released;
        }
        field(85150; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "In",Out;
        }
        field(85151; "ePOD ID"; Integer)
        {

        }
        field(85152; "Depot Synced"; Boolean)
        {

        }
        field(85153; "ePOD Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Active,Inactive;
        }
        field(85154; "Podfather Depot"; Boolean)
        {

        }


    }

    var
        myInt: Integer;
}