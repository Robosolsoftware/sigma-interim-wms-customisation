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
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("Total Requested Quantity"; Rec."Total Requested Quantity")
            {
                ApplicationArea = All;
                Editable = false;
                //GHST Customization++
            }
            field("Total Available Quantity"; TotalAvailableQty(Rec))
            {
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                ToolTip = 'Total Available Qty (Inventory – Total Requested Qty)';
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

    local procedure TotalAvailableQty(_Rec: Record "Item Variant"): Decimal
    begin
        _Rec.CalcFields(Inventory, "Total Requested Quantity");
        if _Rec.Inventory > 0 then
            exit(_Rec.Inventory - _Rec."Total Requested Quantity")
        else
            exit(0);
    end;
}