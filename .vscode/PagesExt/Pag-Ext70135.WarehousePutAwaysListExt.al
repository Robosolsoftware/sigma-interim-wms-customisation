pageextension 70135 WarehousePutAwaysListExt extends "Warehouse Put-aways"
{
    layout
    {
        addafter("No. of Lines")
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