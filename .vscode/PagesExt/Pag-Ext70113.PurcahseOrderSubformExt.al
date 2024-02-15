pageextension 70113 PurcahseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        modify("Unit Price (LCY)")
        {
            Editable = true;
            Visible = true;
        }
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
            field(Inventory; Rec.Inventory)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Total Inventory';
                DecimalPlaces = 0 : 5;
            }
            field("Saleable Inventory"; Rec."Saleable Inventory")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Qty available in HD and SH';
                DecimalPlaces = 0 : 5;
            }
            field(Allocated; Rec.Allocated)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Sum of Outstanding Qty on SO';
                DecimalPlaces = 0 : 5;
            }
            field("Free Quantity"; G_FreeQuantity)
            {
                Caption = 'Total Free';
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                ToolTip = 'Inventory (Total Inventory) - Allocated (Sum of Outstanding Qty on SO)';
            }
            field("Qty on SO(Saleable)"; Rec."Qty on SO(Saleable)")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Sum of Outstanding Qty in HD and SH';
                DecimalPlaces = 0 : 5;
            }
            field("Total Available Quantity"; TotalAvailableQty(Rec))
            {
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                ToolTip = 'Saleable Inventory – Sum of Outstanding Qty on SO (Saleable)';
                //Caption = 'Total Available Quantity(Saleable)';
                Caption = 'Free (Saleable)';
            }
        }
    }

    var
        G_FreeQuantity: Decimal;


    trigger OnAfterGetRecord()
    begin
        Clear(G_FreeQuantity);
        Rec.CalcFields(Inventory, Allocated);
        G_FreeQuantity := Rec.Inventory - Rec.Allocated;
    end;

    local procedure TotalAvailableQty(_Rec: Record "Purchase Line"): Decimal
    var
        ItemVariant: Record "Item Variant";
        _LocationCode: Code[20];
        L_ILE: Record "Item Ledger Entry";
        SaleableInventory: Decimal;
        L_SalesLine: Record "Sales Line";
        SaleableQtyOnSO: Decimal;
        item: Record Item;
    begin
        _Rec.CalcFields("Qty on SO(Saleable)", "Saleable Inventory");
        if _Rec."Saleable Inventory" > 0 then
            if (_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)") > 0 then
                exit(_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)")
            else
                exit(0)
        else
            exit(0);
    end;
}
