pageextension 70116 PostedTransferShipmentCard extends "Posted Transfer Shipment"
{
    layout
    {

        addafter("Shipment Date")
        {
            field("Time of Shipment"; rec."Time of Shipment")
            {
                ApplicationArea = all;
            }
            field("Time of Receipt"; rec."Time of Receipt")
            {
                ApplicationArea = all;
            }
            field("Vehicle Reg No."; rec."Vehicle Reg No.")
            {
                ApplicationArea = all;
            }
            field("Pallet ID"; rec."Pallet ID")
            {
                ApplicationArea = all;
                Caption = 'No. of Pallets';
            }
            field("Shipped By"; rec."Shipped By")
            {
                ApplicationArea = all;
            }
            field("Receipted By"; rec."Receipted By")
            {
                ApplicationArea = all;
            }
            field("Requested By"; rec."Requested By")
            {
                ApplicationArea = all;
            }
            field(Comments; rec.Comments)
            {
                ApplicationArea = all;
            }
            field("Seal No."; rec."Seal No.")
            {
                ApplicationArea = all;
            }

        }
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
        {
            Visible = true;
        }
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