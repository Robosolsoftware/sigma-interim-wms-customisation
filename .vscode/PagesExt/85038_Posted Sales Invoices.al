pageextension 85038 "SC Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("ePOD Sync"; Rec."ePOD Sync")
            {
                ApplicationArea = All;
            }
            field("No of Boxes"; Rec."No of Boxes")
            {
                ApplicationArea = All;
                Visible = false;
            }
            // field("ePOD Status"; Rec."ePOD Status")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
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