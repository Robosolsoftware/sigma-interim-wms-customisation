pageextension 70146 "SC Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Shipper Qty"; Rec."Shipper Qty")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Inventory; Rec.Inventory)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Total Inventory';
            }
            field("Variant Code mandatory"; Rec."Variant Code mandatory")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(Allocated; Rec.Allocated)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Total requested quantity on Sales order';
            }
            field("Free Quantity"; G_FreeQuantity)
            {
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                ToolTip = 'Free Quantity = Inventory - Allocated';
            }
            field("Min Sell Price"; Rec."Min Sell Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Last Price"; Rec."Last Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        G_FreeQuantity: Decimal;

    trigger OnAfterGetRecord()
    begin
        Clear(G_FreeQuantity);
        Rec.CalcFields(Inventory, Allocated);
        G_FreeQuantity := Rec.Inventory - Rec.Allocated;
    end;
}