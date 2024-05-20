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


    }

    var
        myInt: Integer;
}