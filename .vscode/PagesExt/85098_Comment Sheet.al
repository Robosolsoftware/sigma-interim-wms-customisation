pageextension 85098 "SC Comment Sheet" extends "Comment Sheet"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
                ApplicationArea = all;
                Editable = false;
            }
            field(SystemCreatedBy; GetUserName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
                ApplicationArea = all;
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
        tes: Report 1316;

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