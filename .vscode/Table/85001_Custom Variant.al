table 85001 "Custom Variant"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; code[20])
        {

        }
        field(2; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Description"; Text[100])
        {

        }
    }

    keys
    {
        key(Key1; "Item No.", Code)
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