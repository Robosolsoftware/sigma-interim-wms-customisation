// pageextension 70178 "Req. Worksheet" extends "Req. Worksheet"
// {
//     layout
//     {
//         addafter("Accept Action Message")
//         {
//             field("Drop Shipment"; Rec."Drop Shipment")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//             }
//         }
//         addafter(Description)
//         {
//             field("Vendor Name"; Rec."Vendor Name")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Vendor Name field.';
//             }
//             field("Catalog SKU"; Rec."Catalog SKU")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Catalog SKU field.';
//             }
//             field("Trade Track SKU"; Rec."Trade Track SKU")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Trade Track SKU field.';
//             }
//         }
//         addafter(Quantity)
//         {
//             field("Qty On Sales Order"; Rec."Qty On Sales Order")
//             {
//                 ApplicationArea = All;
//             }
//             field("Qty On Purchase Order"; Rec."Qty On Purchase Order")
//             {
//                 ApplicationArea = All;
//             }
//             field(Inventory; Rec.Inventory)
//             {
//                 ApplicationArea = All;
//             }
//             field("Maximum Inventory"; Rec."Maximum Inventory")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Maximum Inventory field.';
//             }
//             field("Reorder Point"; Rec."Reorder Point")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Reorder Point field.';
//             }
//             field("Available Stock"; Rec."Available Stock")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Available Stock field.';
//             }
//             field("Price Break Qty."; Rec."Price Break Qty.")
//             {
//                 Editable = false;
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Price Break Qty. field.';
//             }
//         }
//         addafter("Direct Unit Cost")
//         {
//             field("Price Break Cost"; Rec."Price Break Cost")
//             {
//                 Editable = false;
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the value of the Price Break Cost field.';
//             }
//         }
//     }
//     actions
//     {
//         modify(CarryOutActionMessage)
//         {
//             Visible = true;
//         }
//         addafter(CarryOutActionMessage)
//         {
//             action("Create Combine PO")
//             {
//                 ApplicationArea = Planning;
//                 Caption = 'Create Combine PO';
//                 Ellipsis = true;
//                 Image = Purchase;
//                 PromotedCategory = Process;
//                 Promoted = true;

//                 trigger OnAction()
//                 var
//                     RequisitionLine: Record "Requisition Line";
//                 begin
//                     Clear(RequisitionLine);
//                     RequisitionLine := Rec;
//                     CurrPage.SetSelectionFilter(RequisitionLine);

//                     RequisitionLine.SetRange("Drop Shipment", false);
//                     RequisitionLine.SetFilter("Location Code", 'DIST');
//                     RequisitionLine.SetRange("Accept Action Message", true);
//                     RequisitionLine.SetFilter("Vendor No.", '<>%1', '');
//                     RequisitionLine.SetFilter("Action Message", '%1|%2|%3', RequisitionLine."Action Message"::New, RequisitionLine."Action Message"::"Change Qty.", RequisitionLine."Action Message"::"Resched. & Chg. Qty.");
//                     if RequisitionLine.FindSet() then begin
//                         repeat
//                             CreateCombinePO(RequisitionLine);
//                         until RequisitionLine.Next() = 0;
//                     end;
//                     DeleteCancelLinesFromRequistionSheet();
//                     Message('Process Completed Successfully');
//                 end;
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     var
//         CalculateReservedQty: Query ReservedQtyOnILE;
//         L_AvailableQty: Decimal;
//         ItemQuery1: Query ItemQuery;
//         Item: Record Item;
//     begin
//         CLEAR(ItemQuery1);
//         ItemQuery1.SETRANGE(ItemQuery1.No, Rec."No.");
//         ItemQuery1.SETRANGE(ItemQuery1.Location_Filter, Rec."Location Code");
//         ItemQuery1.OPEN;
//         IF ItemQuery1.READ THEN begin
//             L_AvailableQty := ItemQuery1.W_H_Inventory;
//         END;
//         ItemQuery1.CLOSE;

//         Rec."Available Stock" := L_AvailableQty;

