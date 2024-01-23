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
                field("Qty on SO"; Rec."Qty on SO")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Saleable Inventory"; Rec."Saleable Inventory")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty on SO(Saleable)"; Rec."Qty on SO(Saleable)")
                {
                    ApplicationArea = All;
                    Editable = false;
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
        _Rec.CalcFields("Qty on SO(Saleable)", "Saleable Inventory");
        if _Rec."Saleable Inventory" > 0 then
            if (_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)") > 0 then
                exit(_Rec."Saleable Inventory" - _Rec."Qty on SO(Saleable)")
            else
                exit(0)
        else
            exit(0);
    end;
}