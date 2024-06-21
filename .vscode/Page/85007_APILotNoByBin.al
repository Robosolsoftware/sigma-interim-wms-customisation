// page 85007 APILotNoByBin
// {
//     PageType = API;
//     Caption = 'API Lot No By Bin';
//     APIPublisher = 'Robosol';
//     APIGroup = 'orders';
//     APIVersion = 'beta', 'v1.0';
//     EntityName = 'LotNoByBinAPI';
//     EntitySetName = 'LotNoByBinAPI';
//     SourceTable = Item;
//     DelayedInsert = true;
//     ApplicationArea = all;
//     //ODataKeyFields = SystemId;
//     InsertAllowed = false;
//     DeleteAllowed = false;
//     ModifyAllowed = false;

//     layout
//     {
//         area(Content)
//         {
//             repeater(general)
//             {
//                 field(ItemNo; ItemN)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(ItemDescription; ItemDes)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(ItemCategoryCode; ItemcatCode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(AggreagateCode; AggreagateCode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(WarehouseClassCode; WarehouseClassCode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Locationcode; Locationcode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Zonecode; Zonecode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Bincode; Bincode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(LotNo; LotNo)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(ExpiryDate; ExpiryDate)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Inventory; Inventoryv)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(LotFound; LotFound)
//                 {
//                     ApplicationArea = All;
//                 }

//             }
//         }
//     }
//     trigger OnAfterGetRecord()
//     var
//         LotNosByBinCode: Query "LotNumber WarehouseEntry New";
//         RecItemCategory: Record "Item Category";
//         ItemTrackingManagement: Codeunit 6500;
//         EntriesExist: Boolean;
//         ItemTrackingSetup: Record "Item Tracking Setup";
//     begin
//         Rec.CalcFields(Inventory);
//         if Rec.Inventory > 0 then begin
//             Clear(LotNosByBinCode);
//             Clear(ItemN);
//             Clear(ItemDes);
//             Clear(ItemcatCode);
//             Clear(AggreagateCode);
//             Clear(WarehouseClassCode);
//             Clear(Locationcode);
//             Clear(Zonecode);
//             Clear(Bincode);
//             Clear(LotNo);
//             Clear(Inventoryv);
//             Clear(NetInventory);
//             Clear(ExpiryDate);
//             Clear(LotFound);

//             LotNosByBinCode.SETRANGE(Item_No, Rec."No.");
//             LotNosByBinCode.OPEN;
//             ItemN := Rec."No.";
//             ItemDes := Rec.Description;
//             ItemcatCode := Rec."Item Category Code";

//             RecItemCategory.Reset();
//             RecItemCategory.SetRange(Code, Rec."Item Category Code");
//             if RecItemCategory.FindFirst() then begin
//                 AggreagateCode := RecItemCategory.Code;
//             end;

//             WarehouseClassCode := Rec."Warehouse Class Code";


//             Rec.CalcFields("Net Inventory");
//             NetInventory := Rec."Net Inventory";

//             WHILE LotNosByBinCode.READ DO BEGIN

//                 IF LotNosByBinCode.Sum_Quantity <> 0 THEN begin
//                     Inventoryv := LotNosByBinCode.Sum_Quantity;
//                     Locationcode := LotNosByBinCode.Location_Code;
//                     Zonecode := LotNosByBinCode.Zone_Code;
//                     Bincode := LotNosByBinCode.Bin_Code;
//                     LotNo := LotNosByBinCode.Lot_No;
//                     ExpiryDate := ItemTrackingManagement.ExistingExpirationDate(LotNosByBinCode.Item_No, LotNosByBinCode.Variant_Code, ItemTrackingSetup, FALSE, EntriesExist);
//                     LotFound := true;
//                 end
//                 else begin
//                     LotFound := false;
//                 end;
//             end;
//         end;
//     end;

//     var
//         ItemN: Text;
//         ItemDes: Text;
//         ItemcatCode: text;
//         AggreagateCode: Text;
//         WarehouseClassCode: Text;
//         Locationcode: Text;
//         Zonecode: Text;
//         Bincode: text;
//         LotNo: text;
//         Inventoryv: Decimal;
//         NetInventory: Decimal;
//         ExpiryDate: Date;
//         LotFound: Boolean;
// }