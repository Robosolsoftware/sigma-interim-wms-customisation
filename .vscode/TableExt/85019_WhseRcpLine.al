tableextension 85019 WHSERcpLineRBE extends "Warehouse Receipt Line"
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
        field(85003; "Return Invoice Line No."; Integer) //Rehan++
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Return Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "Item Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(85007; "Unable to Receive"; Text[100])
        {
            trigger OnValidate()
            var
                L_PurchaseLine: Record "Purchase Line";
            begin
                L_PurchaseLine.Reset();
                L_PurchaseLine.SetRange("Document Type", L_PurchaseLine."Document Type"::Order);
                L_PurchaseLine.SetRange("Document No.", Rec."Source No.");
                L_PurchaseLine.SetRange("Line No.", Rec."Source Line No.");
                if L_PurchaseLine.FindFirst() then begin
                    L_PurchaseLine."Unable to Receive" := Rec."Unable to Receive";
                    L_PurchaseLine.Modify();
                end;
            end;
        }
        field(85006; "Transportation No."; Code[20])
        {

        }
        field(85008; "Receipt Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transportation Receipt Status';
        }
    }

    var
        myInt: Integer;
}