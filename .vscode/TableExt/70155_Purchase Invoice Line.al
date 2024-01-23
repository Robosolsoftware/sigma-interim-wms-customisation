tableextension 70155 "SC Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        // Add changes to table fields here
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
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}