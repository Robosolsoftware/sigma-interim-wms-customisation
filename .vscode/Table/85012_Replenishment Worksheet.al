table 85012 "Replenishment Worksheet"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(3; Description; Text[100])
        {
            Editable = false;
        }
        field(4; "Unit of Measure Code"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            Editable = false;
        }
        field(5; "Variant Code"; Code[10])
        {
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."), Priority = filter(> 0));
            Caption = 'From Variant';
        }
        field(6; "System Quantity"; Decimal)
        {
            Caption = 'Depot1 Quantity';
            Editable = false;
        }
        field(7; "Available Qty"; Decimal)
        {

        }
        field(8; "Demand Quantity"; Decimal)
        {
            Caption = 'Replenishment Qty.';
        }
        field(9; "Qty to Move"; Decimal)
        {

        }
        field(10; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(11; "Bin Code"; Code[20])
        {
            TableRelation = Bin where("Location Code" = field("Location Code"));
        }
        field(12; "Max. Qty."; Decimal)
        {

        }
        field(13; "From Location Code"; Code[20])
        {
            TableRelation = Location where("Saleable Location" = const(false));
        }
        field(14; "From Bin Code"; Code[20])
        {
            TableRelation = Bin where("Location Code" = field("From Location Code"));
        }
        field(15; "Posting Date"; Date)
        {

        }
        field(16; "Template Name"; Code[10])
        {
            Caption = 'Template Name';
            TableRelation = "Item Journal Template";
        }
        field(17; "Batch Name"; Code[10])
        {
            Caption = 'Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Template Name"));
        }
        field(18; "Min. Qty."; Decimal)
        {

        }
        field(19; "Action"; Option)
        {
            Caption = 'Action';
            OptionMembers = " ","Accept","Cancel";
            Editable = true;
        }
        field(20; "Top Category"; Boolean)
        {

        }
        field(21; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(22; "Pick Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Activity Line"."Qty. Outstanding (Base)" where("Location Code" = field("From Location Code"), "Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Action Type" = const(Take), "Assemble to Order" = const(false)));
        }
        field(23; "Own Log Qty."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Location Code" = filter('OWN LOG.')));
        }
        field(24; "From Variant Priority"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Variant".Priority where("Item No." = field("Item No."), Code = field("Variant Code")));
        }
    }

    keys
    {
        key(Key1; "Template Name", "Batch Name", "Line No.")
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
        Text003: Label 'DEFAULT';
        Text004: Label 'Default Journal';

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

    procedure IsOpenedFromBatch(): Boolean
    var
        ItemJournalBatch: Record "Item Journal Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GetFilter("Batch Name");
        if BatchFilter <> '' then begin
            TemplateFilter := GetFilter("Template Name");
            if TemplateFilter <> '' then
                ItemJournalBatch.SetFilter("Journal Template Name", TemplateFilter);
            ItemJournalBatch.SetFilter(Name, BatchFilter);
            ItemJournalBatch.FindFirst();
        end;

        exit((("Batch Name" <> '') and ("Template Name" = '')) or (BatchFilter <> ''));
    end;

    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var _ReplanishmentWorksheet: Record "Replenishment Worksheet")
    begin
        CheckTemplateName(_ReplanishmentWorksheet.GetRangeMax("Template Name"), CurrentJnlBatchName);
        _ReplanishmentWorksheet.FilterGroup := 2;
        _ReplanishmentWorksheet.SetRange("Batch Name", CurrentJnlBatchName);
        _ReplanishmentWorksheet.FilterGroup := 0;
    end;

    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not ItemJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not ItemJnlBatch.FindFirst() then begin
                ItemJnlBatch.Init();
                ItemJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                ItemJnlBatch.SetupNewBatch();
                ItemJnlBatch.Name := Text003;
                ItemJnlBatch.Description := Text004;
                ItemJnlBatch.Insert(true);
                Commit();
            end;
            CurrentJnlBatchName := ItemJnlBatch.Name
        end;
    end;

}