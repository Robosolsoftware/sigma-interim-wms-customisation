pageextension 85032 "SC Sales Order List" extends "Sales Order List"
{
    layout
    {
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created At';
            }
            field(SystemCreatedBy; G_MiscellaneousCharges.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified At';
            }
            field(SystemModifiedBy; G_MiscellaneousCharges.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified By';
            }
        }
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
            // action("Delete Shipment Line")
            // {
            //     ApplicationArea = All;
            //     trigger OnAction()
            //     var
            //         L_WarehouseshipmentLine: Record "Warehouse Shipment Line";
            //     begin
            //         L_WarehouseshipmentLine.Reset();
            //         L_WarehouseshipmentLine.SetFilter("No.", '%1', '');
            //         L_WarehouseshipmentLine.DeleteAll();
            //     end;
            // }
        }
    }

    var
        myInt: Integer;
        PartiallyShipped: Boolean;
        G_MiscellaneousCharges: Codeunit "Miscellaneous Charges";

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