//         if Item.Get(rec."No.") then begin
//             Item."Location Filter" := 'DIST';
//             Item.CalcFields("Qty. on Purch. Order", "Qty. on Sales Order", Inventory);
//             rec."Qty On Purchase Order" := Item."Qty. on Purch. Order";
//             rec."Qty On Sales Order" := Item."Qty. on Sales Order";
//             rec.Inventory := Item.Inventory;
//             rec.Modify();
//             Commit();
//         end;
//     end;

//     local procedure CreateCombinePO(var RequisitionLine: Record "Requisition Line")
//     var
//         L_PurchaseHeader: Record "Purchase Header";
//         L_PurchaseLine: Record "Purchase Line";
//         TotalQuantity: Decimal;
//         IsPurchaseLineFound: Boolean;
//         PONumber: Code[20];
//         SalesLine: Record "Sales Line";
//     begin
//         Clear(PONumber);
//         IsPurchaseLineFound := false;
//         L_PurchaseHeader.Reset();
//         L_PurchaseHeader.SetRange("Document Type", L_PurchaseHeader."Document Type"::Order);
//         L_PurchaseHeader.SetRange("Buy-from Vendor No.", RequisitionLine."Vendor No.");
//         L_PurchaseHeader.SetRange(Status, L_PurchaseHeader.Status::Open);
//         L_PurchaseHeader.SetFilter("Location Code", RequisitionLine."Location Code");
//         L_PurchaseHeader.SetFilter("Phase Status", '<>%1', L_PurchaseHeader."Phase Status"::Dropship);
//         if L_PurchaseHeader.FindSet() then begin
//             repeat
//                 Clear(TotalQuantity);
//                 L_PurchaseLine.Reset();
//                 L_PurchaseLine.SetRange("Document Type", L_PurchaseHeader."Document Type");
//                 L_PurchaseLine.SetRange("Document No.", L_PurchaseHeader."No.");
//                 L_PurchaseLine.SetRange("Buy-from Vendor No.", RequisitionLine."Vendor No.");
//                 L_PurchaseLine.SetRange("No.", RequisitionLine."No.");
//                 L_PurchaseLine.SetRange("Drop Shipment", false);
//                 L_PurchaseLine.SetFilter("Location Code", RequisitionLine."Location Code");
//                 if L_PurchaseLine.FindFirst() then begin
//                     TotalQuantity := L_PurchaseLine.Quantity + RequisitionLine.Quantity;
//                     L_PurchaseLine.Validate(Quantity, TotalQuantity);
//                     L_PurchaseLine."Price Break Qty." := RequisitionLine."Price Break Qty.";
//                     L_PurchaseLine."Price Break Cost" := RequisitionLine."Price Break Cost";

//                     Clear(SalesLine);
//                     SalesLine.Reset();
//                     SalesLine.SetRange("Document No.", RequisitionLine."Demand Order No.");
//                     SalesLine.SetRange("Line No.", RequisitionLine."Demand Line No.");
//                     if SalesLine.FindFirst() then begin
//                         L_PurchaseLine.Validate("Custom Sales Order No.", SalesLine."Document No.");
//                         L_PurchaseLine.Validate("Custom Sales Order Line No.", SalesLine."Line No.");

//                         SalesLine."Custom PO No." := L_PurchaseLine."Document No.";
//                         SalesLine."Custom PO Line No." := L_PurchaseLine."Line No.";
//                         SalesLine.Modify();
//                     end;

//                     L_PurchaseLine."Combine PO" := true;
//                     L_PurchaseLine.Modify(true);

//                     L_PurchaseHeader."Combine PO" := true;
//                     L_PurchaseHeader.Modify();

//                     if RequisitionLine.Reserve = true then begin
//                         CreateReservationEntry(RequisitionLine, L_PurchaseHeader, L_PurchaseLine);
//                     end;

//                     RequisitionLine.Delete(true);
//                     IsPurchaseLineFound := true;
//                     Commit();
//                     break;
//                 end;
//             until L_PurchaseHeader.Next() = 0;
//         end
//         else begin
//             PONumber := CreateNewPO(RequisitionLine);
//         end;

