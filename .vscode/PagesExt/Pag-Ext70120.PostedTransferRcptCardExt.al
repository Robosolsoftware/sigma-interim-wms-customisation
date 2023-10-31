pageextension 70120 PostedTransfederReceiptCardExt extends "Posted Transfer Receipt"
{
    layout
    {

        addlast(General)
        {
            field("Requested By"; rec."Requested By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Shipped By"; rec."Shipped By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Time of Shipment"; rec."Time of Shipment")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Receipted By"; rec."Receipted By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Time of Receipt"; rec."Time of Receipt")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Vehicle Reg No."; rec."Vehicle Reg No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pallet ID"; rec."Pallet ID")
            {
                ApplicationArea = all;
                Caption = 'No. of Pallets';
                Editable = false;
            }



            field(Comments; rec.Comments)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Seal No."; rec."Seal No.")
            {
                ApplicationArea = all;
                Editable = false;
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