//Dont Use this codeunit for any customization++
codeunit 85003 "Purchase Variant Management"
{
    Permissions = tabledata 7312 = m, tabledata 5767 = m;
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Codeunit 90;

    //////-------------------------------- Normal Business Purchase Process ----------------------------------------------------------------------
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure No_OnAfterValidateEvent(var Rec: Record "Purchase Line")
    var
        L_ItemVendor: Record "Item Vendor";
        L_PurchaseHeader: Record "Purchase Header";
    begin
        L_PurchaseHeader.Reset();
        L_PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        L_PurchaseHeader.SetRange("No.", Rec."Document No.");
        if L_PurchaseHeader.FindFirst() then begin
            if L_PurchaseHeader."Document Type" = L_PurchaseHeader."Document Type"::Order then begin
                if (Rec."No." <> '') AND (Rec.Type = Rec.Type::Item) then begin
                    L_ItemVendor.Reset();
                    L_ItemVendor.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                    L_ItemVendor.SetRange("Item No.", Rec."No.");
                    if L_ItemVendor.FindFirst() then begin
                        if L_ItemVendor."Variant Code" <> '' then
                            Rec.Validate("Variant Code", L_ItemVendor."Variant Code");
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnAfterPurchLineSetFilters', '', false, false)]
    local procedure OnCodeOnAfterPurchLineSetFilters(var PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header")
    var
        L_ItemVendor: Record "Item Vendor";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if PurchaseLine.FindSet() then begin
                repeat
                    if PurchaseLine."Variant Code" = '' then begin
                        L_ItemVendor.Reset();
                        L_ItemVendor.SetRange("Vendor No.", PurchaseLine."Buy-from Vendor No.");
                        L_ItemVendor.SetRange("Item No.", PurchaseLine."No.");
                        if L_ItemVendor.FindFirst() then begin
                            if L_ItemVendor."Variant Code" <> '' then begin
                                PurchaseLine.Validate("Variant Code", L_ItemVendor."Variant Code");
                                PurchaseLine.Modify();
                            end;
                        end;
                    end;
                until PurchaseLine.Next() = 0;
            end;
        end;
    end;
    //////++++++++++++++++++++++++++++++++ Normal Business Purchase Process ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

}