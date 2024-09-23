table 85006 "Knapp Replenishment"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Item No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Variant Code"; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Location Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Variant Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(8; "Inventory KNAPP"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Variant Code", "Location Code")
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