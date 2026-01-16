table 85011 "ePOD Job Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {

        }
        field(2; "ePOD RunID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line Number"; Integer)
        {

        }
        field(4; "Customer PO"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
            Editable = false;
        }
        field(6; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
            Editable = false;
        }
        field(7; "Shipment Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "BC Invoice Number"; Code[20])
        {

        }
        field(9; Group; Text[20])
        {

        }
        field(10; "Product Code"; Code[20])
        {

        }
        field(11; Description; Text[50])
        {

        }
        field(12; Quantity; Decimal)
        {

        }
        field(13; "Synced to ePOD"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "ePOD ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Consolidated to Loading Job"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line Number")
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