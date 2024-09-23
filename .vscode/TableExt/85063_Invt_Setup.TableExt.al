tableextension 85063 Invt_Setup extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(59000; "Post Cost to G/L No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
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
