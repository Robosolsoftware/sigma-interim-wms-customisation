tableextension 70118 TransferShipmentLineExt extends "Transfer Shipment Line"
{
    fields
    {
        field(70000; "Pack Size"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable=false;
        }
        field(70001; Brand; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable=false;
        }
        field(70002; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
            Editable=false;
        }
    }


}
