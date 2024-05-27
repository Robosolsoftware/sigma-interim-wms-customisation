pageextension 85040 "SC Item Variants" extends "Item Variants"
{
    layout
    {
        // Add changes to page layout here
        modify("Item No.")
        {
            Editable = L_CurrFieldEditable;
        }
        modify(Code)
        {
            Editable = L_CurrFieldEditable;
        }
        modify(Description)
        {
            Editable = L_CurrFieldEditable;
        }
        modify("Description 2")
        {
            Editable = L_CurrFieldEditable;
        }
        modify(Blocked)
        {
            Editable = L_CurrFieldEditable;

        }
        modify("Sales Blocked")
        {
            Editable = L_CurrFieldEditable;
        }
        modify("Service Blocked")
        {
            Editable = L_CurrFieldEditable;
        }
        modify("Purchasing Blocked")
        {
            Editable = L_CurrFieldEditable;
        }


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
        L_CurrFieldEditable: Boolean;


    trigger OnOpenPage()
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item."Variant Mandatory if Exists" = L_Item."Variant Mandatory if Exists"::No then
                CurrPage.Editable(false);


            Clear(L_CurrFieldEditable);
            if L_Item.Status = L_Item.Status::Released then
                L_CurrFieldEditable := false
            else
                L_CurrFieldEditable := true;
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

            Clear(L_CurrFieldEditable);
            if L_Item.Status = L_Item.Status::Released then
                L_CurrFieldEditable := false
            else
                L_CurrFieldEditable := true;
        end;

    end;
}