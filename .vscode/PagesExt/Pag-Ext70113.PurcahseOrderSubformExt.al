pageextension 70113 PurcahseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                SCEventsSubscriber: Codeunit "SC Events & Subscriber";
            begin
                if (Rec.Type = Rec.Type::Item) AND (Rec."No." <> '') then begin
                    SCEventsSubscriber.CheckWarehouseClassCodePOLinelevel(Rec);
                end;
            end;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Item Reference No.")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;

        }
        modify("Item Charge Qty. to Handle")
        {
            Visible = false;

        }
        modify("Qty. Assigned")
        {
            Visible = false;

        }
        modify("Over-Receipt Code")
        {
            Visible = false;

        }
        modify("Over-Receipt Quantity")
        {
            Visible = false;
        }
        modify("Variant Code")
        {
            Visible = true;
        }
        moveafter(Description; "Variant Code")

        addafter(Description)
        {
            field("Pack Size"; rec."Pack Size")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Brand; rec.Brand)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Warehouse Class Code"; Rec."Warehouse Class Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter(Quantity)
        {
            field("Shipper Qty."; Rec."Shipper Qty.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Pallet Qty."; Rec."Pallet Qty.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Outer Qty."; Rec."Outer Qty.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
