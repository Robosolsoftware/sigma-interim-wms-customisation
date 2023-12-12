pageextension 70165 VendorBankAccountCard extends "Vendor Bank Account Card"
{
    //Editable = true;
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    var
        usersetup: Record "User Setup";
    begin
        usersetup.Reset();
        if usersetup.Get(UserId) then begin
            if usersetup."Edit Vendor Bank Accounts" then begin
                CurrPage.Editable := true;
                //Editable := true;
            end else
                CurrPage.Editable := false;
            //Editable := false;
        end;
    end;

    var

}