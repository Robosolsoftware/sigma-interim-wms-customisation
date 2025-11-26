pageextension 85147 "SC Purchase Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        modify(Control15)
        {
            Editable = IsEditablePurchInv;
        }
        modify(Control33)
        {
            Editable = IsEditablePurchInv;
        }
        modify(Control39)
        {
            Editable = IsEditablePurchInv;
        }
        modify(PurchDetailLine)
        {
            Editable = IsEditablePurchInv;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        Editability1();

    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Editability1();
    end;


    procedure Editability1()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);

        if UserSetup."Allow Purch Inv Edit" = true then begin
            IsEditablePurchInv := true;
        end else begin
            IsEditablePurchInv := false;
        end;
    end;

    var
        IsEditablePurchInv: Boolean;
}