pageextension 85041 "SC Vendor List" extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("PO Approval required"; Rec."PO Approval required")
            {
                ApplicationArea = All;
                Editable = false;
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