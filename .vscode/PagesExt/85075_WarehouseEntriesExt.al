pageextension 85075 WarehouseEntriesExt extends "Warehouse Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            // field("Transportation No."; Rec."Transportation No.")
            // {
            //     ApplicationArea = all;
            // }
            // field("Receipt Status"; Rec."Receipt Status")
            // {
            //     ApplicationArea = all;
            // }
            field("Saleable Location"; Rec."Saleable Location")
            {
                ApplicationArea = All;
            }
            field(SystemCreatedBy; GetUserName(rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field("System Created At"; rec.SystemCreatedAt)
            {
                ApplicationArea = all;

            }

        }
        modify("Expiration Date")
        {
            Visible = true;
        }

    }

    actions
    {
        // Add changes to page actions here
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
}