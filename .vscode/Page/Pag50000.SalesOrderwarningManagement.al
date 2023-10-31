page 50000 "Sales Order warning Mng. Setup"
{
    Caption = 'Sales Order warning Management Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Order warning Mng. Setup";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;

                }
                field("Dimension Value"; Rec."Dimension Value")
                {
                    ApplicationArea = All;
                }
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Caption = 'Attribute';
                    TableRelation = "Item Attribute".Name WHERE(Blocked = CONST(false));
                    ToolTip = 'Specifies the item attribute.';
                }
                field("Attribute Value"; Rec."Attribute Value")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    TableRelation = "Item Attribute Value".Value WHERE("Attribute ID" = FIELD("Attribute ID"), Blocked = CONST(false));
                    ToolTip = 'Specifies the value of the item attribute.';
                }

                field("warning message"; Rec."warning message")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}