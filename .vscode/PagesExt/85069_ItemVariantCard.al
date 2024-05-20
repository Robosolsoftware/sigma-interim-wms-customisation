pageextension 85069 "Item Variant Card" extends "Item Variant Card"
{
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
