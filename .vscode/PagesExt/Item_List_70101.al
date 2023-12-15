pageextension 70101 "Item Extended List" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(Status; Rec.Status)
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Variant Mandatory if Exists"; Rec."Variant Mandatory if Exists")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addfirst(factboxes)
        {

            part("Lot-Number-by-Item"; "Lot-Number-by-Item")
            {
                SubPageLink = "Item No." = field("No.");
                ApplicationArea = all;
            }

        }


        addbefore("Vendor No.")
        {

            field("Pallet Quantity"; Rec."Pallet Quantity")
            {
                ApplicationArea = all;
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = All;
            }

        }
        addafter(InventoryField)
        {
            field("Net Inventory"; Rec."Net Inventory")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }

        }
        addafter(Description)
        {
            field(Brand; Rec.Brand)
            {
                ApplicationArea = all;
            }
            field("Pack Size"; Rec."Pack Size")
            {
                ApplicationArea = all;
            }
            field("Warehouse Class Code"; Rec."Warehouse Class Code")
            {
                ApplicationArea = all;
            }

        }

    }
}