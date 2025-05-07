pageextension 85069 "Item Variant Card" extends "Item Variant Card"
{
    layout
    {
        addafter("Purchasing Blocked")
        {
            field("Variant Approval"; Rec."Variant Approval")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Outer Qty."; Rec."Outer Qty.")
            {
                ApplicationArea = All;
            }
            field("Shipper Qty."; Rec."Shipper Qty.")
            {
                ApplicationArea = All;
            }
            field("Pallet Qty."; Rec."Pallet Qty.")
            {
                ApplicationArea = All;
            }
        }
    }
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
