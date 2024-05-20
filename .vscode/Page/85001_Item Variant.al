page 85001 "Item Variants Details"
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
                    Editable = false;
                    Caption = 'Total Physical';
                    ToolTip = 'Total Inventory';
                    DecimalPlaces = 0 : 5;
                    //GHST Customization++
                }
                field(Allocated; Rec.Allocated)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Sum of Outstanding Qty on SO across ALL Locations';
                    DecimalPlaces = 0 : 5;
                    Caption = 'Total Allocated on SO';
                    //GHST Customization++
                }
                //Total Free field added on Ochannel Extensio+++
                field("Saleable Inventory"; Rec."Saleable Inventory")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Physical';
                    ToolTip = 'Qty available in Saleable location';
                    //GHST Customization++
                }
                field("Qty on SO(Saleable)"; Rec."Qty on SO(Saleable)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Allocated on SO';
                    ToolTip = 'Sum of Outstanding SO Qty in Saleable location';
                    //GHST Customization++
                }
                //Free field added on Ochannel Extensio+++
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    //GHST Customization++
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