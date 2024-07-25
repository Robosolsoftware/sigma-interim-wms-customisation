pageextension 85093 "SC Default Dimensions" extends "Default Dimensions"
{
    layout
    {
        // Add changes to page layout here
        addafter("Dimension Value Code")
        {
            field("Dimension Value Name"; Rec."Dimension Value Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("No."; Rec."No.")
            {
                Caption = 'Customer No.';
                ApplicationArea = All;
                Editable = false;
                Visible = G_No;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        G_No: Boolean;

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
        Clear(G_No);
        if Rec."Table ID" = 18 then
            G_No := true;
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

        Clear(G_No);
        if Rec."Table ID" = 18 then
            G_No := true;


    end;
}