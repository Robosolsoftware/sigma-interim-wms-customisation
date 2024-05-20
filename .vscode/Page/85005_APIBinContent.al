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
    ODataKeyFields = SystemId;
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
                    Caption = 'Item No.';
                    ApplicationArea = all;

                }
                field(ItemDesc1; GetItemDesc())
                {
                    Caption = 'Item Description';
                    ApplicationArea = all;
                }
                field(LocationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    ApplicationArea = all;
                }
                field(ZoneCode; Rec."Zone Code")
                {
                    Caption = 'Zone Code';
                    ApplicationArea = all;
                }
                field(BinCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                    ApplicationArea = all;
                }
                field(packsize1; GetPackSize())
                {
                    Caption = 'Pack Size';
                    ApplicationArea = all;
                }
                field(inventory1; GetInventory())
                {
                    Caption = 'Inventory';
                    ApplicationArea = all;
                }
                field(NetInventory; GetNetInventory())
                {
                    Caption = 'Net Inventory';
                    ApplicationArea = all;
                }
                field(dimentioncode1; Getdimention())
                {
                    Caption = 'Dimension Code';
                    ApplicationArea = all;
                }
                field(CalcQtyAvailToTakeUOM; Rec.CalcQtyAvailToTakeUOM())
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Available Qty. to Take';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of the item that is available in the bin.';
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    var
    //     L_Item: Record Item;
    begin
        //     L_Item.Reset();
        //     L_Item.SetRange("No.", rec."Item No.");
        //     if L_Item.FindFirst() then begin
        //         ItemDesc := L_Item.Description;
        //         packsize := L_Item."Pack Size";
        //         inventory := L_Item.Inventory;
        //     end;
        // GetItemDesc();
    end;

    local procedure GetItemDesc(): Text[250];
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", rec."Item No.");
        if L_Item.FindFirst() then begin
            // ItemDesc := L_Item.Description;
            // packsize := L_Item."Pack Size";
            // inventory := L_Item.Inventory;
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
            // ItemDesc := L_Item.Description;
            // packsize := L_Item."Pack Size";
            // inventory := L_Item.Inventory;
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
            // ItemDesc := L_Item.Description;
            // packsize := L_Item."Pack Size";
            // inventory := L_Item.Inventory;
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
            // ItemDesc := L_Item.Description;
            // packsize := L_Item."Pack Size";
            // inventory := L_Item.Inventory;
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
            // ItemDesc := L_Item.Description;
            // packsize := L_Item."Pack Size";
            // inventory := L_Item.Inventory;

        end;
    end;



    var
        ItemDesc: Text[100];
        packsize: Code[20];
        inventory: Decimal;
}