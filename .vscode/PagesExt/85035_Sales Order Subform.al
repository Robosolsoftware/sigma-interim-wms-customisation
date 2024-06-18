pageextension 85035 "SC Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                L_WareEmployee: Record "Warehouse Employee";
            begin
                if Rec."Location Code" <> '' then begin
                    L_WareEmployee.Reset();
                    L_WareEmployee.SetRange("User ID", UserId);
                    L_WareEmployee.SetRange("Location Code", Rec."Location Code");
                    L_WareEmployee.SetRange("Allow selection on SO", true);
                    if not L_WareEmployee.FindFirst() then
                        Error('You do not have permission to select location code %1', Rec."Location Code");
                end;

            end;
        }
        addafter(Description)
        {
            field("Warehouse Class Code"; Rec."Warehouse Class Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter(Quantity)
        {
            field("Shipper Qty."; Rec."Shipper Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Outer Qty."; Rec."Outer Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pallet Qty."; Rec."Pallet Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                Editable = false;
                ApplicationArea = All;
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
            //     DecimalPlaces = 0 : 5;
            //     Caption = 'Allocated on SO';
            // }
            field("Variant Code mandatory"; Rec."Variant Code mandatory")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Min Sell Price"; Rec."Min Sell Price")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'If Min Sell is 0, then system will not allow to change the unit price greater than 10%';
            }
            field("Last Price"; Rec."Last Price")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Last sales unit price';
            }
            field(RRP; Rec.RRP)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Parent Category"; Rec."Parent Category")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Min Sell Price")
        {
            field("Special Product"; Rec."Special Product")
            {
                ApplicationArea = all;
                Editable = false;
            }


        }

        modify("Unit Volume")
        {
            Editable = TariffFieldsEditable;
        }


    }


    trigger OnOpenPage()
    begin
        Rec.SetFilter("Date Filter", '>=%1', WorkDate());
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        If Rec."Special Product" then
            TariffFieldsEditable := true
        else
            TariffFieldsEditable := false;


    end;

    var

        TariffFieldsEditable: Boolean;


}