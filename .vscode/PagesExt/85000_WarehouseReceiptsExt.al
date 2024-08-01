pageextension 85000 WarehouseReceiptsExt extends "Warehouse Receipts"
{


    layout
    {
        addafter("No.")
        {
            field("Transportation No."; Rec."Transportation No.")
            {
                ApplicationArea = all;
            }
            field("Receipt Status"; Rec."Receipt Status")
            {
                ApplicationArea = all;
            }
        }
        addafter("No.")
        {
            field("Supplier Name"; Rec."Supplier Name")
            {
                ApplicationArea = all;
            }
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = all;
            }
            field("Purchase Order Date"; Rec."Purchase Order Date")
            {
                ApplicationArea = all;
            }
            field("Requested Receipt Date"; Rec."Requested Receipt Date")
            {
                ApplicationArea = all;
            }
            field("PO Expected Receipt Date"; Rec."PO Expected Receipt Date")
            {
                ApplicationArea = all;
                Visible = false;
            }
            // field("No. of Items"; Rec."No. of Items")
            // {
            //     ApplicationArea = all;
            //     Editable = false;
            // }
            // field("Total Order Qty"; Rec."Total Order Qty")
            // {
            //     ApplicationArea = all;
            //     Editable = false;
            // }
            field("Whs. Receipt No. of Items"; Rec."Whs. Receipt No. of Items")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'No. Of Items';
            }
            field("Whs. Receipt Total Order Qty"; Rec."Whs. Receipt Total Order Qty")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Total Order Qty';
            }
            field(CD; Rec.CD)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'SF';
            }
            field("CD Qty"; Rec."CD Qty")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'SF Qty.';
            }
            field("Source Document"; Rec."Source Document")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Sorting Method")
        {
            Visible = false;
        }

    }



    var
        myInt: Integer;
}