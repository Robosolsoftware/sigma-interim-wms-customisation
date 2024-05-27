pageextension 85093 "SC Default Dimensions" extends "Default Dimensions"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        L_Item: Record Item;
    begin
        if Rec."Table ID" = 27 then begin
            L_Item.Reset();
            L_Item.SetRange("No.", Rec."No.");
            if L_Item.FindFirst() then begin
                if L_Item.Status = L_Item.Status::Released then
                    CurrPage.Editable(false);
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    var
        L_Item: Record Item;
    begin
        if Rec."Table ID" = 27 then begin
            L_Item.Reset();
            L_Item.SetRange("No.", Rec."No.");
            if L_Item.FindFirst() then begin
                if L_Item.Status = L_Item.Status::Released then
                    CurrPage.Editable(false);
            end;
        end;

    end;
}