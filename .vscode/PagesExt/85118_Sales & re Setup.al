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
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}