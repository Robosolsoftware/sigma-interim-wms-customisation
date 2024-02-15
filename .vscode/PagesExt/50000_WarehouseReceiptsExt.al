pageextension 50000 WarehouseReceiptsExt extends "Warehouse Receipts"
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