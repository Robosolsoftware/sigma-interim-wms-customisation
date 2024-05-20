pageextension 85005 InventoryPickCardExt extends "Inventory Pick"
{
    layout
    {
        addafter("External Document No.2")
        {
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = All;
                Editable = false;
                MultiLine = true;
                //Note:- Value comming from Sales header. Check the code in KNAPP extension

            }
        }
        addafter("Shipment Date")
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
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified At';
            }
            field(SystemModifiedBy; GetUserName(Rec.SystemModifiedBy))
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