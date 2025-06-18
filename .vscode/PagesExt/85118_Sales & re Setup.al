pageextension 85118 "SC Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Inv./Ship Default Posting Date"; Rec."Inv./Ship Default Posting Date")
            {
                ApplicationArea = All;
                Caption = 'Invoice/Shipment Default Posting Date';
                ToolTip = 'Specifies which date must be used as the default posting date on Posted sales documents. If you select Work Date, the Posting Date field will be populated with the work date at the time of Posting sales document. If you select No Date, the Posting Date field will be populated with the Sales Order date at the time of Posting sales document.';
            }
            field("Due Date Buffer"; Rec."Due Date Buffer")
            {
                ApplicationArea = All;
            }
            field("ePOD Job Nos"; Rec."ePOD Job Nos")
            {
                ApplicationArea = All;
            }
            field("Pick Date Filter"; Rec."Pick Date Filter")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}