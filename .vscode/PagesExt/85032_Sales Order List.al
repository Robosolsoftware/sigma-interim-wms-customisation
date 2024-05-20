pageextension 85032 "SC Sales Order List" extends "Sales Order List"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        // Add changes to page layout here
        addbefore("Completely Shipped")
        {
            // field("Warehouse Shipment Exist"; Rec."Warehouse Shipment Exist")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
            // field("Pick Registered"; Rec."Pick Registered")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
            field(PartiallyShipped; PartiallyShipped)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Partially Shipped';
            }
        }
    }

    actions
    {
        addafter("&Print")
        {
            action("Delete Shipment Line")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    L_WarehouseshipmentLine: Record "Warehouse Shipment Line";
                begin
                    L_WarehouseshipmentLine.Reset();
                    L_WarehouseshipmentLine.SetFilter("No.", '%1', '');
                    L_WarehouseshipmentLine.DeleteAll();
                end;
            }
        }
        addafter("P&osting")
        {
            group("Import/Export SO")
            {
                Caption = 'Import/Export Sales Order';
                action("Export Sales Order Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Sales Order Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Export & Import Sales Order";
                    begin
                        OpningStock.SampleSOTemplate();

                    end;
                }
                action("Import Sales Order")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportSO: codeunit "Export & Import Sales Order";
                    begin
                        ImportSO.Run();
                        Message('Completed..');
                    end;
                }

            }
        }

        addbefore(Category_Category7)
        {
            group(Category_Category77)
            {
                Caption = 'Import/Export Sales Order';
                actionref(ExportSalesOrderTemplate; "Export Sales Order Template")
                {
                }
                actionref(ImportSalesOrder; "Import Sales Order")
                {
                }

            }
        }
        // Add changes to page actions here

    }

    var
        myInt: Integer;
        PartiallyShipped: Boolean;

    trigger OnAfterGetRecord()
    var
        L_SalesLine: Record "Sales Line";
    begin
        Clear(PartiallyShipped);
        L_SalesLine.Reset();
        L_SalesLine.SetRange("Document Type", Rec."Document Type");
        L_SalesLine.SetRange("Document No.", Rec."No.");
        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
        if L_SalesLine.FindSet() then begin
            L_SalesLine.CalcSums("Quantity Shipped", Quantity);
            if (L_SalesLine."Quantity Shipped" > 0) AND (L_SalesLine."Quantity Shipped" < L_SalesLine.Quantity) then begin
                PartiallyShipped := true;
            end;
        end;
    end;

}