//         if (RequisitionLine."Action Message" = RequisitionLine."Action Message"::New) and (not IsPurchaseLineFound) and (PONumber = '') then begin
//             L_PurchaseHeader.Reset();
//             L_PurchaseHeader.SetRange("Document Type", L_PurchaseHeader."Document Type"::Order);
//             L_PurchaseHeader.SetRange("Buy-from Vendor No.", RequisitionLine."Vendor No.");
//             L_PurchaseHeader.SetRange(Status, L_PurchaseHeader.Status::Open);
//             L_PurchaseHeader.SetFilter("Location Code", RequisitionLine."Location Code");
//             L_PurchaseHeader.SetFilter("Phase Status", '<>%1', L_PurchaseHeader."Phase Status"::Dropship);
//             if L_PurchaseHeader.FindFirst() then begin
//                 CreateNewPOLine(RequisitionLine, L_PurchaseHeader);
//             end;
//         end;
//     end;

//     local procedure CreateNewPO(var RequisitionLine: Record "Requisition Line"): Code[20]
//     var
//         PurchasePaybleSetup: Record "Purchases & Payables Setup";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//         L_PurchaseHeader: Record "Purchase Header";
//         L_Location: Record Location;
//         L_Vendor: Record Vendor;
//     begin
//         PurchasePaybleSetup.Get();
//         Clear(L_PurchaseHeader);
//         L_PurchaseHeader.Init();
//         L_PurchaseHeader.Validate("Document Type", L_PurchaseHeader."Document Type"::Order);
//         L_PurchaseHeader.Validate("No.", NoSeriesManagement.GetNextNo(PurchasePaybleSetup."Order Nos.", WorkDate(), true));
//         L_PurchaseHeader.Validate("Buy-from Vendor No.", RequisitionLine."Vendor No.");
//         L_PurchaseHeader.Validate("Document Date", WorkDate());
//         L_PurchaseHeader.Validate("Order Date", WorkDate());
//         L_PurchaseHeader.Validate("Invoice Received Date", WorkDate());
//         L_PurchaseHeader.Validate("Posting Date", WorkDate());
//         L_PurchaseHeader.Validate("VAT Reporting Date", WorkDate());

//         Clear(L_Vendor);
//         L_Vendor.Reset();
//         if L_Vendor.Get(RequisitionLine."Vendor No.") then begin
//             L_PurchaseHeader.Validate("Payment Terms Code", L_Vendor."Payment Terms Code");
//             L_PurchaseHeader.Validate("Lead Time Calculation", L_Vendor."Lead Time Calculation");
//         end;
//         //L_PurchaseHeader.Validate("Due Date", RequisitionLine."Due Date");

//         L_PurchaseHeader.Validate("Location Code", RequisitionLine."Location Code");
//         if RequisitionLine."Location Code" <> '' then begin
//             if L_Location.Get(RequisitionLine."Location Code") then begin
//                 L_PurchaseHeader.Validate("Ship-to Name", L_Location.Name);
//                 L_PurchaseHeader.Validate("Ship-to Address", L_Location.Address);
//                 L_PurchaseHeader.Validate("Ship-to Address 2", L_Location."Address 2");
//                 L_PurchaseHeader.Validate("Ship-to City", L_Location.City);
//                 L_PurchaseHeader.Validate("Ship-to County", L_Location.County);
//                 L_PurchaseHeader.Validate("Ship-to Post Code", L_Location."Post Code");
//                 L_PurchaseHeader.Validate("Ship-to Country/Region Code", L_Location."Country/Region Code");
//             end;
//         end;
//         L_PurchaseHeader.Insert(true);
//         Commit();
//         CreateNewPOLine(RequisitionLine, L_PurchaseHeader);
//         exit(L_PurchaseHeader."No.");
//     end;


//     local procedure CreateNewPOLine(var RequisitionLine: Record "Requisition Line"; var P_PurchaseHeader: Record "Purchase Header")
//     var
//         L_PurchaseLine: Record "Purchase Line";
//         Rec_PurchaseLine: Record "Purchase Line";
//         L_Item: Record Item;
//         LineNo: Integer;
//         SalesLine: Record "Sales Line";
//     begin
//         Clear(L_Item);
//         L_Item.Get(RequisitionLine."No.");

