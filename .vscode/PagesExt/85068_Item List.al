pageextension 85068 "Item Extended List" extends "Item List"
{

    layout
    {
        modify(InventoryField)
        {
            Caption = 'Total Physical';
        }
        addafter(Description)
        {
            field(Status; Rec.Status)
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = all;
            }
            field("Variant Mandatory if Exists"; Rec."Variant Mandatory if Exists")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }

        addbefore("Vendor No.")
        {

            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = All;
            }

        }
        addafter(InventoryField)
        {
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
    actions
    {
        modify(PrintLabel)
        {
            Visible = false;
        }
    }
}