pageextension 85041 "SC Vendor List" extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
            {
                ApplicationArea = ALl;
                Editable = false;
            }
        }
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
        modify("Bank Accounts")
        {
            Visible = USEditable;
        }
    }
    trigger OnOpenPage()
    var
        usersetup: Record "User Setup";
    begin
        usersetup.Reset();
        usersetup.SetRange("User ID", UserId);
        usersetup.SetRange("Edit Vendor Bank Accounts", true);
        if usersetup.FindFirst() then begin
            USEditable := true;
        end else
            USEditable := false;

    end;

    var
        USEditable: Boolean;
}