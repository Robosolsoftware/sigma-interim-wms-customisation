page 85017 "ePOD Job Card"
{
    SourceTable = "ePOD Job Header";
    PageType = Document;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                field("Consolidated Date & Time"; Rec."Consolidated Date & Time")
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
            part(JobLines; "ePOD Job Line")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Enabled = false;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    var
        myInt: Integer;
}