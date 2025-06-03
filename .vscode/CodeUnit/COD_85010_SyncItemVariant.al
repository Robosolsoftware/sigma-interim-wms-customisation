codeunit 85010 "ItemVariantSyncHandler"
{
    procedure Sync()
    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";
        SyncTable: Record "Shipper/Pallet Data";
        NowDT: DateTime;
    begin
        NowDT := CurrentDateTime;

        if Item.FindSet() then
            repeat
                ItemVariant.SetRange("Item No.", Item."No.");
                if ItemVariant.FindSet() then begin
                    repeat
                        if not SyncTable.Get(Item."No.", ItemVariant.Code) then begin
                            SyncTable.Init();
                            SyncTable.Validate("Item No.", Item."No.");
                            SyncTable.Validate("Variant Code", ItemVariant.Code);
                            SyncTable.Insert();
                        end;
                    until ItemVariant.Next() = 0;
                end else begin
                    if not SyncTable.Get(Item."No.", '') then begin
                        SyncTable.Init();
                        SyncTable.Validate("Item No.", Item."No.");
                        SyncTable.Validate("Variant Code", '');
                        SyncTable.Insert();
                    end;
                end;
            until Item.Next() = 0;
    end;
}
