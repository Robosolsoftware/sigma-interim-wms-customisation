report 70541 "Lot No. by Bin"

{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Lot No. by Bin';
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {

        dataitem(Item; Item)
        {
            // DataItemLink = "No." = field("No.");
            // DataItemLinkReference = Item;


            trigger OnAfterGetRecord()
            var
                LotNosByBinCode: Query "LotNumber WarehouseEntry New";
                RecItemCategory: Record "Item Category";
                ItemTrackingManagement: Codeunit 6500;
                EntriesExist: Boolean;
                ItemTrackingSetup: Record "Item Tracking Setup";
                LotFound: Boolean;
                ILE: Record "Item Ledger Entry";
            begin
                Item.CalcFields(Inventory);
                if Item.Inventory > 0 then begin
                    Clear(LotNosByBinCode);
                    Clear(ItemN);
                    Clear(ItemDes);
                    Clear(ItemcatCode);
                    Clear(AggreagateCode);
                    Clear(WarehouseClassCode);
                    Clear(Locationcode);
                    Clear(Zonecode);
                    Clear(Bincode);
                    Clear(LotNo);
                    Clear(Inventoryv);
                    Clear(NetInventory);
                    Clear(ExpiryDate);
                    Clear(LotFound);
                    Clear(VariantCode);
                    LotNosByBinCode.SETRANGE(Item_No, Item."No.");
                    LotNosByBinCode.OPEN;
                    ItemN := Item."No.";
                    ItemDes := Item.Description;
                    ItemcatCode := Item."Item Category Code";

                    RecItemCategory.Reset();
                    RecItemCategory.SetRange(Code, Item."Item Category Code");
                    if RecItemCategory.FindFirst() then begin
                        AggreagateCode := RecItemCategory.Code;
                    end;

                    WarehouseClassCode := Item."Warehouse Class Code";


                    Item.CalcFields("Inventory");
                    NetInventory := Item.Inventory;

                    WHILE LotNosByBinCode.READ DO BEGIN

                        IF LotNosByBinCode.Sum_Quantity <> 0 THEN begin
                            Inventoryv := LotNosByBinCode.Sum_Quantity;
                            Locationcode := LotNosByBinCode.Location_Code;
                            Zonecode := LotNosByBinCode.Zone_Code;
                            Bincode := LotNosByBinCode.Bin_Code;
                            VariantCode := LotNosByBinCode.Variant_Code;
                            // LotNo := LotNosByBinCode.Lot_No;
                            // ExpiryDate := ItemTrackingManagement.ExistingExpirationDate(LotNosByBinCode.Item_No, LotNosByBinCode.Variant_Code, ItemTrackingSetup, FALSE, EntriesExist);
                            LotFound := true;
                            ILE.Reset();
                            ILE.SetRange("Document No.", LotNosByBinCode.Reference_No_);
                            If ILE.FindFirst() Then Begin
                                LotNo := ILE."Lot No.";
                                ExpiryDate := ILE."Expiration Date";

                            end;
                            MakeExcelDataBody();
                        end;
                    end;
                    if LotFound = false then begin
                        // Item.CalcFields(Inventory);
                        // Inventoryv := Item.Inventory;
                        MakeExcelDataBody();
                    end;
                end;
            end;
        }
    }








    trigger OnPreReport()
    var
    begin
        ExcelBuf.DeleteAll();
        MakeExcelDataHeader;
    end;

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        CreateExcelbook;
    end;

    var
        ExcelBuf: Record 370 temporary;
        ItemN: Text;
        ItemDes: Text;
        ItemcatCode: text;
        AggreagateCode: Text;
        WarehouseClassCode: Text;
        Locationcode: Text;
        Zonecode: Text;
        Bincode: text;
        LotNo: text;
        Inventoryv: Decimal;
        NetInventory: Decimal;
        ExpiryDate: Date;
        VariantCode: text;




    procedure MakeExcelDataHeader()

    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Aggreagate Code', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Warehouse Class Code', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Location code', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Zone code', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Variant Code', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Bin code', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Lot No.', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Expiry Date', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inventory', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Net Inventory', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    var

    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(ItemN, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemDes, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemcatCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(AggreagateCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(WarehouseClassCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Locationcode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Zonecode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VariantCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Bincode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(LotNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ExpiryDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Inventoryv, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(NetInventory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', text001, '', COMPANYNAME, USERID);
        //ExcelBuf.CreateBook();
        ExcelBuf.CreateNewBook('Lot No. by Bin');
        ExcelBuf.WriteSheet('Lot No. by Bin', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename(StrSubstNo('Lot No. by Bin', CurrentDateTime, UserId));
        ExcelBuf.OpenExcel();
        // ERROR('');
    end;
}     //Mayank