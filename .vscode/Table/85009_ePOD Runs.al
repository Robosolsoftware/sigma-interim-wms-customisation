table 85009 "ePOD Runs"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Run ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                if Rec."Agent Code" <> xRec."Agent Code" then
                    Validate("Agent Service Code", '');
            end;
        }
        field(3; "Agent Service Code"; Code[10])
        {
            Caption = 'Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Agent Code"));
        }
        field(4; "Location Code"; Code[10])
        {

        }
        field(5; "Depot ID"; Integer)
        {

        }
        field(6; Date; Date)
        {
            Caption = 'Shipment Date';
        }
    }

    keys
    {
        key(Key1; "Run ID", "Agent Service Code")
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