page 85008 APIItemLedgerEntry
{
    PageType = API;
    Caption = 'API Item Ledger Entry';
    APIPublisher = 'Robosol';
    APIGroup = 'orders';
    APIVersion = 'beta', 'v1.0';
    EntityName = 'ILEAPI';
    EntitySetName = 'ILEAPI';
    SourceTable = "Item Ledger Entry";
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
                field(Variant_Code; Rec."Variant Code")
                {
                    ApplicationArea = all;
                }
                field(Item_Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Document_Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field(Lot_No; Rec."Lot No.")
                {
                    ApplicationArea = all;
                }
                field(Expiration_Date; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }
                field("Posting_Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(Remaining_Quantity; Rec."Remaining Quantity")
                {
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