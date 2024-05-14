tableextension 70126 WHSERcpLineRBE extends "Warehouse Receipt Line"
{
    fields
    {
        field(70000; "Pack Size"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; Brand; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
        }
        field(70003; "Return Invoice Line No."; Integer) //Rehan++
        {
            DataClassification = ToBeClassified;
        }
        field(70004; "Return Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70005; "Item Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
    }

    var
        myInt: Integer;
}