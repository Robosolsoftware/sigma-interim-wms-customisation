page 85022 "Replenishment Master List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Replenishment Master";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;

                }
                field("Top Category"; Rec."Top Category")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Parent Category"; Rec."Parent Category")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Warehouse Class Code"; Rec."Warehouse Class Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Min Depot1 Qty"; Rec."Min Depot1 Qty")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
                field("Max Depot1 Qty"; Rec."Max Depot1 Qty")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
            }
        }
    }
}