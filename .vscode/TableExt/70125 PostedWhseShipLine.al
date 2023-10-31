tableextension 70125 POWHSEShpLineRBE extends "Posted Whse. Shipment Line"
{
    fields
    {
        field(70000; "Pack Size"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70001; Brand; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70002; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
            Editable = false;
        }
    }

    var
        myInt: Integer;
}