page 85021 "Replenishment Worksheet"
{
    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'Replenishment Worksheet';
    DataCaptionFields = "Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Replenishment Worksheet";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterValidate();
                end;
            }
            repeater(GroupName)
            {
                field(Action; Rec.Action)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the action to be performed on the line. Only Accept action lines can be registered.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item number for which replenishment is planned.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the description of the item.';
                }
                field("Min. Qty."; Rec."Min. Qty.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Minimum quantity of the item that comes from the Replenishment Master.';
                }
                field("Max. Qty."; Rec."Max. Qty.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Maximum quantity of the item that comes from the Replenishment Master.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("System Quantity"; Rec."System Quantity")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Caption = 'Depot1 Quantity';
                    Editable = false;
                    ToolTip = 'Available to take from bincontent';
                }

                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'From Variant';
                }
                field("From Location Code"; Rec."From Location Code")
                {
                    ApplicationArea = All;
                }
                field("Pick Qty"; Rec."Pick Qty")
                {
                    ToolTip = 'Pick Qty for selected Item No., From Variant, and From Location Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Own Log Qty."; Rec."Own Log Qty.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("From Variant Priority"; Rec."From Variant Priority")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Demand Quantity"; Rec."Demand Quantity")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Caption = 'Replenishment Qty.';
                    ToolTip = 'Qty required Calculation: Max Qty - Depot1 Qty - Transfer Line Qty Last 2 days';
                }
                field("Qty to Move"; Rec."Qty to Move")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'System suggestion Qty to Move';
                }
            }
        }
        // area(Factboxes)
        // {

        // }
    }

    actions
    {
    }
    var
        CurrentJnlBatchName: Code[10];
        ItemJnlMgt: Codeunit ItemJnlManagement;
        Text000: Label '%1 journal';
        Text001: Label 'RECURRING';
        Text002: Label 'Recurring Item Journal';
        OldItemNo: Code[20];
        OldCapNo: Code[20];
        OldCapType: Enum "Capacity Type";
        OldProdOrderNo: Code[20];
        OldOperationNo: Code[20];
        Text005: Label 'REC-';
        Text006: Label 'Recurring ';
        OpenFromBatch: Boolean;

    trigger OnOpenPage()
    var
        ClientTypeManagement: Codeunit "Client Type Management";
        ServerSetting: Codeunit "Server Setting";
        JnlSelected: Boolean;
    begin
        if Rec.IsOpenedFromBatch() then begin
            CurrentJnlBatchName := Rec."Batch Name";
            Rec.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;


        TemplateSelection(PAGE::"Item Reclass. Journal", 1, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        Rec.OpenJnl(CurrentJnlBatchName, Rec);
    end;


    local procedure CurrentJnlBatchNameOnAfterValidate()
    begin
        CurrPage.SaveRecord();
        SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    procedure SetName(CurrentJnlBatchName: Code[10]; var _ReplanishmentWorksheet: Record "Replenishment Worksheet")
    begin
        _ReplanishmentWorksheet.FilterGroup := 2;
        _ReplanishmentWorksheet.SetRange("Batch Name", CurrentJnlBatchName);
        _ReplanishmentWorksheet.FilterGroup := 0;
        if _ReplanishmentWorksheet.Find('-') then;
    end;

    procedure LookupName(var CurrentJnlBatchName: Code[10]; var _ReplanishmentWorksheet: Record "Replenishment Worksheet")
    var
        ItemJnlBatch: Record "Item Journal Batch";
        IsHandled: Boolean;
    begin
        Commit();
        ItemJnlBatch."Journal Template Name" := _ReplanishmentWorksheet.GetRangeMax("Template Name");
        ItemJnlBatch.Name := _ReplanishmentWorksheet.GetRangeMax("Batch Name");
        ItemJnlBatch.FilterGroup(2);
        ItemJnlBatch.SetRange("Journal Template Name", ItemJnlBatch."Journal Template Name");
        ItemJnlBatch.FilterGroup(0);
        IsHandled := false;
        if not IsHandled then
            if PAGE.RunModal(0, ItemJnlBatch) = ACTION::LookupOK then begin
                CurrentJnlBatchName := ItemJnlBatch.Name;
                SetName(CurrentJnlBatchName, _ReplanishmentWorksheet);
            end;
    end;

    procedure CheckName(CurrentJnlBatchName: Code[10]; var _ReplanishmentWorksheet: Record "Replenishment Worksheet")
    var
        ItemJnlBatch: Record "Item Journal Batch";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        ItemJnlBatch.Get(_ReplanishmentWorksheet.GetRangeMax("Template Name"), CurrentJnlBatchName);
    end;

    procedure TemplateSelection(PageID: Integer; PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order"; RecurringJnl: Boolean; var _ReplanishmentWorksheet: Record "Replenishment Worksheet"; var JnlSelected: Boolean)
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        JnlSelected := true;

        ItemJnlTemplate.Reset();
        ItemJnlTemplate.SetRange("Page ID", PageID);
        ItemJnlTemplate.SetRange(Recurring, RecurringJnl);
        ItemJnlTemplate.SetRange(Type, PageTemplate);
        case ItemJnlTemplate.Count of
            0:
                begin
                    ItemJnlTemplate.Init();
                    ItemJnlTemplate.Recurring := RecurringJnl;
                    ItemJnlTemplate.Validate(Type, PageTemplate);
                    ItemJnlTemplate.Validate("Page ID");
                    if not RecurringJnl then begin
                        ItemJnlTemplate.Name := Format(ItemJnlTemplate.Type, MaxStrLen(ItemJnlTemplate.Name));
                        ItemJnlTemplate.Description := StrSubstNo(Text000, ItemJnlTemplate.Type);
                    end else
                        if ItemJnlTemplate.Type = ItemJnlTemplate.Type::Item then begin
                            ItemJnlTemplate.Name := Text001;
                            ItemJnlTemplate.Description := Text002;
                        end else begin
                            ItemJnlTemplate.Name :=
                              Text005 + Format(ItemJnlTemplate.Type, MaxStrLen(ItemJnlTemplate.Name) - StrLen(Text005));
                            ItemJnlTemplate.Description := Text006 + StrSubstNo(Text000, ItemJnlTemplate.Type);
                        end;
                    ItemJnlTemplate.Insert();
                    Commit();
                end;
            1:
                ItemJnlTemplate.FindFirst();
            else
                JnlSelected := PAGE.RunModal(0, ItemJnlTemplate) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            _ReplanishmentWorksheet.FilterGroup := 2;
            _ReplanishmentWorksheet.SetRange("Template Name", ItemJnlTemplate.Name);
            _ReplanishmentWorksheet.FilterGroup := 0;
            if OpenFromBatch then begin
                _ReplanishmentWorksheet."Template Name" := '';
                PAGE.Run(ItemJnlTemplate."Page ID", _ReplanishmentWorksheet);
            end;
        end;
    end;
}