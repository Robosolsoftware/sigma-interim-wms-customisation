pageextension 70151 "SC Item Variants" extends "Item Variants"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Total Physical';
            }
            field("Saleable Inventory"; Rec."Saleable Inventory")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Physical';
            }
            field("Qty on SO(Saleable)"; Rec."Qty on SO(Saleable)")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Allocated on SO';
                //GHST Customization++
            }
            field("Total Available Quantity"; TotalAvailableQty(Rec))
            {
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                Caption = 'Free';
                //GHST Customization++
            }
            field(Priority; Rec.Priority)
            {
                ApplicationArea = All;
                //GHST Customization++
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        L_CurrpageEdit: Boolean;

    local procedure TotalAvailableQty(_Rec: Record "Item Variant"): Decimal
    var
        ItemVariant: Record "Item Variant";
        _LocationCode: Code[20];
        L_ILE: Record "Item Ledger Entry";
        SaleableInventory: Decimal;
        L_SalesLine: Record "Sales Line";
        SaleableQtyOnSO: Decimal;
        item: Record Item;
    begin



        // //Calculate Saleable Inventory++
        // Clear(SaleableInventory);
        // L_ILE.Reset();
        // L_ILE.SetRange("Item No.", _Rec."Item No.");
        // L_ILE.SetRange("Variant Code", _Rec.Code);
        // L_ILE.SetRange("Saleable Location", true);
        // if _LocationCode <> '' then
        //     L_ILE.SetFilter("Location Code", _LocationCode);
        // L_ILE.CalcSums(Quantity);
        // SaleableInventory := L_ILE.Quantity;


        // //Calculate Saleable Qty on SO++
        // Clear(SaleableQtyOnSO);
        // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
        // L_SalesLine.SetRange("No.", _Rec."Item No.");
        // L_SalesLine.SetRange("Variant Code", _Rec.Code);
        // L_SalesLine.SetRange("Saleable Location", true);
        // if _LocationCode <> '' then
        //     L_SalesLine.SetRange("Location Code", _LocationCode);
        // L_SalesLine.CalcSums("Outstanding Quantity");
        // SaleableQtyOnSO := L_SalesLine."Outstanding Quantity";

        // if SaleableInventory > 0 then begin
        //     if (SaleableInventory - SaleableQtyOnSO) > 0 then
        //         exit(SaleableInventory - SaleableQtyOnSO)
        //     else
        //         exit(0);
        // end else
        //     exit(0);
        _Rec.CalcFields("Qty on SO(Saleable)", "Saleable Inventory");
        if _Rec."Saleable Inventory" > 0 then
            if (_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)") > 0 then
                exit(_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)")
            else
                exit(0)
        else
            exit(0);
    end;

    trigger OnOpenPage()
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item."Variant Mandatory if Exists" = L_Item."Variant Mandatory if Exists"::No then
                CurrPage.Editable(false);
        end;

    end;

    trigger OnAfterGetRecord()
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item."Variant Mandatory if Exists" = L_Item."Variant Mandatory if Exists"::No then
                CurrPage.Editable(false);
        end;

    end;
}