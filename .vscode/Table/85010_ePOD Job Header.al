table 85010 "ePOD Job Header"
{
    DataClassification = ToBeClassified;
    Permissions = tabledata 112 = m;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "ePOD RunID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Customer PO"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
            Editable = false;
        }
        field(5; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
            Editable = false;
        }
        field(6; "Shipment Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Consolidated Date & Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Synced to ePOD"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "ePOD ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Depot ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

}