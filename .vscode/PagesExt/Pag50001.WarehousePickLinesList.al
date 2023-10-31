page 50001 "Warehouse Pick Lines List"
{
    ApplicationArea = All;
    Caption = 'Warehouse Pick Lines List';
    PageType = List;
    SourceTable = "Warehouse Activity Line";
    SourceTableView = where("Activity Type" = filter(Pick));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Action Type"; Rec."Action Type")
                {
                    ToolTip = 'Specifies the action type for the warehouse activity line.';
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the item number of the item to be handled, such as picked or put away.';
                    ApplicationArea = all;
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item on the line.';
                    ApplicationArea = all;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    ApplicationArea = all;
                }
                field("Destination No."; Rec."Destination No.")
                {
                    ToolTip = 'Specifies the number or code of the customer, vendor or location related to the activity line.';
                    ApplicationArea = all;
                }
                field("Destination Type"; Rec."Destination Type")
                {
                    ToolTip = 'Specifies information about the type of destination, such as customer or vendor, associated with the warehouse activity line.';
                    ApplicationArea = all;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the date when the warehouse activity must be completed.';
                    ApplicationArea = all;
                }

                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the number of the warehouse activity line.';
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the code for the location where the activity occurs.';
                    ApplicationArea = all;
                }
                field("Qty. Handled"; Rec."Qty. Handled")
                {
                    ToolTip = 'Specifies the number of items on the line that have been handled in this warehouse activity.';
                    ApplicationArea = all;
                }
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ToolTip = 'Specifies the number of items that have not yet been handled for this warehouse activity line.';
                    ApplicationArea = all;
                }
                field("Qty. to Handle"; Rec."Qty. to Handle")
                {
                    ToolTip = 'Specifies how many units to handle in this warehouse activity.';
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity of the item to be handled, such as received, put-away, or assigned.';
                    ApplicationArea = all;
                }
                field("Source Document"; Rec."Source Document")
                {
                    ToolTip = 'Specifies the type of document that the line relates to.';
                    ApplicationArea = all;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
                    ApplicationArea = all;
                }


            }
        }
    }
}
