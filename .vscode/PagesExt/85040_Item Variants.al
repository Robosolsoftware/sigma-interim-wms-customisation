pageextension 85040 "SC Item Variants" extends "Item Variants"
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

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        L_CurrpageEdit: Boolean;


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