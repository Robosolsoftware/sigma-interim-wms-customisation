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
                    L_Item.CalcFields("Parent Category");
                    Rec.Validate("Item Description", L_Item.Description);
                    // Rec.Validate("Top Category", L_Item."Top Category");
                    // Rec.Validate("Parent Category", L_Item."Parent Category");
                    // Rec.Validate("Warehouse Class Code", L_Item."Warehouse Class Code");
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
        //SBB-670+++
        // field(9; "Top Category"; Boolean)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = lookup(Item."Top Category" where("No." = field("Item No.")));

        // }
        field(9; "Top Category"; Option)
        {
            OptionMembers = " ",Core,Focus,Standard;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Top Category" where("No." = field("Item No.")));
        }
        //SBB-670+++
        field(10; "Parent Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category"
                where(Code = field("Child Category")));
        }
        field(11; "Warehouse Class Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Warehouse Class Code" where("No." = field("Item No.")));
        }
        field(7; "Item Category Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Category Code"
                where("No." = field("Item No.")));

        }

        field(8; "Child Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category"
                where(Code = field("Item Category Code")));
            Editable = false;
        }
        //Field ID 12 used in KNAPP extension+++
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