//         Clear(LineNo);
//         Rec_PurchaseLine.Reset();
//         Rec_PurchaseLine.SetRange("Document Type", P_PurchaseHeader."Document Type");
//         Rec_PurchaseLine.SetRange("Document No.", P_PurchaseHeader."No.");
//         if Rec_PurchaseLine.FindLast() then
//             LineNo := Rec_PurchaseLine."Line No." + 10000
//         else begin
//             LineNo := 10000;
//         end;

//         Clear(L_PurchaseLine);
//         L_PurchaseLine.Init();
//         L_PurchaseLine.Validate("Document Type", P_PurchaseHeader."Document Type");
//         L_PurchaseLine.Validate("Document No.", P_PurchaseHeader."No.");
//         L_PurchaseLine.Validate("Line No.", LineNo);
//         L_PurchaseLine.Validate(Type, L_PurchaseLine.Type::Item);
//         L_PurchaseLine.Validate("No.", RequisitionLine."No.");
//         L_PurchaseLine.Validate("Unit of Measure Code", RequisitionLine."Unit of Measure Code");
//         L_PurchaseLine.Validate(Quantity, RequisitionLine.Quantity);
//         L_PurchaseLine.Validate("Location Code", RequisitionLine."Location Code");
//         L_PurchaseLine.Validate("Direct Unit Cost", L_Item."Last Direct Cost");
//         L_PurchaseLine."Price Break Qty." := RequisitionLine."Price Break Qty.";
//         L_PurchaseLine."Price Break Cost" := RequisitionLine."Price Break Cost";

//         Clear(SalesLine);
//         SalesLine.Reset();
//         SalesLine.SetRange("Document No.", RequisitionLine."Demand Order No.");
//         SalesLine.SetRange("Line No.", RequisitionLine."Demand Line No.");
//         if SalesLine.FindFirst() then begin
//             L_PurchaseLine.Validate("Custom Sales Order No.", SalesLine."Document No.");
//             L_PurchaseLine.Validate("Custom Sales Order Line No.", SalesLine."Line No.");

//             SalesLine."Custom PO No." := L_PurchaseLine."Document No.";
//             SalesLine."Custom PO Line No." := L_PurchaseLine."Line No.";
//             SalesLine.Modify();
//         end;

//         L_PurchaseLine."Combine PO" := true;
//         L_PurchaseLine.Insert(true);

//         P_PurchaseHeader."Combine PO" := true;
//         P_PurchaseHeader.Modify();

//         if RequisitionLine.Reserve = true then begin
//             CreateReservationEntry(RequisitionLine, P_PurchaseHeader, L_PurchaseLine);
//         end;

//         RequisitionLine.Delete(true);
//         Commit();
//     end;


//     local procedure CreateReservationEntry(var RequisitionLine: Record "Requisition Line"; var P_PurchaseHeader: Record "Purchase Header"; var P_PurchaseLine: Record "Purchase Line")
//     var
//         Rec_ReservationEntry: Record "Reservation Entry";
//         L_ReservationEntry: Record "Reservation Entry";
//         SalesLine: Record "Sales Line";
//         EntryNo: Integer;
//     begin
//         Clear(EntryNo);
//         Clear(Rec_ReservationEntry);
//         Rec_ReservationEntry.Reset();
//         if Rec_ReservationEntry.FindLast() then
//             EntryNo := Rec_ReservationEntry."Entry No." + 1;

