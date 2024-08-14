page 85010 "Cust. Block Reason Code"
{
    ApplicationArea = Warehouse;
    PageType = List;
    SourceTable = "Cust. Block Reason Code";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies a reason code to attach to the entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies a description of what the code stands for.';
                }
            }
        }
    }
}

