tableextension 85049 TransferLineExt extends "Transfer Line"
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
        field(85012; "Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header"."Posting Date" where("No." = field("Document No.")));
        }
        field(85013; "Transfer-from Bin Blocked"; Option)
        {
            OptionCaption = ' ,Inbound,Outbound,All';
            OptionMembers = " ",Inbound,Outbound,All;
            FieldClass = FlowField;
            CalcFormula = lookup("Bin Content"."Block Movement" where("Location Code" = field("Transfer-from Code"), "Bin Code" = field("Transfer-from Bin Code")));
        }
    }


}
