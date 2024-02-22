tableextension 70148 "SC Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(70149; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Released;
        }


    }

    var
        myInt: Integer;
}