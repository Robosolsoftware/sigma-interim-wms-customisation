table 85000 "Temperature Range"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Temperature Category";

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Min. Temperature"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Max Temperature"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Storage Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Ambient,Fridge;
            OptionCaptionML = ENU = ' ,Ambient,Fridge";ENG=" ,Ambient,Fridge';
        }
        field(5; "Print On Pick Sheet"; Boolean)
        {

        }
        field(6; "Highlight Line on Pick Sheet"; Boolean)
        {

        }
        field(7; "Separate Pick note for storage"; Boolean)
        {

        }
        field(8; "Print On Invoice"; Boolean)
        {
            CaptionML = ENU = 'Print On Invoice;ENG=Print On Invoice';
            Description = '//CAS-05108-W1D8W9';
        }
        field(9; "Print On Shipment"; Boolean)
        {
            CaptionML = ENU = 'Print On Shipment;ENG=Print On Shipment';
            Description = '//CAS-05108-W1D8W9';

        }
        field(10; "Print On Purch. Order"; Boolean)
        {
            CaptionML = ENU = 'Print On Purch. Order;ENG=Print On Purch. Order';
        }
        field(11; Description; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Print On Sales Order"; Boolean)
        {
            Description = '//CAS-05291-N5T3M5';
        }

    }

    keys
    {
        key(PK; Code)
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

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}