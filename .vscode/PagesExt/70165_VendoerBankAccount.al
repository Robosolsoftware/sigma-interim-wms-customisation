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
        usersetup.SetRange("User ID", UserId);
        usersetup.SetRange("Edit Vendor Bank Accounts", true);
        if not usersetup.FindFirst() then
            CurrPage.Editable := false;
    end;
}