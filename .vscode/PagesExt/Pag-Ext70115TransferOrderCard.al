pageextension 70115 TransferOrderCardExt extends "Transfer Order"
{
    layout
    {
        addfirst(factboxes)
        {
            part("Lot-Number-by-Item"; "Lot-Number-by-Item")
            {
                SubPageLink = "Item No." = field("Item No.");
                ApplicationArea = all;
                Provider = TransferLines;
            }


        }
        addlast(General)
        {
            field("Requested By"; rec."Requested By")
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable;
            }
            field("Shipped By"; rec."Shipped By")
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable;
            }
            field("Time of Shipment"; rec."Time of Shipment")
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable;
            }
            field("Receipted By"; rec."Receipted By")
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable2;
            }

            field("Time of Receipt"; rec."Time of Receipt")
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable2;
            }
            field("Vehicle Reg No."; rec."Vehicle Reg No.")
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable;
            }
            field("Pallet ID"; rec."Pallet ID")
            {
                ApplicationArea = all;
                Caption = 'No. of Pallets';
                //Visible = false;
                Editable = iseditable;
            }
            field(Comments; rec.Comments)
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable;
            }
            field("Seal No."; rec."Seal No.")
            {
                ApplicationArea = all;
                //Visible = false;
                Editable = iseditable;
            }
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
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }

        moveafter("Receipted By"; "Receipt Date")
        moveafter("Shipped By"; "Shipment Date")

        addafter("Shipping Advice")
        {


        }
        modify(Control1900383207)
        {
            Visible = true;

        }
        // modify("Receipt Date")
        // {
        //     Editable = true;
        // }
        // modify("Shipment Date")
        // {
        //     Editable = true;
        // }

    }
    actions
    {
        modify("Re&lease")
        {
            trigger OnBeforeAction()
            var
                L_TransferLine: Record "Transfer Line";
            begin
                L_TransferLine.Reset();
                L_TransferLine.SetRange("Document No.", Rec."No.");
                if L_TransferLine.FindSet() then
                    repeat
                        L_TransferLine.TestField("Transfer-from Bin Code");
                    until L_TransferLine.Next() = 0;

            end;
        }
        modify("Create Whse. S&hipment")
        {
            trigger OnBeforeAction()
            var
                L_TransferLine: Record "Transfer Line";
            begin
                L_TransferLine.Reset();
                L_TransferLine.SetRange("Document No.", Rec."No.");
                if L_TransferLine.FindSet() then
                    repeat
                        L_TransferLine.TestField("Transfer-from Bin Code");
                    until L_TransferLine.Next() = 0;

            end;
        }
    }
    trigger OnOpenPage()
    var
        PostedTransferShip: Record "Transfer Shipment Header";
        PostedTransferRcp: Record "Transfer Receipt Header";
    begin

        PostedTransferShip.Reset();
        PostedTransferShip.SetRange("Transfer Order No.", rec."No.");
        if PostedTransferShip.FindFirst() then begin
            iseditable := false;
        end
        else begin
            iseditable := true;
        end;

        PostedTransferRcp.Reset();
        PostedTransferRcp.SetRange("Transfer Order No.", rec."No.");
        if PostedTransferRcp.FindFirst() then begin
            iseditable2 := false;
        end
        else begin
            iseditable2 := true;
        end;

    end;


    var
        iseditable: Boolean;

        iseditable2: Boolean;

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