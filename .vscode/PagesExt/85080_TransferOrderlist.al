pageextension 85080 TransferOrdListRBE extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
        modify(Control1900383207)
        { Visible = true; }
        addafter("Direct Transfer")
        {
            field("System CreatedAt"; rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                caption = 'Created At';

            }
            field("System CreatedBy"; GetUserName(rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Caption = 'Created By';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    procedure GetUserName(UserSecurityId: Code[50]): Text[100]
    var
        Users: Record User;
    begin
        Users.Reset();
        Users.SetRange("User Security ID", UserSecurityId);
        if Users.FindFirst() then
            exit(Users."Full Name");

    end;
}