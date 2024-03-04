pageextension 50011 PoWareRcptHeaderExt extends "Posted Whse. Receipt"
{
    layout
    {
        addafter(PostedWhseRcptLines)
        {
            group("Transport Details")
            {
                Editable = false;
                group("Purchase Order Details:")
                {
                    field("Purchase Order No."; Rec."Purchase Order No.")
                    {
                        ApplicationArea = all;
                        Caption = 'Purchase Order No.';
                        Editable = false;
                    }
                    field("Purchase Order Date"; Format(Rec."Purchase Order Date"))
                    {
                        ApplicationArea = all;
                        Caption = 'Purchase Order Date';
                        Editable = false;
                    }

                    field("Requested Receipt Date"; Rec."Requested Receipt Date")
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field("Transportation No."; Rec."Transportation No.")
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field("Receipt Status"; Rec."Receipt Status")
                    {
                        ApplicationArea = all;
                    }
                    field("Supplier Name"; Rec."Supplier Name")
                    {
                        ApplicationArea = all;
                        Caption = 'Suplier Name.';
                        Editable = false;
                    }

                    field("Warehouse Class Code"; Rec."Warehouse Class Code")
                    {
                        ApplicationArea = all;
                        Caption = 'Warehouse Class Code.';
                        Editable = false;
                    }
                    field(CD; Rec.CD)
                    {
                        ApplicationArea = all;
                        Editable = false;

                    }
                    field("CD Qty"; Rec."CD Qty")
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field(Locationcode; Rec.Locationcode)
                    {
                        ApplicationArea = all;
                        Caption = 'Location Code.';
                        Editable = false;
                    }
                    field("Item Category Code"; Rec."Item Category Code")
                    {
                        ApplicationArea = all;
                        Caption = 'Item Category Code';
                        Editable = false;
                    }
                    field("No. of Items"; Rec."No. of Items")
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field("Total Order Qty"; Rec."Total Order Qty")
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                }
                group("Booking Details")
                {
                    Editable = false;
                    Visible = false;
                    field(Carrier; Rec.Carrier)
                    {
                        ApplicationArea = all;
                    }
                    field("Requested Delivery Date"; Rec."Requested Delivery Date")
                    {
                        ApplicationArea = all;
                    }
                    field("Expected Delivery Date"; Rec."Expected Delivery Date")
                    {
                        ApplicationArea = all;
                    }
                    field("Expected Delivery Time"; Rec."Expected Delivery Time")
                    {
                        ApplicationArea = all;
                    }
                    field("Booked Pallets"; Rec."Booked Pallets")
                    {
                        ApplicationArea = all;
                    }
                    field(Lifts; Rec.Lifts)
                    {
                        ApplicationArea = all;
                    }
                    field("Loose Boxes"; Rec."Loose Boxes")
                    {
                        ApplicationArea = all;
                    }
                    field("Curtain Side"; Rec."Curtain Side")
                    {
                        ApplicationArea = all;
                    }
                    field(Comments; Rec.Comments)
                    {
                        ApplicationArea = all;
                    }
                }
                group(Status)
                {
                    Editable = false;
                    Visible = false;

                    field("Actual Receipt Date"; Rec."Actual Receipt Date")
                    {
                        ApplicationArea = all;
                    }
                    field("Actual Receipt Time"; Rec."Actual Receipt Time")
                    {
                        ApplicationArea = all;
                    }

                }

            }
            group("User Details:")
            {
                Editable = false;
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
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'Modify At';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(SystemModifiedBy; GetUserName(Rec.SystemModifiedBy))
                {
                    Caption = 'Modify By';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        int: Integer;

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