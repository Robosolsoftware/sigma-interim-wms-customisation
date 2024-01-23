pageextension 70152 "SC Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                L_PurchaseLine: Record "Purchase Line";
            begin
                L_PurchaseLine.Reset();
                L_PurchaseLine.SetRange("Document Type", L_PurchaseLine."Document Type"::Order);
                L_PurchaseLine.SetRange("Document No.", Rec."Source ID");
                L_PurchaseLine.SetRange("Line No.", Rec."Source Ref. No.");
                if L_PurchaseLine.FindFirst() then begin
                    if L_PurchaseLine."Variant Code" <> '' then begin
                        Rec.Validate("Custom Variant Code", L_PurchaseLine."Variant Code");
                        Rec.Modify();
                    end;
                end;

            end;
        }
        addafter("Expiration Date")
        {
            field("Custom Variant Code"; Rec."Custom Variant Code")
            {
                ApplicationArea = All;
                Editable = IsVariantMandatory;
                ShowMandatory = IsVariantMandatory;
                Visible = IsVariantVisible;

                trigger OnValidate()
                begin
                    Rec.TestField("Quantity Handled (Base)", 0);
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        IsVariantMandatory: Boolean;
        IsVariantVisible: Boolean;


    trigger OnOpenPage()
    begin
        Clear(IsVariantVisible);
        if (Rec."Source Type" = 39) AND (Rec."Source Subtype" = 1) then
            IsVariantVisible := true;
    end;

    trigger OnAfterGetRecord()
    var
        L_Item: Record Item;
        L_PurchaseLine: Record "Purchase Line";
    begin
        Clear(IsVariantVisible);
        if (Rec."Source Type" = 39) AND (Rec."Source Subtype" = 1) then
            IsVariantVisible := true;


        Clear(IsVariantMandatory);
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then begin
                L_PurchaseLine.Reset();
                L_PurchaseLine.SetRange("Document Type", L_PurchaseLine."Document Type"::Order);
                L_PurchaseLine.SetRange("Document No.", Rec."Source ID");
                L_PurchaseLine.SetRange("Line No.", Rec."Source Ref. No.");
                if L_PurchaseLine.FindFirst() then begin
                    if L_PurchaseLine."Variant Code" <> '' then
                        IsVariantMandatory := false
                    else
                        IsVariantMandatory := true;
                end;
            end else
                IsVariantMandatory := false;

        end;
    end;
}