table 85008 "Shipper/Pallet Data"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            NotBlank = true;
        }

        field(2; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }

        field(3; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Variant Mandatory"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("Item No.")));
        }
    }

    keys
    {
        key(PK; "Item No.", "Variant Code") { Clustered = true; }
    }




    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}