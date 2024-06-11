tableextension 85035 "SC Item Variant" extends "Item Variant"
{
    fields
    {
        // Add changes to table fields here
        field(85140; Priority; Integer)
        {
            DataClassification = ToBeClassified;
            //GHST Customization++
            trigger OnValidate()
            var
                L_ItemVariant: Record "Item Variant";
            begin
                //if Rec.Priority <> 0 then
                // if TotalAvailableQtyForSaleable(Rec) <= 0 then
                //     Error('Free Quantity should be greater than 0');


                if Rec.Priority > 0 then begin
                    L_ItemVariant.Reset();
                    L_ItemVariant.SetRange("Item No.", Rec."Item No.");
                    L_ItemVariant.SetRange(Priority, Rec.Priority);
                    if L_ItemVariant.FindFirst() then
                        Error('Priority %1 is already defined', Rec.Priority);
                end;

            end;
        }
        field(85141; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD(Code)));
            Caption = 'Total Physical';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            //GHST Customization++
        }
        field(85142; "Qty on SO(Saleable)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = CONST(Order), Type = CONST(Item), "No." = field("Item No."), "Variant Code" = field(Code), "Outstanding Quantity" = filter(> 0), "Saleable Location" = const(true), "Location Code" = field("Location Filter")));
            DecimalPlaces = 0 : 5;
            Caption = 'Allocated on SO';
            //GHST Customization++
        }
        field(85143; Quantity; Decimal)
        {
            //This is temp field and updating at the time of Assign variant code on Sales order++
            //Dont Use this field any other purpose++
        }

        field(85144; "Saleable Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD(Code), "Saleable Location" = const(true), "Location Code" = field("Location Filter")));
            Caption = 'Physical';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            //GHST Customization++
        }
        field(85145; "Location Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Location;
            //GHST Customization++
        }
        field(85146; "Qty on SO"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("No." = field("Item No."), "Variant Code" = field(Code), "Outstanding Quantity" = filter(> 0), "Location Code" = field("Location Filter")));
            DecimalPlaces = 0 : 5;
            Caption = 'Qty on Sales Order';
            //GHST Customization++
        }
        field(85147; "Allocated"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order), Type = CONST(Item), "No." = FIELD("Item No."), "Outstanding Qty. (Base)" = filter(> 0), "Variant Code" = field(Code)));
            Caption = 'Total Allocated on SO';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            //GHST Customization++
        }
    }

    var
        myInt: Integer;

    local procedure TotalAvailableQtyForSaleable(_Rec: Record "Item Variant"): Decimal
    begin
        _Rec.CalcFields("Qty on SO(Saleable)", "Saleable Inventory");
        if _Rec."Saleable Inventory" > 0 then
            if (_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)") > 0 then
                exit(_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)")
            else
                exit(0)
        else
            exit(0);
    end;


}