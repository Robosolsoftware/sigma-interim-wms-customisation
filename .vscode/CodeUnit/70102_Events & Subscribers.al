codeunit 70102 "SC Events & Subscriber"
{

    Permissions = tabledata 7320 = m, tabledata 7322 = m;
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_LocationCode: Code[20];
    //G_FromPOScreen: Boolean;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateShptHeader', '', false, false)]
    local procedure OnAfterCreateShptHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line")
    var
        L_SalesHeader: Record "Sales Header";
    begin
        L_SalesHeader.Reset();
        L_SalesHeader.SetRange("Document Type", SalesLine."Document Type");
        L_SalesHeader.SetRange("No.", SalesLine."Document No.");
        if L_SalesHeader.FindFirst() then begin
            WarehouseShipmentHeader.Validate("Delivery Note", L_SalesHeader."Delivery Note");
            WarehouseShipmentHeader.Validate("Collection Note", L_SalesHeader."Collection Note");
            WarehouseShipmentHeader.Validate(_Invoice, L_SalesHeader._Invoice);
            WarehouseShipmentHeader.Validate("Packing list", L_SalesHeader."Packing list");
            WarehouseShipmentHeader.Validate("Export Checklist", L_SalesHeader."Export Checklist");
            WarehouseShipmentHeader.Validate("Data Logger Sheet", L_SalesHeader."Data Logger Sheet");
            WarehouseShipmentHeader.Validate(Labels, L_SalesHeader.Labels);
            WarehouseShipmentHeader.Validate("Extra Documents", L_SalesHeader."Extra Documents");
            WarehouseShipmentHeader.Modify();
        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterCreatePostedShptHeader', '', true, true)]
    local procedure UpdatePostedWareHouseShpHeader(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShptHeader.Validate("Delivery Note", WarehouseShipmentHeader."Delivery Note");
        PostedWhseShptHeader.Validate("Collection Note", WarehouseShipmentHeader."Collection Note");
        PostedWhseShptHeader.Validate(_Invoice, WarehouseShipmentHeader._Invoice);
        PostedWhseShptHeader.Validate("Packing list", WarehouseShipmentHeader."Packing list");
        PostedWhseShptHeader.Validate("Export Checklist", WarehouseShipmentHeader."Export Checklist");
        PostedWhseShptHeader.Validate("Data Logger Sheet", WarehouseShipmentHeader."Data Logger Sheet");
        PostedWhseShptHeader.Validate(Labels, WarehouseShipmentHeader.Labels);
        PostedWhseShptHeader.Validate("Extra Documents", WarehouseShipmentHeader."Extra Documents");
        PostedWhseShptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeValidateShipToOptions', '', false, false)]
    local procedure OnBeforeValidateShipToOptions(ShipToOptions: Option; var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            if ShipToOptions = 2 then
                Error('You cannot select Custom Address');
    end;


    procedure UpdateAvaibleQty(_SalesLine: Record "Sales Line")
    var
        L_ItemVariant: Record "Item Variant";
    begin
        // L_ItemVariant.Reset();
        // L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        // if L_ItemVariant.FindSet() then
        //     repeat
        //         L_ItemVariant.CalcFields(Inventory, "Total Requested Quantity");
        //         L_ItemVariant.Quantity := L_ItemVariant.Inventory - L_ItemVariant."Total Requested Quantity";
        //         L_ItemVariant.Modify();
        //     until L_ItemVariant.Next() = 0;

        //New Code++
        L_ItemVariant.Reset();
        L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        L_ItemVariant.SetFilter("Location Filter", _SalesLine."Location Code");
        L_ItemVariant.SetRange(Blocked, false);
        L_ItemVariant.SetRange("Sales Blocked", false);
        if L_ItemVariant.FindSet() then
            repeat
                L_ItemVariant.CalcFields("Saleable Inventory", "Qty on SO(Saleable)");
                if (L_ItemVariant."Saleable Inventory" - L_ItemVariant."Qty on SO(Saleable)") > 0 then
                    L_ItemVariant.Quantity := L_ItemVariant."Saleable Inventory" - L_ItemVariant."Qty on SO(Saleable)"
                else
                    L_ItemVariant.Quantity := 0;
                L_ItemVariant.Modify();
            until L_ItemVariant.Next() = 0;
    end;

    procedure SetPriorityWithoutZero(_SalesLine: Record "Sales Line"; var _ItemVariant: Record "Item Variant")
    begin
        // Clear(_ItemVariant);
        // _ItemVariant.Reset();
        // _ItemVariant.SetRange("Item No.", _SalesLine."No.");
        // _ItemVariant.SetFilter(Priority, '<>%1', 0);
        // _ItemVariant.SetCurrentKey(Priority);
        // _ItemVariant.Ascending(true);
        // if _ItemVariant.FindFirst() then;


        //New Code++
        Clear(_ItemVariant);
        _ItemVariant.Reset();
        _ItemVariant.SetRange("Item No.", _SalesLine."No.");
        _ItemVariant.SetFilter("Location Filter", _SalesLine."Location Code");
        _ItemVariant.SetRange(Blocked, false);
        _ItemVariant.SetRange("Sales Blocked", false);
        _ItemVariant.SetFilter(Priority, '<>%1', 0);
        _ItemVariant.SetCurrentKey(Priority);
        _ItemVariant.Ascending(true);
        if _ItemVariant.FindFirst() then;
    end;

    procedure SetPriorityWithZeroandHigherQty(_SalesLine: Record "Sales Line"; var _ItemVariant: Record "Item Variant")
    begin
        // Clear(_ItemVariant);
        // _ItemVariant.Reset();
        // _ItemVariant.SetRange("Item No.", _SalesLine."No.");
        // _ItemVariant.SetFilter(Priority, '%1', 0);
        // _ItemVariant.SetFilter(Quantity, '>%1', 0); //Quantity equal to Availble Quantity++
        // _ItemVariant.SetCurrentKey(Quantity);
        // _ItemVariant.Ascending(false);
        // if _ItemVariant.FindFirst() then;


        //New Code++
        Clear(_ItemVariant);
        _ItemVariant.Reset();
        _ItemVariant.SetRange("Item No.", _SalesLine."No.");
        _ItemVariant.SetFilter("Location Filter", _SalesLine."Location Code");
        _ItemVariant.SetRange(Blocked, false);
        _ItemVariant.SetRange("Sales Blocked", false);
        _ItemVariant.SetFilter(Priority, '%1', 0);
        _ItemVariant.SetFilter(Quantity, '>%1', 0); //Quantity equal to Availble Quantity++
        _ItemVariant.SetCurrentKey(Quantity);
        _ItemVariant.Ascending(false);
        if _ItemVariant.FindFirst() then;
    end;



    procedure CheckWarehouseShipmetExist(_salesHear: Record "Sales Header")
    var
        L_WarehouseShipmetLine: Record "Warehouse Shipment Line";
    begin
        L_WarehouseShipmetLine.Reset();
        L_WarehouseShipmetLine.SetRange("Source No.", _salesHear."No.");
        L_WarehouseShipmetLine.SetRange("Source Document", L_WarehouseShipmetLine."Source Document"::"Sales Order");
        if not L_WarehouseShipmetLine.IsEmpty then
            Error('You cannot update variant code because warehouse shipment number %1 exist for this order.', L_WarehouseShipmetLine."No.");

    end;

    procedure CheckTotalAvailablityQty(_SalesLine: Record "Sales Line"): Decimal
    var
        L_ItemVariant: Record "Item Variant";
        L_TotalInventory: Decimal;
        L_TotalRequestedQty: Decimal;
    begin
        // Clear(L_TotalInventory);
        // Clear(L_TotalRequestedQty);
        // L_ItemVariant.Reset();
        // L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        // if L_ItemVariant.FindSet() then begin
        //     repeat
        //         L_ItemVariant.CalcFields(Inventory, "Total Requested Quantity");
        //         L_TotalInventory += L_ItemVariant.Inventory;
        //         L_TotalRequestedQty += L_ItemVariant."Total Requested Quantity";
        //     until L_ItemVariant.Next() = 0;
        //     if L_TotalInventory > 0 then
        //         exit(L_TotalInventory - L_TotalRequestedQty)
        //     else
        //         exit(0);
        // end else
        //     exit(0);

        //New Code++
        Clear(L_TotalInventory);
        Clear(L_TotalRequestedQty);
        L_ItemVariant.Reset();
        L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        L_ItemVariant.SetRange("Location Filter", _SalesLine."Location Code");
        L_ItemVariant.SetRange(Blocked, false);
        L_ItemVariant.SetRange("Sales Blocked", false);
        if L_ItemVariant.FindSet() then begin
            repeat
                L_ItemVariant.CalcFields("Qty on SO(Saleable)", "Saleable Inventory");
                L_TotalInventory += L_ItemVariant."Saleable Inventory";
                L_TotalRequestedQty += L_ItemVariant."Qty on SO(Saleable)";
            until L_ItemVariant.Next() = 0;
            if L_TotalInventory > 0 then
                if (L_TotalInventory - L_TotalRequestedQty) > 0 then
                    exit(L_TotalInventory - L_TotalRequestedQty)
                else
                    exit(0)
            else
                exit(0);
        end else
            exit(0);
    end;

    procedure CheckTotalAvailablityQtyVariantWise(_SalesLine: Record "Sales Line"; _ItemVariant: Record "Item Variant"): Decimal
    var
        L_ItemVariant: Record "Item Variant";
        L_TotalInventory: Decimal;
        L_TotalRequestedQty: Decimal;
    begin
        // Clear(L_TotalInventory);
        // Clear(L_TotalRequestedQty);
        // L_ItemVariant.Reset();
        // L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        // L_ItemVariant.SetRange(Code, _ItemVariant.Code);
        // if L_ItemVariant.FindSet() then begin
        //     repeat
        //         L_ItemVariant.CalcFields(Inventory, "Total Requested Quantity");
        //         L_TotalInventory += L_ItemVariant.Inventory;
        //         L_TotalRequestedQty += L_ItemVariant."Total Requested Quantity";
        //     until L_ItemVariant.Next() = 0;
        //     if L_TotalInventory > 0 then
        //         exit(L_TotalInventory - L_TotalRequestedQty)
        //     else
        //         exit(0);
        // end else
        //     exit(0);

        //New Code++
        Clear(L_TotalInventory);
        Clear(L_TotalRequestedQty);
        L_ItemVariant.Reset();
        L_ItemVariant.SetRange("Item No.", _SalesLine."No.");
        L_ItemVariant.SetFilter("Location Filter", _SalesLine."Location Code");
        L_ItemVariant.SetRange(Blocked, false);
        L_ItemVariant.SetRange("Sales Blocked", false);
        L_ItemVariant.SetRange(Code, _ItemVariant.Code);
        if L_ItemVariant.FindSet() then begin
            repeat
                L_ItemVariant.CalcFields("Saleable Inventory", "Qty on SO(Saleable)");
                L_TotalInventory += L_ItemVariant."Saleable Inventory";
                L_TotalRequestedQty += L_ItemVariant."Qty on SO(Saleable)";
            until L_ItemVariant.Next() = 0;

            if L_TotalInventory > 0 then
                if (L_TotalInventory - L_TotalRequestedQty) > 0 then
                    exit(L_TotalInventory - L_TotalRequestedQty)
                else
                    exit(0)
            else
                exit(0);
        end else
            exit(0);

    end;

    procedure InsertNewSalesLine(_SalesLine: Record "Sales Line"; _ItemVariant: Record "Item Variant"; _QtytoApply: Decimal): Decimal
    var
        L_SalesLine: Record "Sales Line";
    begin
        L_SalesLine.Init();
        L_SalesLine.Validate("Document Type", _SalesLine."Document Type");
        L_SalesLine.Validate("Document No.", _SalesLine."Document No.");
        L_SalesLine.Validate(Type, _SalesLine.Type);
        L_SalesLine.Validate("Line No.", FindLastLineNo(_SalesLine));
        L_SalesLine.Validate("No.", _SalesLine."No.");
        L_SalesLine.Validate(Quantity, _QtytoApply);
        L_SalesLine.Validate("Original Quantity", _SalesLine.Quantity);
        L_SalesLine.Validate("Location Code", _SalesLine."Location Code");
        L_SalesLine.Validate("Unit Price", _SalesLine."Unit Price");
        L_SalesLine.Validate("Variant Created By", _SalesLine."Line No."); //Original Line Number
        L_SalesLine.Insert();
    end;

    local procedure FindLastLineNo(_SalesLine: Record "Sales Line"): Integer
    var
        L_SalesLine: Record "Sales Line";
    begin
        L_SalesLine.Reset();
        L_SalesLine.SetRange("Document Type", _SalesLine."Document Type");
        L_SalesLine.SetRange("Document No.", _SalesLine."Document No.");
        if L_SalesLine.FindLast() then
            exit(L_SalesLine."Line No." + 10000)
        else
            exit(10000);

    end;

    // [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', "Create &Whse. Receipt", true, true)]
    // local procedure UpdateFieldsFromOrdertoWhseRcpt(var Rec: Record "Purchase Header")
    // var
    //     WhseRcptHeader: Record "Warehouse Receipt Header";
    //     WhseRcptLine: Record "Warehouse Receipt Line";
    //     PurchaseLine: Record "Purchase Line";
    //     i: Integer;
    // begin
    //     i := 0;
    //     WhseRcptLine.Reset();
    //     WhseRcptLine.SetRange("Source No.", Rec."No.");
    //     if WhseRcptLine.FindFirst() then begin
    //         WhseRcptHeader.Reset();
    //         WhseRcptHeader.SetRange("No.", WhseRcptLine."No.");
    //         if WhseRcptHeader.FindFirst() then begin
    //             WhseRcptHeader."Purchase Order No." := Rec."No.";
    //             WhseRcptHeader."Purchase Order Date" := Rec."Order Date";
    //             WhseRcptHeader."Supplier Name" := Rec."Buy-from Vendor Name";
    //             PurchaseLine.Reset();
    //             PurchaseLine.SetRange("Document No.", Rec."No.");
    //             PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
    //             if PurchaseLine.FindSet() then begin
    //                 WhseRcptHeader."No. of Items" := PurchaseLine.Count;
    //                 repeat
    //                     if i = 0 then begin
    //                         WhseRcptHeader."Item Category Code" := PurchaseLine."Item Category Code";
    //                         WhseRcptHeader."Warehouse Class Code" := PurchaseLine."Warehouse Class Code";
    //                         WhseRcptHeader.Locationcode := PurchaseLine."Location Code";
    //                     end;
    //                     WhseRcptHeader."Total Order Qty" += PurchaseLine.Quantity;
    //                     i += 1;
    //                 until PurchaseLine.Next() = 0;
    //             end;


    //         end;
    //     end;
    //     WhseRcptHeader.Modify();
    // end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterPostReport', '', false, false)]
    local procedure OnAfterPostReport(var WhseShptHeader: Record "Warehouse Shipment Header"; RequestType: Option; var WhseHeaderCreated: Boolean)
    var
        L_WareShipmentLine: Record "Warehouse Shipment Line";
        L_RepeatOrderNo: Code[20];
        L_SalesHeader: Record "Sales Header";
        L_WareshouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        //Abdul++
        if RequestType = 1 then begin
            L_WareshouseShipmentHeader.Reset();
            L_WareshouseShipmentHeader.SetRange("No.", WhseShptHeader."No.");
            if L_WareshouseShipmentHeader.FindFirst() then begin
                Clear(L_RepeatOrderNo);
                L_WareShipmentLine.Reset();
                L_WareShipmentLine.SetRange("No.", L_WareshouseShipmentHeader."No.");
                L_WareShipmentLine.SetRange("Source Document", L_WareShipmentLine."Source Document"::"Sales Order");
                L_WareShipmentLine.SetCurrentKey("Source No.");
                L_WareShipmentLine.Ascending(true);
                if L_WareShipmentLine.FindSet() then begin
                    repeat
                        if L_RepeatOrderNo <> L_WareShipmentLine."Source No." then begin
                            L_SalesHeader.Reset();
                            L_SalesHeader.SetRange("Document Type", L_SalesHeader."Document Type"::Order);
                            L_SalesHeader.SetRange("No.", L_WareShipmentLine."Source No.");
                            if L_SalesHeader.FindFirst() then begin
                                if L_WareshouseShipmentHeader."Work Description" <> '' then
                                    L_WareshouseShipmentHeader."Work Description" := L_WareshouseShipmentHeader."Work Description" + CRLFSeparator() + L_SalesHeader.GetWorkDescription()
                                else
                                    L_WareshouseShipmentHeader."Work Description" := L_WareshouseShipmentHeader."Work Description" + L_SalesHeader.GetWorkDescription()
                            end;
                        end;
                        L_RepeatOrderNo := L_WareShipmentLine."Source No.";
                    until L_WareShipmentLine.Next() = 0;
                    L_WareshouseShipmentHeader.Modify();
                end;
            end;
        end;
    end;

    procedure CRLFSeparator(): Text[2]
    var
        CRLF: Text[2];
    begin
        CRLF[1] := 13; // Carriage return, '\r'
        CRLF[2] := 10; // Line feed, '\n'
        exit(CRLF);
    end;


    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterProcessDocumentLine', '', true, true)]
    local procedure OnAfterProcessDocumentLine(WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        //WhseRcptHeader: Record "Warehouse Receipt Header";
        WhseRcptLine: Record "Warehouse Receipt Line";
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        i: Integer;
        warehouseClassCode: Boolean;
        warehouseClasses: Record "Warehouse Class";
        //WhseReceiptHeader: Record "Warehouse Receipt Header";
        RecWhseRcpLine: Record "Warehouse Receipt Line";
    begin
        // i := 0;
        // PurchaseHeader.Reset();
        // WhseRcptLine.Reset();
        // WhseRcptLine.SetRange("No.", WarehouseReceiptHeader."No.");
        // WhseRcptLine.SetRange("Source Document", WhseRcptLine."Source Document"::"Purchase Order");
        // if WhseRcptLine.FindFirst() then begin
        //     PurchaseHeader.SetRange("No.", WhseRcptLine."Source No.");
        //     PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        //     if PurchaseHeader.FindFirst() then begin
        //         WarehouseReceiptHeader."Purchase Order No." := PurchaseHeader."No.";
        //         WarehouseReceiptHeader."Purchase Order Date" := PurchaseHeader."Order Date";
        //         WarehouseReceiptHeader."Supplier Name" := PurchaseHeader."Buy-from Vendor Name";
        //         WarehouseReceiptHeader."Requested Receipt Date" := PurchaseHeader."Requested Receipt Date";
        //         PurchaseLine.Reset();
        //         PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        //         PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        //         PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        //         if PurchaseLine.FindSet() then begin
        //             WarehouseReceiptHeader."No. of Items" := PurchaseLine.Count;
        //             repeat
        //                 if i = 0 then begin
        //                     WarehouseReceiptHeader."Item Category Code" := PurchaseLine."Item Category Code";
        //                     WarehouseReceiptHeader."Warehouse Class Code" := PurchaseLine."Warehouse Class Code";
        //                     WarehouseReceiptHeader.Locationcode := PurchaseLine."Location Code";
        //                 end;
        //                 WarehouseReceiptHeader."Total Order Qty" += PurchaseLine.Quantity;
        //                 i += 1;
        //             until PurchaseLine.Next() = 0;
        //         end;
        //         // warehouseClassCode := false;
        //         // RecWhseRcpLine.Reset();
        //         // RecWhseRcpLine.SetRange("No.", WarehouseReceiptHeader."No.");
        //         // if RecWhseRcpLine.FindSet() then begin
        //         //     repeat
        //         //         warehouseClasses.Reset();
        //         //         warehouseClasses.SetRange(Code, RecWhseRcpLine."Warehouse Class Code");
        //         //         if warehouseClasses.FindFirst() then begin
        //         //             if warehouseClasses.CD = true then begin
        //         //                 warehouseClassCode := true;
        //         //                 WarehouseReceiptHeader."CD Qty" += RecWhseRcpLine.Quantity;
        //         //             end;
        //         //         end;
        //         //     until RecWhseRcpLine.Next() = 0;
        //         // end;
        //         // if warehouseClassCode = true then
        //         //     WarehouseReceiptHeader.CD := WarehouseReceiptHeader.CD::Yes
        //         // else
        //         //     WarehouseReceiptHeader.CD := WarehouseReceiptHeader.CD::No;
        //         WarehouseReceiptHeader.Modify();
        //     end;
        // end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnCodeOnAfterWhseRcptHeaderModify', '', true, true)]
    // local procedure CopyWhseRcptHeaderField(WhseReceiptHeader: Record "Warehouse Receipt Header")
    // var
    //     POWhseRcptHeader: Record "Posted Whse. Receipt Header";
    // begin
    //     POWhseRcptHeader.Reset();
    //     POWhseRcptHeader.SetRange("Whse. Receipt No.", WhseReceiptHeader."No.");
    //     if POWhseRcptHeader.FindFirst() then
    //         POWhseRcptHeader.Reset();
    //     POWhseRcptHeader.Init();
    //     POWhseRcptHeader.Validate("Purchase Order No.", WhseReceiptHeader."Purchase Order No.");
    //     POWhseRcptHeader.Validate("Purchase Order Date", WhseReceiptHeader."Purchase Order Date");
    //     POWhseRcptHeader.Validate("Supplier Name", WhseReceiptHeader."Supplier Name");
    //     POWhseRcptHeader.Validate("Warehouse Class Code", WhseReceiptHeader."Warehouse Class Code");
    //     POWhseRcptHeader.Validate(Locationcode, WhseReceiptHeader.Locationcode);
    //     POWhseRcptHeader.Validate("Item Category Code", WhseReceiptHeader."Item Category Code");
    //     POWhseRcptHeader.Validate("No. of Items", WhseReceiptHeader."No. of Items");
    //     POWhseRcptHeader.Validate("Total Order Qty", WhseReceiptHeader."Total Order Qty");
    //     POWhseRcptHeader.Validate(Carrier, WhseReceiptHeader.Carrier);
    //     POWhseRcptHeader.Validate("Booking Requested Date", WhseReceiptHeader."Booking Requested Date");
    //     POWhseRcptHeader.Validate("Expected Delivery Date", WhseReceiptHeader."Expected Delivery Date");
    //     POWhseRcptHeader.Validate("Expected Delivery Time", WhseReceiptHeader."Expected Delivery Time");
    //     POWhseRcptHeader.Validate("Booked Pallets", WhseReceiptHeader."Booked Pallets");
    //     POWhseRcptHeader.Validate(Lifts, WhseReceiptHeader.Lifts);
    //     POWhseRcptHeader.Validate("Loose Boxes", WhseReceiptHeader."Loose Boxes");
    //     POWhseRcptHeader.Validate("Curtain Side", WhseReceiptHeader."Curtain Side");
    //     POWhseRcptHeader.Validate(Comments, WhseReceiptHeader.Comments);
    //     POWhseRcptHeader.Validate("Receipt Status", WhseReceiptHeader."Receipt Status");
    //     POWhseRcptHeader.Validate("Actual Receipt Date", WhseReceiptHeader."Actual Receipt Date");
    //     POWhseRcptHeader.Validate("Actual Receipt Time", WhseReceiptHeader."Actual Receipt Time");
    //     POWhseRcptHeader.Insert();
    // end;


    //+++++++++++++++++++++++++++++++++++++++++//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //Step1+++ Purchase Line Location Code not mandatory++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeMandatoryFields', '', false, false)]
    local procedure OnBeforeMandatoryFields(PurchaseHeader: Record "Purchase Header")
    var
        InvtSetup: Record "Inventory Setup";
    begin
        // Check Header location if line location is not mandatory++
        // This is code for skip default error meesage for Variant code++
        Clear(G_LocationCode);
        //Clear(G_FromPOScreen);
        InvtSetup.Get();
        if not InvtSetup."Location Mandatory" then begin
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
                G_LocationCode := PurchaseHeader."Location Code";
                //G_FromPOScreen := true;


                //Check Warehouse class code missmatch+++
                // Check Header location if line location is not mandatory++
                CheckWarehouseClassCodePOHeaderlevel(PurchaseHeader);

            end;
        end;
    end;

    //Step1+++ Purchase Line Location Code mandatory++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnCheckPurchLineLocationCode', '', false, false)]
    local procedure OnCodeOnCheckPurchLineLocationCode(var PurchaseLine: Record "Purchase Line")
    var
        InvtSetup: Record "Inventory Setup";
    begin
        // Check Line location if line location is mandatory++
        // This is code for skip default error meesage for Variant code++
        Clear(G_LocationCode);
        //Clear(G_FromPOScreen);
        InvtSetup.Get();
        if InvtSetup."Location Mandatory" then begin
            if PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order then begin
                G_LocationCode := PurchaseLine."Location Code";
                //G_FromPOScreen := true;

                //Check Warehouse class code missmatch+++
                // Check Line location if line location is mandatory++
                CheckWarehouseClassCodePOLinelevel(PurchaseLine);

            end;
        end;
    end;

    //Step2++
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeIsVariantMandatory', '', false, false)]
    local procedure OnBeforeIsVariantMandatory(var IsHandled: Boolean; var Result: Boolean)
    var
        L_Location: Record Location;
    begin
        //This is code for skip default error meesage for Variant code + +
        //if G_FromPOScreen = true then begin
        if G_LocationCode <> '' then begin
            L_Location.Reset();
            if L_Location.Get(G_LocationCode) then begin
                if L_Location."Require Receive" = true then begin
                    IsHandled := true;
                    Result := false;
                end;
            end;
        end;
        Clear(G_LocationCode);
        //end;
    end;


    local procedure CheckWarehouseClassCodePOHeaderlevel(_PurchaseHeader: Record "Purchase Header")
    var
        Bin: Record Bin;
        L_PurchaseLine: Record "Purchase Line";
    begin
        L_PurchaseLine.Reset();
        L_PurchaseLine.SetRange("Document No.", _PurchaseHeader."No.");
        L_PurchaseLine.SetRange("Document Type", _PurchaseHeader."Document Type");
        L_PurchaseLine.SetRange(Type, L_PurchaseLine.Type::Item);
        if L_PurchaseLine.FindSet() then begin
            repeat
                Bin.Reset();
                Bin.SetRange("Location Code", _PurchaseHeader."Location Code");
                Bin.SetRange("Warehouse Class Code", L_PurchaseLine."Warehouse Class Code");
                if not Bin.FindFirst() then
                    Error('Warehouse class Code: %1 missmatch for Location: %2. Puchase Line No. %3', L_PurchaseLine."Warehouse Class Code", _PurchaseHeader."Location Code", L_PurchaseLine."Line No.");
            until L_PurchaseLine.Next() = 0;
        end;

    end;

    procedure CheckWarehouseClassCodePOLinelevel(_PurchaseLine: Record "Purchase Line")
    var
        Bin: Record Bin;
    begin
        Bin.Reset();
        Bin.SetRange("Location Code", _PurchaseLine."Location Code");
        Bin.SetRange("Warehouse Class Code", _PurchaseLine."Warehouse Class Code");
        if not Bin.FindFirst() then
            Error('Warehouse class Code: %1 missmatch for Location: %2. Puchase Line No. %3', _PurchaseLine."Warehouse Class Code", _PurchaseLine."Location Code", _PurchaseLine."Line No.");
    end;
    //-----------------------------------------//--------------------------------------------------------




    procedure GetUserName(UserSecurityId: Code[50]): Text[100]
    var
        Users: Record User;
    begin
        Users.Reset();
        Users.SetRange("User Security ID", UserSecurityId);
        if Users.FindFirst() then
            exit(Users."User Name");
    end;

    procedure CheckShippingAgentServiceRestriction(_ItemNo: Code[20]; _ShippingAgentCode: Code[20]; _ShippingAgentServiceCode: Code[20])
    var
        L_ShippingAgent: Record "Shipping Agent";
        L_RecItemAttValMap: Record "Item Attribute Value Mapping";
        L_ItemAttribute: Record "Item Attribute";
        L_ItemAttributeValue: Record "Item Attribute Value";

        L_WarehouseClassCode: Record "Warehouse Class";
        L_Item: Record Item;
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        // L_ShippingAgent.Reset();
        // L_ShippingAgent.SetRange(Code, _SalesHeader."Shipping Agent Code");
        // if L_ShippingAgent.FindFirst() then begin
        //     if L_ShippingAgent."Restrict CD & Fridge" = true then begin
        //         L_Item.Reset();
        //         L_Item.SetRange("No.", _SalesLine."No.");
        //         if L_Item.FindFirst() then begin
        //             L_WarehouseClassCode.Reset();
        //             L_WarehouseClassCode.SetRange(Code, L_Item."Warehouse Class Code");
        //             if L_WarehouseClassCode.FindFirst() then begin
        //                 if (L_WarehouseClassCode."Restrict CD 2,3" = true) OR (L_WarehouseClassCode."Restrict CD 4,5" = true) OR (L_WarehouseClassCode."Restrict Fridge" = true) then begin
        //                     Error('CD and Fridge items are not allowed');
        //                 end;
        //             end;
        //         end;
        //     end;
        // end;



        // L_ShippingAgent.Reset();
        // L_ShippingAgent.SetRange(Code, _SalesHeader."Shipping Agent Code");
        // if L_ShippingAgent.FindFirst() then begin
        //     if L_ShippingAgent."Restrict CD & Fridge" = true then begin
        //         L_RecItemAttValMap.Reset();
        //         L_RecItemAttValMap.SetRange("Table ID", 27);
        //         L_RecItemAttValMap.SetRange("No.", _SalesLine."No.");
        //         if L_RecItemAttValMap.FindSet() then begin
        //             repeat
        //                 L_ItemAttribute.Reset();
        //                 L_ItemAttribute.SetRange(ID, L_RecItemAttValMap."Item Attribute ID");
        //                 if L_ItemAttribute.FindFirst() then begin
        //                     if (L_ItemAttribute."CD Schedule" = true) OR (L_ItemAttribute.Fridge = true) then begin
        //                         L_ItemAttributeValue.SetRange("Attribute ID", L_ItemAttribute.ID);
        //                         L_ItemAttributeValue.SetRange(ID, L_RecItemAttValMap."Item Attribute Value ID");
        //                         if not L_ItemAttributeValue.IsEmpty() then begin
        //                             Error('CD and Fridge items are not allowed');
        //                         end;
        //                     end;
        //                 end;
        //             until L_RecItemAttValMap.Next() = 0;
        //         end;
        //     end;
        // end;

        L_RecItemAttValMap.Reset();
        L_RecItemAttValMap.SetRange("Table ID", 27);
        L_RecItemAttValMap.SetRange("No.", _ItemNo);
        if L_RecItemAttValMap.FindSet() then begin
            repeat
                L_ItemAttribute.Reset();
                L_ItemAttribute.SetRange(ID, L_RecItemAttValMap."Item Attribute ID");
                if L_ItemAttribute.FindFirst() then begin
                    L_ItemAttributeValue.SetRange("Attribute ID", L_ItemAttribute.ID);
                    L_ItemAttributeValue.SetRange(ID, L_RecItemAttValMap."Item Attribute Value ID");
                    if L_ItemAttributeValue.FindFirst() then begin
                        if L_ItemAttributeValue.Value <> '' then begin
                            ShippingAgentRestrictItem.Reset();
                            ShippingAgentRestrictItem.SetRange("Shipping Agent Code", _ShippingAgentCode);
                            ShippingAgentRestrictItem.SetRange("Shipping Agent Service Code", _ShippingAgentServiceCode);
                            ShippingAgentRestrictItem.SetRange("Attribute ID", L_ItemAttribute.ID);
                            ShippingAgentRestrictItem.SetRange("Attribute value ID", L_RecItemAttValMap."Item Attribute Value ID");
                            if ShippingAgentRestrictItem.FindFirst() then begin
                                Error('CD and Fridge items are not allowed for Shipping agent service code %1.Item No. %2', _ShippingAgentServiceCode, _ItemNo);
                            end;
                        end;
                    end;
                end;
            until L_RecItemAttValMap.Next() = 0;
        end;
    end;


    procedure SalesOrderWarningMessage(_SalesHeader: Record "Sales Header"; _SalesLine: Record "Sales Line")
    var
        L_RecItemAttValMap: Record "Item Attribute Value Mapping";
        L_ItemAttribute: Record "Item Attribute";
        L_ItemAttributeValue: Record "Item Attribute Value";
        L_SalesOrderwarningMngSetup: Record "Sales Order warning Mng. Setup";
        WareningMessage: Text[250];
        //L_Dimension: Record Dimension;
        L_DimensionEntry: Record "Dimension Set Entry";
    begin
        L_DimensionEntry.Reset();
        L_DimensionEntry.SetRange("Dimension Set ID", _SalesHeader."Dimension Set ID");
        if L_DimensionEntry.FindSet() then begin
            repeat
                //if L_Dimension."Sales warning" = true then begin
                //Validate for All attributes if Attibute is blank in sales warning management Setup++
                ValidateforAllAttribute(L_DimensionEntry);

                //Validate for Specific Attribut if Attribute is defined in sales warning management Setup++
                L_RecItemAttValMap.Reset();
                L_RecItemAttValMap.SetRange("Table ID", 27);
                L_RecItemAttValMap.SetRange("No.", _SalesLine."No.");
                if L_RecItemAttValMap.FindSet() then begin
                    repeat
                        L_ItemAttribute.Reset();
                        L_ItemAttribute.SetRange(ID, L_RecItemAttValMap."Item Attribute ID");
                        if L_ItemAttribute.FindFirst() then begin
                            L_ItemAttributeValue.SetRange("Attribute ID", L_ItemAttribute.ID);
                            L_ItemAttributeValue.SetRange(ID, L_RecItemAttValMap."Item Attribute Value ID");
                            if L_ItemAttributeValue.FindFirst() then begin
                                L_SalesOrderwarningMngSetup.Reset();
                                L_SalesOrderwarningMngSetup.SetRange("Dimension Code", L_DimensionEntry."Dimension Code");
                                L_SalesOrderwarningMngSetup.SetFilter("Dimension Value", L_DimensionEntry."Dimension Value Code");
                                //L_SalesOrderwarningMngSetup.SetRange("Attribute Value", L_ItemAttributeValue.Value);
                                L_SalesOrderwarningMngSetup.SetRange("Attribute value ID", L_ItemAttributeValue.ID);
                                L_SalesOrderwarningMngSetup.SetRange("Attribute ID", L_ItemAttributeValue."Attribute ID");
                                if L_SalesOrderwarningMngSetup.FindFirst() then begin
                                    if L_SalesOrderwarningMngSetup."Warning message" <> '' then begin
                                        if L_SalesOrderwarningMngSetup."Warning Type" = L_SalesOrderwarningMngSetup."Warning Type"::Error then
                                            Error(L_SalesOrderwarningMngSetup."Warning message")
                                        else
                                            Message(L_SalesOrderwarningMngSetup."Warning message");
                                    end;
                                end;
                            end;
                        end;
                    until L_RecItemAttValMap.Next() = 0;
                end;
            until L_DimensionEntry.Next() = 0;
        end;
    end;

    local procedure ValidateforAllAttribute(_DimensionEntry: Record "Dimension Set Entry")
    var
        L_SalesOrderwarningMngSetup: Record "Sales Order warning Mng. Setup";
    begin
        L_SalesOrderwarningMngSetup.Reset();
        L_SalesOrderwarningMngSetup.SetRange("Dimension Code", _DimensionEntry."Dimension Code");
        L_SalesOrderwarningMngSetup.SetRange("Dimension Value", _DimensionEntry."Dimension Value Code");
        L_SalesOrderwarningMngSetup.SetFilter("Attribute Name", '%1', '');
        if L_SalesOrderwarningMngSetup.FindFirst() then begin
            if L_SalesOrderwarningMngSetup."Warning message" <> '' then begin
                if L_SalesOrderwarningMngSetup."Warning Type" = L_SalesOrderwarningMngSetup."Warning Type"::Error then
                    Error(L_SalesOrderwarningMngSetup."Warning message")
                else
                    Message(L_SalesOrderwarningMngSetup."Warning message");
            end;
        end;
    end;



    //Multiple Customer Price Group++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line - Price", 'OnAfterSetPrice', '', false, false)]
    local procedure OnAfterSetPrice(AmountType: Enum "Price Amount Type"; PriceListLine: Record "Price List Line"; var SalesLine: Record "Sales Line")
    var
        L_PriceListLine: Record "Price List Line";
        L_Customer: Record Customer;
        L_SalesHeader: Record "Sales Header";
        i: Integer;
        Loop: Integer;
        L_Item: Record Item;
        L_PriceFound: Boolean;
    begin
        If L_SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then;

        if PriceListLine."Source Type" = PriceListLine."Source Type"::Customer then
            exit;

        Clear(L_PriceFound);
        If L_Customer.Get(L_SalesHeader."Bill-to Customer No.") then begin
            //1st Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', WorkDate(), 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', WorkDate(), 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" < SalesLine.Quantity then begin
                            SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        L_PriceFound := true;
                    end;
                end;
            end;

            //2nd Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 2");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', WorkDate(), 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', WorkDate(), 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" < SalesLine.Quantity then begin
                            SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        L_PriceFound := true;
                    end;
                end
            end;

            //3rd Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 3");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', WorkDate(), 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', WorkDate(), 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" < SalesLine.Quantity then begin
                            SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        L_PriceFound := true;
                    end;
                end
            end;

            //4th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 4");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', WorkDate(), 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', WorkDate(), 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" < SalesLine.Quantity then begin
                            SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        L_PriceFound := true;
                    end;
                end
            end;

            //5th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 5");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', WorkDate(), 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', WorkDate(), 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" < SalesLine.Quantity then begin
                            SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        L_PriceFound := true;
                    end;
                end
            end;

            //If Price List not found
            if L_PriceFound = false then begin
                IF L_Item.Get(SalesLine."No.") then
                    SalesLine.Validate("Unit Price", L_Item."Unit Price");
            end;

            // L_PriceListLine.Reset();
            // L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            // L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            // L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            // L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            // L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group");
            // L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            // //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            // L_PriceListLine.SetFilter("Ending Date", '>%1', WorkDate());
            // L_PriceListLine.SetFilter("Starting Date", '<%1', WorkDate());
            // if L_PriceListLine.FindFirst() then begin
            //     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price")
            // end else begin
            //     L_PriceListLine.Reset();
            //     L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //     L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //     L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //     L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //     L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 2");
            //     L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //     //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //     L_PriceListLine.SetFilter("Ending Date", '>%1', WorkDate());
            //     L_PriceListLine.SetFilter("Starting Date", '<%1', WorkDate());
            //     if L_PriceListLine.FindFirst() then begin
            //         SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //     end else begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 3");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1', WorkDate());
            //         L_PriceListLine.SetFilter("Starting Date", '<%1', WorkDate());
            //         if L_PriceListLine.FindFirst() then begin
            //             SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //         end else begin
            //             L_PriceListLine.Reset();
            //             L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //             L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //             L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //             L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //             L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 4");
            //             L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //             //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //             L_PriceListLine.SetFilter("Ending Date", '>%1', WorkDate());
            //             L_PriceListLine.SetFilter("Starting Date", '<%1', WorkDate());
            //             if L_PriceListLine.FindFirst() then begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //             end else begin
            //                 L_PriceListLine.Reset();
            //                 L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //                 L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //                 L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //                 L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //                 L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 5");
            //                 L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //                 //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //                 L_PriceListLine.SetFilter("Ending Date", '>%1', WorkDate());
            //                 L_PriceListLine.SetFilter("Starting Date", '<%1', WorkDate());
            //                 if L_PriceListLine.FindFirst() then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 end else begin
            //                     IF L_Item.Get(SalesLine."No.") then
            //                         SalesLine.Validate("Unit Price", L_Item."Unit Price");
            //                 end;
            //             end;
            //         end;
            //     end;
            // end;
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualReleaseProcedure', '', false, false)]
    local procedure OnBeforePerformManualReleaseProcedure(var SalesHeader: Record "Sales Header")
    var
        L_SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if SalesHeader."Min Order Value" > 0 then begin
                SalesHeader.CalcFields(Amount);
                if SalesHeader.Amount < SalesHeader."Min Order Value" then
                    Error('Total order amount %1 is less than Min Order Value %2', SalesHeader.Amount, SalesHeader."Min Order Value");
            end;
        end;

        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
            L_SalesLine.Reset();
            L_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            L_SalesLine.SetRange("Document No.", SalesHeader."No.");
            L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
            L_SalesLine.SetFilter("Return Reason Code", '%1', '');
            if L_SalesLine.FindFirst() then
                L_SalesLine.TestField("Return Reason Code");

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCheckSalesApprovalPossible', '', false, false)]
    local procedure OnBeforeCheckSalesApprovalPossible(var SalesHeader: Record "Sales Header")
    var
        L_SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if SalesHeader."Min Order Value" > 0 then begin
                SalesHeader.CalcFields(Amount);
                if SalesHeader.Amount < SalesHeader."Min Order Value" then
                    Error('Total order amount %1 is less than Min Order Value %2', SalesHeader.Amount, SalesHeader."Min Order Value");
            end;
        end;


        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
            L_SalesLine.Reset();
            L_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            L_SalesLine.SetRange("Document No.", SalesHeader."No.");
            L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
            L_SalesLine.SetFilter("Return Reason Code", '%1', '');
            if L_SalesLine.FindFirst() then
                L_SalesLine.TestField("Return Reason Code");

        end;
    end;

}