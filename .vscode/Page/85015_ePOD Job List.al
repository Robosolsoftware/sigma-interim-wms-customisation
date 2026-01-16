page 85015 "ePOD Job List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ePOD Job Header";
    CardPageID = "ePOD Job Card";
    DataCaptionFields = "No.";
    Editable = false;
    RefreshOnActivate = true;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("ePOD ID"; Rec."ePOD ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'ePOD ID for Loading job';
                }
                field("ePOD RunID"; Rec."ePOD RunID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer PO"; Rec."Customer PO")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Synced to ePOD"; Rec."Synced to ePOD")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }

    actions
    {

    }

}