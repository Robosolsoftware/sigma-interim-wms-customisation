pageextension 70127 POTransferShpListRBE extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Posting Date")

        {

            field("System CreatedBy"; GetUserName(rec.SystemCreatedBy))
            {
                ApplicationArea = all;

            }
            field("System CreatedAt"; rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                caption = 'System CreatedAt';

            }

        }

        modify(Control1900383207)
        { Visible = true; }

    }


    actions
    {

    }
    procedure GetUserName(UserSecurityId: Code[50]): Text[100]
    var
        Users: Record User;
    begin
        Users.Reset();
        Users.SetRange("User Security ID", UserSecurityId);
        if Users.FindFirst() then
            exit(Users."Full Name");

    end;


    var
        myInt: Integer;
}