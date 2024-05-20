tableextension 85009 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                L_WareEmployee: Record "Warehouse Employee";
            begin
                if CurrFieldNo = 7 then begin
                    if Rec."Location Code" <> '' then begin
                        L_WareEmployee.Reset();
                        L_WareEmployee.SetRange("User ID", UserId);
                        L_WareEmployee.SetRange("Location Code", Rec."Location Code");
                        L_WareEmployee.SetRange("Allow selection on PO", true);
                        if not L_WareEmployee.FindFirst() then
                            Error('You do not have permission to select location code %1', Rec."Location Code");
                    end;
                end;
            end;
        }

        field(85103; "Pack"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(85102; "Size"; Text[30])
        {
            DataClassification = ToBeClassified;
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
        field(85003; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85006; "Total Physical"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Unit of Measure Code" = FIELD("Unit of Measure Code")));
            Caption = 'Total Physical';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(85007; Physical; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Location Code" = field("Location Code"), "Unit of Measure Code" = FIELD("Unit of Measure Code"), "Variant Code" = field("Variant Code")));
            Caption = 'Physical';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(85132; "Total Allocated on SO"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order), Type = CONST(Item), "No." = FIELD("No."), "Unit of Measure Code" = FIELD("Unit of Measure Code"), "Outstanding Qty. (Base)" = filter(> 0), "Shipment Date" = field("Date Filter")));
            Caption = 'Total Allocated on SO';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(85133; "Allocated on SO"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = CONST(Order), Type = CONST(Item), "No." = field("No."), "Outstanding Quantity" = filter(> 0), "Location Code" = field("Location Code"), "Unit of Measure Code" = FIELD("Unit of Measure Code"), "Variant Code" = field("Variant Code"), "Shipment Date" = field("Date Filter")));
            DecimalPlaces = 0 : 5;
            Caption = 'Allocated on SO';
        }

        field(85134; "Qty on PO Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const(Order), Type = const(Item), "Outstanding Quantity" = filter(> 0), "No." = field("No.")));
        }
        field(85135; "Sell-to Customer No."; Code[20])
        {

        }
        field(85136; "Sell-to Customer Name"; Text[100])
        {

        }
        field(85137; "Net Unit Cost"; Decimal)
        {

        }
        field(85138; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                //Update Net Unit Cose++
                if Rec."Line Discount %" <> 0 then begin
                    Rec."Net Unit Cost" := Rec."Direct Unit Cost" - (Rec."Direct Unit Cost" * Rec."Line Discount %" / 100);
                end else
                    Rec."Net Unit Cost" := Rec."Direct Unit Cost";
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                L_ItemUnitofMeasure: Record "Item Unit of Measure";
                Recitem: Record Item;
                L_PurchaseHeader: Record "Purchase Header";
            begin
                if Rec.Type = Rec.Type::Item then begin
                    //Check Master Approved++
                    Recitem.Reset();
                    Recitem.SetRange("No.", Rec."No.");
                    if Recitem.FindFirst() then begin
                        Recitem.TestField("QAU Approved");
                        Recitem.TestField(Status, Recitem.Status::Released);

                        //Ignore this validation at the time Uploading PO from Template++
                        if CurrFieldNo = 6 then begin
                            if Recitem."Vendor No." <> '' then
                                if Recitem."Vendor No." <> Rec."Buy-from Vendor No." then
                                    Message('This is not your default Supplier');
                        end;
                    end;

                    //Update Fields from Item Unit of Measure++
                    L_ItemUnitofMeasure.Reset();
                    L_ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
                    L_ItemUnitofMeasure.SetRange(Code, Rec."Unit of Measure Code");
                    if L_ItemUnitofMeasure.FindFirst() then begin
                        Rec."Shipper Qty." := L_ItemUnitofMeasure."Shipper Qty.";
                        Rec."Outer Qty." := L_ItemUnitofMeasure."Outer Qty.";
                        Rec."Pallet Qty." := L_ItemUnitofMeasure."Pallet Qty.";
                    end;

                    //Update Fields from Item++
                    Recitem.Reset();
                    Recitem.SetRange("No.", Rec."No.");
                    if Recitem.FindFirst() then begin
                        Rec.Validate("Warehouse Class Code", Recitem."Warehouse Class Code");
                        Rec.Validate("Pack Size", Recitem."Pack Size");
                        Rec.Validate(Brand, Recitem.Brand);
                    end;

                    //Update Net Unit Cose++
                    if Rec."Line Discount %" <> 0 then begin
                        Rec."Net Unit Cost" := Rec."Direct Unit Cost" - (Rec."Direct Unit Cost" * Rec."Line Discount %" / 100);
                    end else
                        Rec."Net Unit Cost" := Rec."Direct Unit Cost";
                end;
            end;
        }

    }
}
