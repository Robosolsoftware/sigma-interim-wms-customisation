pageextension 70113 PurcahseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        addafter("Direct Unit Cost")
        {
            field("Net Unit Cost"; Rec."Net Unit Cost")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Unit Price (LCY)")
        {
            Editable = false;
            Visible = true;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                PurchaseEventandFunction: Codeunit "Purchase Event & Function";
            begin
                //Check Bin based on warehouse class code++
                if (Rec.Type = Rec.Type::Item) AND (Rec."No." <> '') then begin
                    PurchaseEventandFunction.CheckWarehouseClassCodePOLinelevel(Rec);
                end;
            end;
        }
        modify("Location Code")
        {
            Visible = false;

            trigger OnAfterValidate()
            var
                L_WareEmployee: Record "Warehouse Employee";
            begin
                if Rec."Location Code" <> '' then begin
                    L_WareEmployee.Reset();
                    L_WareEmployee.SetRange("User ID", UserId);
                    L_WareEmployee.SetRange("Location Code", Rec."Location Code");
                    L_WareEmployee.SetRange("Allow selection on PO", true);
                    if not L_WareEmployee.FindFirst() then
                        Error('You do not have permission to select location code %1', Rec."Location Code");
                end;

            end;
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
            field("Qty on PO Order"; Rec."Qty on PO Order")
            {
                ApplicationArea = All;
                Editable = false;
            }
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
                Caption = 'Total Physical';
            }
            field(Allocated; Rec.Allocated)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Sum of Outstanding Qty on SO across ALL Locations';
                DecimalPlaces = 0 : 5;
                Caption = 'Total Allocated on SO';
            }

            //Moved this code on Ochannel Extension for calculation++
            // field("Free Quantity"; TotalAvailableQty(Rec))
            // {
            //     Caption = 'Total Free';
            //     ApplicationArea = All;
            //     Editable = false;
            //     DecimalPlaces = 0 : 5;
            //     ToolTip = 'Inventory (Total Inventory) - Allocated (Sum of Outstanding Qty on SO)';
            // }
            //Moved this code on Ochannel Extension for calculation++
            field("Physical"; Rec."Saleable Inventory")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Qty available in the selected location';
                DecimalPlaces = 0 : 5;
                Caption = 'Physical';
            }

            field("Allocated on SO"; Rec."Qty on SO(Saleable)")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Sum of Outstanding SO Qty in the selected location';
                Caption = 'Allocated on SO';
                DecimalPlaces = 0 : 5;
            }
            //Moved this code on Ochannel Extension for calculation++
            // field("Free (Saleable)"; TotalAvailableQtyForSaleable(Rec))
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            //     DecimalPlaces = 0 : 5;
            //     ToolTip = 'Saleable Inventory – Sum of Outstanding Qty on SO (Saleable)';
            //     //Caption = 'Total Available Quantity(Saleable)';
            //     Caption = 'Free (Saleable)';
            // }
            //Moved this code on Ochannel Extension for calculation++
        }
    }

    var

    //Moved this code on Ochannel Extension for calculation++
    // local procedure TotalAvailableQty(_Rec: Record "Purchase Line"): Decimal
    // var
    //     L_ILE: Record "Item Ledger Entry";
    // begin
    //     //+++++Formula:- Total Free => "Total Physical - Total SO Allocated - Web Orders Qty"
    //     //Inventory is Total Physical
    //     //Total SO Allocated is Allocated
    //     //Web Orders Qty is Web order Qty------
    //     _Rec.CalcFields(Inventory, Allocated);
    //     if (_Rec.Inventory - _Rec.Allocated) > 0 then
    //         exit(_Rec.Inventory - _Rec.Allocated)
    //     else
    //         exit(0);
    // end;

    // local procedure TotalAvailableQtyForSaleable(_Rec: Record "Purchase Line"): Decimal
    // var
    //     ItemVariant: Record "Item Variant";
    //     _LocationCode: Code[20];
    //     L_ILE: Record "Item Ledger Entry";
    //     SaleableInventory: Decimal;
    //     L_SalesLine: Record "Sales Line";
    //     SaleableQtyOnSO: Decimal;
    //     item: Record Item;
    // begin
    //     //Free (Saleable) => Change the formula to "Physical (Saleable) - Allocated on SO (Saleable) - Web Orders Qty"
    //     _Rec.CalcFields("Qty on SO(Saleable)", "Saleable Inventory");
    //     if _Rec."Saleable Inventory" > 0 then
    //         if (_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)") > 0 then
    //             exit(_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)")
    //         else
    //             exit(0)
    //     else
    //         exit(0);
    // end;
    //Moved this code on Ochannel Extension for calculation--
}
