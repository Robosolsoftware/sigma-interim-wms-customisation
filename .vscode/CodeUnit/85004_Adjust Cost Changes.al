codeunit 85004 "Adjust Cost Changes"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", OnMakeSingleLevelAdjmtOnBeforePostAdjmtBuf2, '', false, false)]
    local procedure OnMakeSingleLevelAdjmtOnBeforePostAdjmtBuf(var TempInventoryAdjustmentBuffer: Record "Inventory Adjustment Buffer" temporary; var Item: Record Item)
    var
        test: Report 795;
    begin
        if Item."Variant Mandatory if Exists" = Item."Variant Mandatory if Exists"::Yes then begin
            TempInventoryAdjustmentBuffer.Reset();
            TempInventoryAdjustmentBuffer.SetRange("Item No.", Item."No.");
            TempInventoryAdjustmentBuffer.SetFilter("Variant Code", '%1', '');
            if TempInventoryAdjustmentBuffer.FindFirst() then begin
                TempInventoryAdjustmentBuffer.Reset();
                TempInventoryAdjustmentBuffer.SetRange("Item No.", Item."No.");
                if TempInventoryAdjustmentBuffer.FindSet() then
                    TempInventoryAdjustmentBuffer.DeleteAll();
            end;
        end else begin
            if Item."Variant Mandatory if Exists" = Item."Variant Mandatory if Exists"::No then begin
                TempInventoryAdjustmentBuffer.Reset();
                TempInventoryAdjustmentBuffer.SetRange("Item No.", Item."No.");
                TempInventoryAdjustmentBuffer.SetFilter("Variant Code", '<>%1', '');
                if TempInventoryAdjustmentBuffer.FindFirst() then begin
                    TempInventoryAdjustmentBuffer.Reset();
                    TempInventoryAdjustmentBuffer.SetRange("Item No.", Item."No.");
                    if TempInventoryAdjustmentBuffer.FindSet() then
                        TempInventoryAdjustmentBuffer.DeleteAll();
                end;
            end else begin
                if Item."Variant Mandatory if Exists" = Item."Variant Mandatory if Exists"::Default then begin
                    TempInventoryAdjustmentBuffer.Reset();
                    TempInventoryAdjustmentBuffer.SetRange("Item No.", Item."No.");
                    if TempInventoryAdjustmentBuffer.FindSet() then
                        TempInventoryAdjustmentBuffer.DeleteAll();
                end;
            end;
        end;
    end;
}