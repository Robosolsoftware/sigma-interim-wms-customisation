pageextension 50003 WhsePickCardExt extends "Warehouse Pick"
{
    layout
    {
        addafter("Assignment Time")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                caption = 'Created At';
            }
            field(SystemCreatedBy; G_Functions.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified At';
            }
            field(SystemModifiedBy; G_Functions.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified By';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        G_Functions: Codeunit "SC Events & Subscriber";

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