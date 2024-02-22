page 70104 "Shipping Agent Restrict Item"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Shipping Agent Restrict Item";
    DelayedInsert = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;

                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
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
            }
        }
        area(Factboxes)
        {

        }
    }

}