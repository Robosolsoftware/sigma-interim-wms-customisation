tableextension 70148 "SC Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(70149; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released;
        }
        field(70150; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "In",Out;
        }


    }

    var
        myInt: Integer;
}