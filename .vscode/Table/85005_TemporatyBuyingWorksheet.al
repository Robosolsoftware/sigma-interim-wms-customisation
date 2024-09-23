table 85005 "Buying Worksheet"
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

        field(4; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Variant Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Qty. On SO"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Qty On PO"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Inventory KNAPP"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Inventory Quarantine"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Inventory Depot1"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Inventory IP3"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Inventory IP4"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Inventory OPD"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Inventory PSP"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Inventory SIGCARE"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Inventory SS"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Inventory WHO"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Inventory Out. Log."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Inventory Own. Log"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Item Category Code"; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Sub Category Code"; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Today Sales Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
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