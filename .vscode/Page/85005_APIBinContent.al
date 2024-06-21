page 85005 APIBinContent
{
    PageType = API;
    Caption = 'API Bin Content';
    APIPublisher = 'Robosol';
    APIGroup = 'orders';
    APIVersion = 'beta', 'v1.0';
    EntityName = 'BinContentAPI';
    EntitySetName = 'BinContentAPI';
    SourceTable = "Bin Content";
    DelayedInsert = true;
    ApplicationArea = all;
    //ODataKeyFields = SystemId;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = all;

                }
                field(Item_Description; GetItemDesc())
                {
                    ApplicationArea = all;
                }
                field(WarehouseClassCode; Rec."Warehouse Class Code")
                {
                    ApplicationArea = All;
                }
                field(Pack_Size; GetPackSize())
                {
                    ApplicationArea = all;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(ZoneCode; Rec."Zone Code")
                {
                    ApplicationArea = all;
                }
                field(BinCode; Rec."Bin Code")
                {
                    ApplicationArea = all;
                }
                // field(Inventory; GetInventory())
                // {
                //     ApplicationArea = all;
                // }
                // field(NetInventory; GetNetInventory())
                // {
                //     ApplicationArea = all;
                // }
                field(Dimension_Code; Getdimention())
                {
                    ApplicationArea = all;
                }
                field(Quantity_Base; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field(PickQuantity_Base; Rec."Pick Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field(Putaway_Quantity_Base; Rec."Put-away Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field(Available_Qty_to_Take; Rec.CalcQtyAvailToTakeUOM())
                {
                    ApplicationArea = Warehouse;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }

            }
        }
    }

    local procedure GetItemDesc(): Text[250];
    var
        L_Item: Record Item;
        bincontent: Page "Bin Contents";
        bincontenttable: Record "Bin Content";
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", rec."Item No.");
        if L_Item.FindFirst() then begin
            exit(L_Item.Description);
        end;
    end;

    local procedure GetPackSize(): Code[20];
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", rec."Item No.");
        if L_Item.FindFirst() then begin
            exit(L_Item."Pack Size");
        end;
    end;

    local procedure GetInventory(): Decimal;
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", rec."Item No.");
        if L_Item.FindFirst() then begin
            L_Item.CalcFields(Inventory);
            exit(L_Item.Inventory);
        end;
    end;

    local procedure GetNetInventory(): Decimal;
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", rec."Item No.");
        if L_Item.FindFirst() then begin
            L_Item.CalcFields("Net Inventory");
            exit(L_Item."Net Inventory");
        end;
    end;

    local procedure Getdimention(): Code[20];
    var
        L_Item: Record Item;
        Dimention: Record "Default Dimension";
    begin
        L_Item.Reset();
        Dimention.Reset();
        L_Item.SetRange("No.", rec."Item No.");
        if L_Item.FindFirst() then begin
            Dimention.SetRange("No.", L_Item."No.");
            Dimention.SetRange("Table ID", 27);
            if Dimention.FindFirst() then begin
                exit(Dimention."Dimension Code");
            end;
        end;
    end;

    // local procedure GetExpiryDate()
    // var
    //     ItemTrackingSetup: Record "Item Tracking Setup";
    //     EntriesExist: Boolean;
    //     ItemTrackingManagement: Codeunit 6500;
    //     ExpiryDate: Date;
    // begin
    //     ExpiryDate := ItemTrackingManagement.ExistingExpirationDate(Rec."Item No.", Rec."Variant Code", ItemTrackingSetup, false, EntriesExist);
    // end;
}