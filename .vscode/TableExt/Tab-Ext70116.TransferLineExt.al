tableextension 70116 TransferLineExt extends "Transfer Line"
{
    fields
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                L_Item: Record Item;
            begin
                L_Item.Reset();
                L_Item.SetRange("No.", rec."Item No.");
                if L_Item.FindFirst() then begin
                    rec."Pack Size" := L_Item."Pack Size";
                    rec.Brand := L_Item.Brand;
                    Rec."Warehouse Class Code" := L_Item."Warehouse Class Code";
                end;
            end;
        }
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
    }


}
