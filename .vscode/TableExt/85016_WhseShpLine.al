tableextension 85016 WHSEShpLineRBE extends "Warehouse Shipment Line"
{
    fields
    {
        field(85000; "Pack Size"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85001; Brand; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
        }
    }

    var
        myInt: Integer;
}