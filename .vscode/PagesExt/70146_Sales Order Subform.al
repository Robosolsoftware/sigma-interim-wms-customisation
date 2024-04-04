pageextension 70146 "SC Sales Order Subform" extends "Sales Order Subform"
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
            // field("Total Free"; TotalAvailableQty(rec))
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
                ToolTip = 'Qty available in HD and SH';
                DecimalPlaces = 0 : 5;
                Caption = 'Physical';
            }

            field("Allocated on SO"; Rec."Qty on SO(Saleable)")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Sum of Outstanding SO Qty in HD and SH';
                DecimalPlaces = 0 : 5;
                Caption = 'Allocated on SO';
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
            // field("Back Orders (Saleable)"; Rec."Back Orders (Saleable)")
            // {
            //     Caption = 'Back Orders (Saleable)';
            //     ApplicationArea = All;
            //     Editable = false;
            //     DecimalPlaces = 0 : 5;
            //     ToolTip = 'Unshipped Qty in HD and SH';

            //     trigger OnAssistEdit()
            //     var
            //         L_SalesLine: Record "Sales Line";
            //         Page_SalesLinePage: Page "Sales Lines";
            //     begin
            //         Clear(Page_SalesLinePage);
            //         L_SalesLine.Reset();
            //         L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
            //         L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
            //         L_SalesLine.SetRange("No.", Rec."No.");
            //         L_SalesLine.SetRange("Variant Code", Rec."Variant Code");
            //         L_SalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
            //         L_SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
            //         L_SalesLine.SetRange("Saleable Location", true);
            //         L_SalesLine.SetFilter("Shipment Date", '<%1', Today);
            //         Page_SalesLinePage.SetTableView(L_SalesLine);
            //         Page_SalesLinePage.Run();
            //     end;
            // }
            // field("Total Back Orders"; Rec."Total Back Orders")
            // {
            //     Caption = 'Back Orders (Saleable)';
            //     ApplicationArea = All;
            //     Editable = false;
            //     DecimalPlaces = 0 : 5;
            //     ToolTip = 'Unshipped Qty across ALL Locations';
            //     trigger OnAssistEdit()
            //     var
            //         L_SalesLine: Record "Sales Line";
            //         Page_SalesLinePage: Page "Sales Lines";
            //     begin
            //         Clear(Page_SalesLinePage);
            //         L_SalesLine.Reset();
            //         L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
            //         L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
            //         L_SalesLine.SetRange("No.", Rec."No.");
            //         L_SalesLine.SetRange("Variant Code", Rec."Variant Code");
            //         L_SalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
            //         L_SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
            //         //L_SalesLine.SetRange("Saleable Location", true);
            //         L_SalesLine.SetFilter("Shipment Date", '<%1', Today);
            //         Page_SalesLinePage.SetTableView(L_SalesLine);
            //         Page_SalesLinePage.Run();
            //     end;
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
        }
        addafter("Unit of Measure Code")
        {
            field("Parent Category"; Rec."Parent Category")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    var
        DisUnitPrice: Decimal;


    // trigger OnAfterGetRecord()
    // var
    //     L_SalesLine: Record "Sales Line";
    // begin
    //     L_SalesLine.Reset();
    //     L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
    //     L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
    //     L_SalesLine.SetRange("No.", Rec."No.");
    //     L_SalesLine.SetRange("Variant Code", Rec."Variant Code");
    //     L_SalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
    //     L_SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
    //     L_SalesLine.SetRange("Saleable Location", true);
    //     L_SalesLine.SetFilter("Shipment Date", '<%1', Today);
    //     L_SalesLine.CalcSums("Outstanding Quantity");
    //     Rec."Back Orders (Saleable)" := L_SalesLine."Outstanding Quantity";

    //     L_SalesLine.Reset();
    //     L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
    //     L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
    //     L_SalesLine.SetRange("No.", Rec."No.");
    //     L_SalesLine.SetRange("Variant Code", Rec."Variant Code");
    //     L_SalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
    //     L_SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
    //     L_SalesLine.SetFilter("Shipment Date", '<%1', Today);
    //     L_SalesLine.CalcSums("Outstanding Quantity");
    //     Rec."Total Back Orders" := L_SalesLine."Outstanding Quantity";
    //     Rec.Modify();
    // end;


    //Moved this code on Ochannel Extension for calculation++
    // local procedure TotalAvailableQty(_Rec: Record "Sales Line"): Decimal
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


    // local procedure TotalAvailableQtyForSaleable(_Rec: Record "Sales Line"): Decimal
    // var
    //     _LocationCode: Code[20];
    //     L_ILE: Record "Item Ledger Entry";
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