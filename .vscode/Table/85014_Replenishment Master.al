table 85014 "Replenishment Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                L_Item: Record Item;
            begin
                //HardCode Location+++
                Rec.Validate("Location Code", 'Depot1');


                L_Item.Reset();
                L_Item.SetRange("No.", Rec."Item No.");
                if L_Item.FindFirst() then begin
                    Rec.Validate("Item Description", L_Item.Description);
                end;
            end;
        }
        field(2; "Variant Code"; Code[10])
        {
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(3; "Item Description"; Text[100])
        {

        }
        field(4; "Min Depot1 Qty"; Decimal)
        {

        }
        field(5; "Max Depot1 Qty"; Decimal)
        {

        }
        field(6; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
        }
        // field(6; "Daily Priority Exist"; Boolean)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = exist("Item Variant" where("Item No." = field("Item No."), Code = field("Variant Code"), Priority = filter(> 0)));
        // }
        // field(7; "Variant Priority"; Integer)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Item Variant".Priority where("Item No." = field("Item No."), Code = field("Variant Code")));
        // }
    }

    keys
    {
        key(Key1; "Item No.", "Variant Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
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