table 70101 "Temperature Range"
{
    DataClassification = ToBeClassified;
    LookupPageId = Storage;

    fields
    {
        field(99930; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(99931; "Min. Temperature"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(99932; "Max Temperature"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(99933; "Storage Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Ambient,Fridge;
            OptionCaptionML = ENU = ' ,Ambient,Fridge";ENG=" ,Ambient,Fridge';
        }
        field(99934; "Print On Pick Sheet"; Boolean)
        {

        }
        field(99935; "Highlight Line on Pick Sheet"; Boolean)
        {

        }
        field(99936; "Separate Pick note for storage"; Boolean)
        {

        }
        field(99937; "Print On Invoice"; Boolean)
        {
            CaptionML = ENU = 'Print On Invoice;ENG=Print On Invoice';
            Description = '//CAS-05108-W1D8W9';
        }
        field(99938; "Print On Shipment"; Boolean)
        {
            CaptionML = ENU = 'Print On Shipment;ENG=Print On Shipment';
            Description = '//CAS-05108-W1D8W9';

        }
        field(99939; "Print On Purch. Order"; Boolean)
        {
            CaptionML = ENU = 'Print On Purch. Order;ENG=Print On Purch. Order';
        }
        field(99940; Description; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(99941; "Print On Sales Order"; Boolean)
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