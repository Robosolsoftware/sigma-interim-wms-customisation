pageextension 85071 PurcahseOrderSubformExt extends "Purchase Order Subform"
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
        modify("Unit Volume")
        {
            Visible = true;
        }
        moveafter("Net Unit Cost"; "Unit Volume")


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
            field("Unable to Receive"; Rec."Unable to Receive")
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
            // field("Total Physical"; Rec."Total Physical")
            // {
            //     Editable = false;
            //     ApplicationArea = All;
            //     ToolTip = 'Total Inventory';
            //     DecimalPlaces = 0 : 5;
            //     Caption = 'Total Physical';
            // }
            // field("Total Allocated on SO"; Rec."Total Allocated on SO")
            // {
            //     Editable = false;
            //     ApplicationArea = All;
            //     ToolTip = 'Sum of Outstanding Qty on SO across ALL Locations';
            //     DecimalPlaces = 0 : 5;
            //     Caption = 'Total Allocated on SO';
            // }
            // field(Physical; Rec.Physical)
            // {
            //     Editable = false;
            //     ApplicationArea = All;
            //     ToolTip = 'Qty available in the selected location';
            //     DecimalPlaces = 0 : 5;
            //     Caption = 'Physical';
            // }

            // field("Allocated on SO"; Rec."Allocated on SO")
            // {
            //     Editable = false;
            //     ApplicationArea = All;
            //     ToolTip = 'Sum of Outstanding SO Qty in the selected location';
            //     Caption = 'Allocated on SO';
            //     DecimalPlaces = 0 : 5;
            // }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Date Filter", '>=%1', WorkDate());
    end;

    var
}
