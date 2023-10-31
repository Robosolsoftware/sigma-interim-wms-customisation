page 50003 "Item Variants Details"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Item Variant";
    Editable = false;
    Caption = 'Item Variants Details';

    layout
    {
        area(Content)
        {
            repeater("General")
            {
                Editable = false;
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field("Total Requested Quantity"; Rec."Total Requested Quantity")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Total Available Quantity"; TotalAvailableQty(Rec))
                {
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                    //GHST Customization++
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    local procedure TotalAvailableQty(_Rec: Record "Item Variant"): Decimal
    begin
        _Rec.CalcFields(Inventory, "Total Requested Quantity");
        if _Rec.Inventory > 0 then
            exit(_Rec.Inventory - _Rec."Total Requested Quantity")
        else
            exit(0);
    end;
}