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
        field(70006; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  //"Location Code" = FIELD("Location Code"),
                                                                  "Variant Code" = FIELD("Variant Code"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Code")));
            Caption = 'Total Physical';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70007; "Saleable Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
            "Variant Code" = FIELD("Variant Code"),
            "Saleable Location" = const(true),
            //"Location Code" = field("Location Code"),
            "Unit of Measure Code" = FIELD("Unit of Measure Code")));

            //Caption = 'Saleable Inventory';
            Caption = 'Physical (Saleable)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70132; "Allocated"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No."),
                                                                            //"Location Code" = FIELD("Location Code"),
                                                                            "Variant Code" = FIELD("Variant Code"),
                                                                            "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                            "Outstanding Qty. (Base)" = filter(> 0)));
            //Caption = 'Allocated';
            Caption = 'Total Allocated';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70133; "Qty on SO(Saleable)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = CONST(Order),
            Type = CONST(Item),
            "No." = field("No."),
            "Variant Code" = field("Variant Code"),
            "Outstanding Quantity" = filter(> 0),
            "Saleable Location" = const(true),
            //"Location Code" = field("Location Code"),
            "Unit of Measure Code" = FIELD("Unit of Measure Code")));

            DecimalPlaces = 0 : 5;
            //Caption = 'Qty on Sales Order (Saleable)';
            Caption = 'Allocated (Saleable)';
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                L_ItemUnitofMeasure: Record "Item Unit of Measure";
                Recitem: Record Item;
            begin
                if Rec.Type = Rec.Type::Item then begin
                    Recitem.Reset();
                    Recitem.SetRange("No.", Rec."No.");
                    if Recitem.FindFirst() then begin
                        Recitem.TestField("QAU Approved");
                        Recitem.TestField(Status, Recitem.Status::Released);
                        if Recitem."Vendor No." <> '' then
                            if Recitem."Vendor No." <> Rec."Buy-from Vendor No." then
                                Message('This is not your default Supplier');
                    end;

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
