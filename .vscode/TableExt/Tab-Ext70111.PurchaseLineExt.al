tableextension 70111 PurchaseLineExt extends "Purchase Line"
{
    fields
    {

        field(80017; "Pack"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            // trigger OnValidate()
            // var
            //     CUPurchaseEvents: Codeunit "Purchase Events";
            // begin
            //     if "VAT %" > 0 then
            //         CUPurchaseEvents.CalculatePORDiscVAT(Rec)
            //     else
            //         CUPurchaseEvents.CalculatePORDisc(Rec);
            // end;
        }
        field(70102; "Size"; Text[30])
        {
            DataClassification = ToBeClassified;
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
        field(70003; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70004; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70005; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                L_ItemUnitofMeasure: Record "Item Unit of Measure";
                Recitem: Record Item;
            begin
                if Rec.Type = Rec.Type::Item then begin
                    L_ItemUnitofMeasure.Reset();
                    L_ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
                    L_ItemUnitofMeasure.SetRange(Code, Rec."Unit of Measure Code");
                    if L_ItemUnitofMeasure.FindFirst() then begin
                        Rec."Shipper Qty." := L_ItemUnitofMeasure."Shipper Qty.";
                        Rec."Outer Qty." := L_ItemUnitofMeasure."Outer Qty.";
                        Rec."Pallet Qty." := L_ItemUnitofMeasure."Pallet Qty.";
                    end;

                    Recitem.Reset();
                    Recitem.SetRange("No.", Rec."No.");
                    if Recitem.FindFirst() then begin
                        Rec.Validate("Warehouse Class Code", Recitem."Warehouse Class Code");
                        Rec.Validate("Pack Size", Recitem."Pack Size");
                        Rec.Validate(Brand, Recitem.Brand);
                    end;


                end;
            end;
        }
    }
}
