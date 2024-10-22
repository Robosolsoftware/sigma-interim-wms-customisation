pageextension 85042 "SC Customer List" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field(Type; Rec.Type)
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Bluechip; Rec.Bluechip)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Bluechain';
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
        usersetup.SetRange("Edit Customer Bank Accounts", true);
        if usersetup.FindFirst() then begin
            USEditable := true;
        end else
            USEditable := false;

    end;

    var
        USEditable: Boolean;
}