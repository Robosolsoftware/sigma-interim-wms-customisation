page 70105 "Lot-Number-by-Item"
{

    Caption = 'Lot No. by Item';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = 7351;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    StyleExpr = Color;

                }
                field("Zone Code"; rec."Zone Code")
                {
                    ApplicationArea = all;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }

                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    StyleExpr = Color;
                    ApplicationArea = All;
                }
                field("Qty (Available)"; Rec."Qty (Available)")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = all;
                    Visible = false;

                }

            }
        }
    }

    actions
    {
    }



    trigger OnFindRecord(Which: Text): Boolean
    begin
        FillTempTable;
        EXIT(Rec.FIND(Which));
    end;

    var
        Color: Text;
        ManufacturerName: Text;
        ItemVariant: Record 5401;
        ExpDate: Text;
        TempLotNoBinBuffer: Record 7351 temporary;
        ItemTrackingManagement: Codeunit 6500;
        EntriesExist: Boolean;
        UserSetup: Record 91;
        ResponsibilityCenter: Record 5714;
        ExternalIdNo: Code[20];
        AsinNo: Code[20];
        ItemTrackingSetup: Record "Item Tracking Setup";

    local procedure FillTempTable()
    var
        LotNosByBinCode: Query "LotNumber WarehouseEntry New";
        Reclocation: Record Location;
        BinContent: Record "Bin Content";
        bin: Record Bin;
    begin
        Rec.DELETEALL;
        LotNosByBinCode.SETRANGE(Item_No, Rec.GETRANGEMIN("Item No."));
        // // Manish ++
        // IF UserSetup.GET(USERID) THEN BEGIN
        //     IF ResponsibilityCenter.GET(UserSetup."Sales Resp. Ctr. Filter") THEN BEGIN
        //         //SETFILTER("Location Filter",ResponsibilityCenter."Location Code");
        //         //CALCFIELDS(Inventory);
        //         LotNosByBinCode.SETRANGE(LotNosByBinCode.Location_Code, ResponsibilityCenter."Location Code");
        //     END
        // END;
        // // Manish --

        LotNosByBinCode.OPEN;

        WHILE LotNosByBinCode.READ DO BEGIN
            Rec.INIT;
            Rec."Item No." := LotNosByBinCode.Item_No;
            Rec."Variant Code" := LotNosByBinCode.Variant_Code;
            Rec."Location Code" := LotNosByBinCode.Location_Code;
            Rec."Zone Code" := LotNosByBinCode.Zone_Code;
            Rec."Lot No." := LotNosByBinCode.Lot_No;
            Rec."Bin Code" := LotNosByBinCode.Bin_Code;
            ItemTrackingSetup."Lot No." := LotNosByBinCode.Lot_No;
            Rec."Expiry Date" := ItemTrackingManagement.ExistingExpirationDate(LotNosByBinCode.Item_No, LotNosByBinCode.Variant_Code, ItemTrackingSetup, FALSE, EntriesExist);
            Rec."Qty. (Base)" := LotNosByBinCode.Sum_Quantity;

            BinContent.Reset();
            BinContent.SetRange("Item No.", Rec."Item No.");
            if Rec."Location Code" <> '' then
                BinContent.SetRange("Location Code", Rec."Location Code");
            if Rec."Bin Code" <> '' then
                BinContent.SetRange("Bin Code", Rec."Bin Code");
            if Rec."Lot No." <> '' then
                BinContent.SetFilter("Lot No. Filter", Rec."Lot No.");
            if rec."Zone Code" <> '' then
                BinContent.SetRange("Zone Code", Rec."Zone Code");

            if BinContent.FindFirst() then begin
                Rec."Qty (Available)" := BinContent.CalcQtyAvailToTakeUOM;
            end;
            bin.Reset();
            bin.SetRange("Location Code", LotNosByBinCode.Location_Code);
            bin.SetRange(Code, LotNosByBinCode.Bin_Code);
            bin.SetRange("Exclude from Fact box", false);
            if bin.FindFirst() then begin

                Reclocation.Reset();
                Reclocation.SetRange(Code, LotNosByBinCode.Location_Code);
                Reclocation.SetRange("Skip for Lot FB", false);
                if Reclocation.FindFirst() then begin
                    IF Rec."Qty. (Base)" <> 0 THEN
                        Rec.Insert();
                end;
            end;

        END;
    end;

}