//         //PO Reservation Entry++
//         Clear(L_ReservationEntry);
//         L_ReservationEntry.Reset();
//         L_ReservationEntry.Init();
//         L_ReservationEntry.Validate("Entry No.", EntryNo);
//         L_ReservationEntry.Validate(Positive, true);
//         L_ReservationEntry.Validate("Item No.", P_PurchaseLine."No.");
//         L_ReservationEntry.Validate("Location Code", P_PurchaseLine."Location Code");
//         L_ReservationEntry.Validate("Quantity (Base)", RequisitionLine.Quantity);
//         L_ReservationEntry.Validate("Reservation Status", L_ReservationEntry."Reservation Status"::Reservation);
//         L_ReservationEntry.Validate(Description, P_PurchaseLine.Description);
//         L_ReservationEntry.Validate("Creation Date", WorkDate());
//         L_ReservationEntry.Validate("Source Type", 39);
//         L_ReservationEntry.Validate("Source Subtype", 1);
//         L_ReservationEntry.Validate("Source ID", P_PurchaseHeader."No.");
//         L_ReservationEntry.Validate("Source Ref. No.", P_PurchaseLine."Line No.");
//         L_ReservationEntry.Validate("Expected Receipt Date", P_PurchaseLine."Expected Receipt Date");
//         L_ReservationEntry.Validate("Shipment Date", P_PurchaseLine."Expected Receipt Date");
//         L_ReservationEntry.Validate("Qty. per Unit of Measure", P_PurchaseLine."Qty. per Unit of Measure");
//         L_ReservationEntry.Validate(Quantity, RequisitionLine.Quantity);
//         L_ReservationEntry.Validate(Binding, L_ReservationEntry.Binding::"Order-to-Order");
//         L_ReservationEntry.Validate("Planning Flexibility", L_ReservationEntry."Planning Flexibility"::Unlimited);
//         L_ReservationEntry.Validate("Qty. to Handle (Base)", RequisitionLine.Quantity);
//         L_ReservationEntry.Validate("Qty. to Invoice (Base)", RequisitionLine.Quantity);
//         L_ReservationEntry.Insert(true);
//         //PO Reservation Entry--

//         //SO Reservation Entry++
//         Clear(SalesLine);
//         SalesLine.Reset();
//         SalesLine.SetRange("Document No.", RequisitionLine."Demand Order No.");
//         SalesLine.SetRange("Line No.", RequisitionLine."Demand Line No.");
//         if SalesLine.FindFirst() then;

//         Clear(L_ReservationEntry);
//         L_ReservationEntry.Reset();
//         L_ReservationEntry.Init();
//         L_ReservationEntry.Validate("Entry No.", EntryNo);
//         L_ReservationEntry.Validate(Positive, false);
//         L_ReservationEntry.Validate("Item No.", RequisitionLine."No.");
//         L_ReservationEntry.Validate("Location Code", RequisitionLine."Location Code");
//         L_ReservationEntry.Validate("Quantity (Base)", -RequisitionLine.Quantity);
//         L_ReservationEntry.Validate("Reservation Status", L_ReservationEntry."Reservation Status"::Reservation);
//         L_ReservationEntry.Validate(Description, RequisitionLine.Description);
//         L_ReservationEntry.Validate("Creation Date", WorkDate());
//         L_ReservationEntry.Validate("Source Type", 37);
//         L_ReservationEntry.Validate("Source Subtype", 1);
//         L_ReservationEntry.Validate("Source ID", RequisitionLine."Demand Order No.");
//         L_ReservationEntry.Validate("Source Ref. No.", RequisitionLine."Demand Line No.");
//         L_ReservationEntry.Validate("Expected Receipt Date", P_PurchaseLine."Expected Receipt Date");
//         L_ReservationEntry.Validate("Shipment Date", SalesLine."Shipment Date");
//         L_ReservationEntry.Validate("Qty. per Unit of Measure", SalesLine."Qty. per Unit of Measure");
//         L_ReservationEntry.Validate(Quantity, -RequisitionLine.Quantity);
//         L_ReservationEntry.Validate(Binding, L_ReservationEntry.Binding::"Order-to-Order");
//         L_ReservationEntry.Validate("Planning Flexibility", L_ReservationEntry."Planning Flexibility"::Unlimited);
//         L_ReservationEntry.Validate("Qty. to Handle (Base)", -RequisitionLine.Quantity);
//         L_ReservationEntry.Validate("Qty. to Invoice (Base)", -RequisitionLine.Quantity);
//         L_ReservationEntry.Insert(true);
//         //SO Reservation Entry--
//     end;


//     local procedure DeleteCancelLinesFromRequistionSheet()
//     var
//         RequisitionLine: Record "Requisition Line";
//     begin
//         Clear(RequisitionLine);
//         RequisitionLine.Reset();
//         RequisitionLine.SetRange("Action Message", RequisitionLine."Action Message"::Cancel);
//         if RequisitionLine.FindSet() then begin
//             repeat
//                 RequisitionLine.Delete(true);
//             until RequisitionLine.Next() = 0;
//         end;
//     end;
// }