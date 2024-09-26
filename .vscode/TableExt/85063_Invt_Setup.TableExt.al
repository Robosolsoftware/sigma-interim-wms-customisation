tableextension 85063 Invt_Setup extends "Inventory Setup"
{
    fields
    {
        field(59000; "Post Cost to G/L No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(85000; "Knapp Replenishment No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
