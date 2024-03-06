pageextension 50016 ItemattributeValueEditorExt extends "Item Attribute Value Editor"
{
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
        L_usersetup: Record "User Setup";
    begin
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data QAU Approved" = true then
                CurrPage.Editable(true)
            else
                CurrPage.Editable(false)
        end else
            CurrPage.Editable(false)
    end;

    var
        myInt: Integer;
}