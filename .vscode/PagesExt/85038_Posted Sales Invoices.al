pageextension 85038 "SC Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("ePOD ID"; Rec."ePOD ID")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ePOD RunID"; Rec."ePOD RunID")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ePOD Status"; Rec."ePOD Status")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ePOD Job Consolidated"; Rec."ePOD Job Consolidated")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Location Code")
        {
            field("Inv. Pick No."; Rec."Inv. Pick No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Send By"; Rec."Send By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Email Sent"; Rec."Email Sent")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Shipment Date")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}