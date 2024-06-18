pageextension 85066 "SC Purchase Quote Subform" extends "Purchase Quote Subform"
{
    layout
    {
        // Add changes to page layout here
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

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Date Filter", '>=%1', WorkDate());
    end;

    var
        myInt: Integer;
}