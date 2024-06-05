xmlport 85001 "Upload Purchase Order"
{
    Format = VariableText;
    UseRequestPage = false;
    Direction = Import;

    schema
    {
        textelement(Tables)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Purchaseheader';
                // SourceTableView = SORTING(Number)
                //                   WHERE(Number = CONST(1));
                UseTemporary = false;

                textelement(Document)
                {
                    XmlName = 'DocumentNo';
                }
                textelement(EmailAddress)
                {

                }
                textelement(EmailAddress2)
                {

                }
                textelement(EmailAddress3)
                {

                }
                textelement(CompanyNumber)
                {

                }
                textelement(Deliveryaddress)
                {

                }
                textelement(DeliveryTel)
                {

                }
                textelement(Suppliercode)
                {

                }
                textelement(SupplierAddress)
                {

                }
                textelement(SupplierTel)
                {

                }
                textelement(SupplierFax)
                {

                }
                textelement(Poreference)
                {

                }
                textelement(DocumentDate)
                {

                }
                textelement(DueDate)
                {

                }
                textelement(PageNumber)
                {

                }
                textelement(OPCode)
                {

                }
                textelement(LineNumber)
                {

                }
                textelement(Ourcode)
                {

                }
                textelement(EAN)
                {

                }
                textelement(CaseBarcode)
                {

                }
                textelement(Quantity)
                {

                }
                textelement(Size)
                {

                }
                textelement(Description)
                {

                }
                textelement(Unitprize)
                {

                }
                textelement(LinePrice)
                {

                }

                trigger OnAfterInsertRecord()
                var
                    ReleasePurchaseDoc: Codeunit "Release Purchase Document";
                    EntryNU: Integer;
                    Recvendor: Record Vendor;
                    RecItem: Record Item;
                begin
                    if Headerfound = false then begin
                        Headerfound := true;
                        currXMLport.Skip();
                    end;

                    P_Location.Reset();
                    CLEAR(supplier_code);
                    Clear(DocumentNoD);
                    Clear(Document_Date);
                    Clear(Delivery_address);
                    Clear(PO_Reference);
                    Clear(Our_code);
                    Clear(Quantity_);
                    Clear(Unit_prize);
                    Clear(j);
                    // IF (UnitCostT <> '') THEN
                    //     EVALUATE(UnitCostD, UnitCostT);

                    If (Document <> '') then
                        Evaluate(DocumentNoD, Document);

                    if (Deliveryaddress <> '') then
                        Evaluate(Delivery_address, Deliveryaddress);

                    if (Suppliercode <> '') then
                        Evaluate(supplier_code, Suppliercode);

                    if (Poreference <> '') then
                        Evaluate(PO_Reference, Poreference);

                    if (DocumentDate <> '') then
                        Evaluate(Document_Date, DocumentDate);

                    if (Ourcode <> '') then
                        Evaluate(Our_code, Ourcode);

                    if (Quantity <> '') then
                        Evaluate(Quantity_, Quantity);

                    if (Unitprize <> '') then
                        Evaluate(Unit_prize, Unitprize);
                    Clear(Skipentry);

                    if i = 0 then begin
                        excelbuffer.NewRow();
                        excelbuffer.AddColumn('Document No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        excelbuffer.AddColumn('Our code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        excelbuffer.AddColumn('Supplier code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        excelbuffer.AddColumn('Status1', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        excelbuffer.AddColumn('Status2', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        excelbuffer.AddColumn('Status3', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        excelbuffer.AddColumn('Status4', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        excelbuffer.AddColumn('Status5', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                    end;



                    excelbuffer.NewRow();
                    excelbuffer.AddColumn(DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                    excelbuffer.AddColumn(Our_code, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                    excelbuffer.AddColumn(supplier_code, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);

                    if DocumentNoD = '' then begin
                        Skipentry := true;
                        //excelbuffer.NewRow();
                        excelbuffer.AddColumn('Document number Is blank. Item No:' + Our_code, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        j := j + 1;
                    end;

                    if Delivery_address = '' then begin
                        Skipentry := true;
                        //excelbuffer.NewRow();
                        excelbuffer.AddColumn('Delivery address Is blank. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        j := j + 1;
                    end else begin
                        P_Location.Reset();
                        P_Location.SetFilter(Deliveryadd, Delivery_address);
                        if P_Location.FindFirst() then begin

                        end else begin
                            P_Location2.Reset();
                            P_Location2.SetFilter(Deliveryadd2, Delivery_address);
                            if P_Location2.FindFirst() then begin

                            end else begin
                                Skipentry := true;
                                //excelbuffer.NewRow();
                                excelbuffer.AddColumn(Delivery_address + ' Is invalid. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                                j := j + 1;
                            end;
                        end;
                    end;

                    if supplier_code = '' then begin
                        Skipentry := true;
                        //excelbuffer.NewRow();
                        excelbuffer.AddColumn('supplier code Is blank. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        j := j + 1;
                    end else begin
                        Recvendor.Reset();
                        Recvendor.SetRange("No.", supplier_code);
                        if Recvendor.FindFirst() then begin

                        end else begin
                            Skipentry := true;
                            //excelbuffer.NewRow();
                            excelbuffer.AddColumn(supplier_code + ' Is Invalid. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                            j := j + 1;
                        end;
                    end;

                    if DocumentDate = '' then begin
                        Skipentry := true;
                        //excelbuffer.NewRow();
                        excelbuffer.AddColumn('Document Date Is blank. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        j := j + 1;
                    end;

                    if Our_code = '' then begin
                        Skipentry := true;
                        //excelbuffer.NewRow();
                        excelbuffer.AddColumn('Our code Is blank. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        j := j + 1;
                    end else begin
                        RecItem.Reset();
                        RecItem.SetRange("No.", Our_code);
                        if RecItem.FindFirst() then begin

                        end else begin
                            Skipentry := true;
                            //excelbuffer.NewRow();
                            excelbuffer.AddColumn(Our_code + ' Is invalid. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                            j := j + 1;
                        end;
                    end;

                    if Quantity_ <= 0 then begin
                        Skipentry := true;
                        excelbuffer.AddColumn('Quantity Is invalid. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                        j := j + 1;
                    end;

                    // if Unit_prize < 0 then begin
                    //     Skipentry := true;
                    //     excelbuffer.AddColumn('Unit Price Is invalid. Document ID:' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                    // end;

                    if Skipentry = false then begin
                        excelbuffer.AddColumn('No Error', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
                    end;

                    if k < j then
                        k := j;

                    i += 1;
                    RecILETemp.Init();
                    RecILETemp."Entry No." := i;
                    RecILETemp."Document No." := DocumentNoD;
                    RecILETemp."Del Adress Temp" := Delivery_address;
                    RecILETemp."Source No." := supplier_code;
                    RecILETemp."Document Date" := Document_Date;
                    RecILETemp."Item No." := Our_code;
                    RecILETemp.Quantity := Quantity_;
                    RecILETemp."Qty. per Unit of Measure" := Unit_prize;
                    RecILETemp."Your ref Temp" := PO_Reference;
                    if Skipentry = true then
                        RecILETemp.Open := true;
                    RecILETemp.Insert();
                    Commit();
                    //     G_PurchHeader.Reset();
                    //     G_PurchHeader.SetRange("No.", DocumentNoD);
                    //     G_PurchHeader.SetRange("Document Type", G_PurchHeader."Document Type"::Order);
                    //     if not G_PurchHeader.FindFirst() then begin

                    //         RecPosPuRcpt.reset;
                    //         RecPosPuRcpt.SetRange("Order No.", DocumentNoD);
                    //         if RecPosPuRcpt.FindFirst() then begin
                    //             currXMLport.Skip();
                    //         end;

                    //         purchaseheader.Init();
                    //         purchaseheader."Document Type" := purchaseheader."Document Type"::Order;
                    //         purchaseheader.Validate("No.", DocumentNoD);
                    //         purchaseheader.Validate("Buy-from Vendor No.", supplier_code);
                    //         purchaseheader.Validate("Your Reference", PO_Reference);
                    //         purchaseheader.Validate("Document Date", Document_Date);

                    //         purchaseheader.Insert(true);

                    //         PurchaseLine.Init();
                    //         // PurchaseLine."Document No." := purchaseheader."No.";
                    //         PurchaseLine.Validate("Document Type", purchaseheader."Document Type");
                    //         PurchaseLine.Validate("Document No.", DocumentNoD);
                    //         PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                    //         PurchaseLine.Validate("No.", Our_code);

                    //         G_PurchaseLine.Reset();
                    //         G_PurchaseLine.SetRange("Document No.", purchaseheader."No.");
                    //         G_PurchaseLine.SetRange("Document Type", purchaseheader."Document Type");
                    //         G_PurchaseLine.SetRange(type, G_PurchaseLine.Type::Item);
                    //         if G_PurchaseLine.FindLast() then
                    //             PurchaseLine.Validate("Line No.", G_PurchaseLine."Line No." + 10000)
                    //         else
                    //             PurchaseLine.Validate("Line No.", 10000);



                    //         P_Location.Reset();
                    //         P_Location.SetFilter(Deliveryadd, Delivery_address);
                    //         if P_Location.FindFirst() then
                    //             PurchaseLine.Validate("Location Code", P_Location.Code);
                    //         PurchaseLine.Validate(Quantity, Quantity_);
                    //         PurchaseLine.Validate("Direct Unit Cost", Unit_prize);
                    //         PurchaseLine.Insert(true);

                    //         purchaseheader."Location Code" := PurchaseLine."Location Code";
                    //         purchaseheader.Modify(true);
                    //         Commit();

                    //         tempRecPurchHeader.Reset();
                    //         tempRecPurchHeader.SetRange("No.", DocumentNoD);
                    //         if not tempRecPurchHeader.FindFirst() then begin
                    //             tempRecPurchHeader.Init();
                    //             tempRecPurchHeader."Document Type" := purchaseheader."Document Type"::Order;
                    //             tempRecPurchHeader.Validate("No.", DocumentNoD);
                    //             tempRecPurchHeader.Insert(true);
                    //             Commit();
                    //         end;

                    //         //Message('Order completed1');
                    //     end else begin
                    //         // G_PurchHeader.Reset();
                    //         // G_PurchHeader.SetRange("No.", DocumentNoD);
                    //         // G_PurchHeader.SetRange("Document Type", G_PurchHeader."Document Type"::Order);
                    //         // if G_PurchHeader.FindFirst() then begin
                    //         if G_PurchHeader.Status <> G_PurchHeader.Status::Open then begin
                    //             ReleasePurchaseDoc.Reopen(G_PurchHeader);
                    //             Commit();
                    //         end;

                    //         PurchaseLine.Init();
                    //         // PurchaseLine."Document No." := purchaseheader."No.";
                    //         PurchaseLine.Validate("Document Type", G_PurchHeader."Document Type");
                    //         PurchaseLine.Validate("Document No.", DocumentNoD);
                    //         PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                    //         PurchaseLine.Validate("No.", Our_code);

                    //         G_PurchaseLine.Reset();
                    //         G_PurchaseLine.SetRange("Document No.", G_PurchHeader."No.");
                    //         G_PurchaseLine.SetRange("Document Type", G_PurchHeader."Document Type");
                    //         G_PurchaseLine.SetRange(type, G_PurchaseLine.Type::Item);
                    //         if G_PurchaseLine.FindLast() then
                    //             PurchaseLine.Validate("Line No.", G_PurchaseLine."Line No." + 10000)
                    //         else
                    //             PurchaseLine.Validate("Line No.", 10000);

                    //         PurchaseLine.Validate(Quantity, Quantity_);
                    //         PurchaseLine.Validate("Direct Unit Cost", Unit_prize);
                    //         P_Location.Reset();
                    //         P_Location.SetFilter(Deliveryadd, Delivery_address);
                    //         if P_Location.FindFirst() then
                    //             PurchaseLine.Validate("Location Code", P_Location.Code);
                    //         PurchaseLine.Validate(Quantity, Quantity_);
                    //         PurchaseLine.Validate("Direct Unit Cost", Unit_prize);
                    //         PurchaseLine.Insert(true);
                    //         purchaseheader."Location Code" := PurchaseLine."Location Code";
                    //         purchaseheader.Modify(true);
                    //         Commit();
                    //         // Message('Order completed2');
                    //         //end;

                    //         tempRecPurchHeader.Reset();
                    //         tempRecPurchHeader.SetRange("No.", DocumentNoD);
                    //         if not tempRecPurchHeader.FindFirst() then begin
                    //             tempRecPurchHeader.Init();
                    //             tempRecPurchHeader."Document Type" := purchaseheader."Document Type"::Order;
                    //             tempRecPurchHeader.Validate("No.", DocumentNoD);
                    //             tempRecPurchHeader.Insert(true);
                    //             Commit();
                    //         end;
                    //     end;


                end;


            }
        }


    }
    trigger OnPreXmlPort()
    begin
        Line := 10000;
        Headerfound := false;
        tempRecPurchHeader.DeleteAll();
        RecILETemp.DeleteAll();
        RecILETemp2.DeleteAll();
        excelbuffer.DeleteAll();
        Clear(i);
    end;

    trigger OnPostXmlPort()
    var
        wheseRcptLine: Page "Whse. Receipt Lines";
        WhserptLineTable: Record "Warehouse Receipt Line";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        Location: Record Location;
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        RelPurchHeader: Record "Purchase Header";
        s: Integer;
        t: Integer;
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        RecRef: RecordRef;
    begin
        RecILETemp.Reset();
        RecILETemp.SetRange(Open, true);
        if RecILETemp.FindSet() then begin
            repeat
                RecILETemp2.Init();
                RecILETemp2."Entry No." := RecILETemp."Entry No.";
                RecILETemp2."Document No." := RecILETemp."Document No.";
                RecILETemp2.Insert();
            //Message(RecILETemp."Document No." + '  ' + ' Skip' + Format(RecILETemp.Open));
            until RecILETemp.Next = 0;
        end;
        Commit();

        RecILETemp.Reset();
        RecILETemp.SetRange(Open, false);
        if RecILETemp.FindSet() then begin
            repeat

                RecILETemp2.Reset();
                RecILETemp2.SetRange("Document No.", RecILETemp."Document No.");
                if RecILETemp2.FindFirst() then begin

                end else begin
                    //RecILETemp.CalcFields("Purchase Amount (Actual)");
                    CreateOrder(RecILETemp."Document No.", RecILETemp."Source No.",
                    RecILETemp."Your ref Temp", RecILETemp."Document Date", RecILETemp."Item No.", RecILETemp."Del Adress Temp", RecILETemp.Quantity, RecILETemp."Qty. per Unit of Measure");
                    //Message(RecILETemp."Document No." + '  ' + ' Skip' + Format(RecILETemp.Open));
                end;
            until RecILETemp.Next = 0;
        end;

        tempRecPurchHeader.Reset();
        if tempRecPurchHeader.FindSet() then begin
            repeat
                RelPurchHeader.Reset();
                RelPurchHeader.SetRange("No.", tempRecPurchHeader."No.");
                if RelPurchHeader.FindFirst() then begin
                    //ReleasePurchaseDoc.PerformManualRelease(RelPurchHeader);
                    //BatchProcessingMgt.BatchProcess(tempRecPurchHeader, Codeunit::"Purchase Manual Release", Enum::"Error Handling Options"::"Show Notification", 1, 0);

                    RecRef.GetTable(RelPurchHeader);
                    BatchProcessingMgt.SetProcessingCodeunit(Codeunit::"Purchase Manual Release");
                    BatchProcessingMgt.BatchProcess(RecRef, Enum::"Error Handling Options"::"Show Notification");
                end;
            until tempRecPurchHeader.Next = 0;
        end;
        Commit();

        tempRecPurchHeader.Reset();
        if tempRecPurchHeader.FindSet() then begin
            repeat
                RelPurchHeader.Reset();
                RelPurchHeader.SetRange("No.", tempRecPurchHeader."No.");
                RelPurchHeader.SetRange(Status, RelPurchHeader.Status::Released);
                if RelPurchHeader.FindFirst() then begin
                    if RelPurchHeader."Location Code" <> '' then begin
                        Location.Get(RelPurchHeader."Location Code");
                        if Location."Require Receive" = true then begin
                            GetSourceDocInbound.CreateFromPurchOrderHideDialog(RelPurchHeader);
                            Commit();
                        end else begin
                            if Location."Require Put-away" = true then begin
                                CreateInvtPutAwayPick(RelPurchHeader);
                            end;
                            Commit();
                        end;

                    end;
                end;
            until tempRecPurchHeader.Next = 0;
        end;

        Clear(s);
        Clear(t);
        RecILETemp.Reset();
        RecILETemp.SetRange(Open, true);
        if RecILETemp.FindFirst() then begin
            ////k := k + 4;
            // s := 4;
            // t := 1;
            // if k > 0 then begin
            //     repeat
            //         s := s + 1;
            //         t := t + 1;
            //         excelbuffer.EnterCell(excelbuffer, 1, s, 'Status ' + format(t), false, false, false);
            //         K := k - 1;
            //     until k = 1;
            // end;


            excelbuffer.CreateNewBook('Errors');
            excelbuffer.WriteSheet('Errors', CompanyName, UserId);
            excelbuffer.CloseBook();
            excelbuffer.SetFriendlyFilename(StrSubstNo('Error', CurrentDateTime, UserId));
            excelbuffer.OpenExcel();
        end

    end;


    procedure CreateInvtPutAwayPick(RecPurchHdrP: Record "Purchase Header")
    var
        WhseRequest: Record "Warehouse Request";
        PUTRE: Report "Create Invt Put-away/Pick/Mvmt";
    begin

        WhseRequest.Reset();
        WhseRequest.SetCurrentKey("Source Document", "Source No.");
        case RecPurchHdrP."Document Type" of
            RecPurchHdrP."Document Type"::Order:
                WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Purchase Order");
            RecPurchHdrP."Document Type"::"Return Order":
                WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Purchase Return Order");
        end;
        WhseRequest.SetRange("Source No.", RecPurchHdrP."No.");
        PUTRE.InitializeRequest(true, false, false, false, false);
        PUTRE.SetTableView(WhseRequest);
        PUTRE.UseRequestPage(false);
        PUTRE.SuppressMessages(true);
        PUTRE.Run();
        //PUTRE.SuppressMessages(false);
        //REPORT.RunModal(REPORT::"Create Invt Put-away/Pick/Mvmt", false, false, WhseRequest);
    end;

    procedure CreateOrder(DocumentNoD1: Text; supplier_code1: Text; PO_Reference1: text; Document_Date1: Date; Our_code1: text; Delivery_addressn: Text; Quantity_1: Decimal; Unit_prize1: Decimal)
    var
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        L_ItemVendor: Record "Item Vendor";
    begin
        G_PurchHeader.Reset();
        G_PurchHeader.SetRange("No.", DocumentNoD1);
        G_PurchHeader.SetRange("Document Type", G_PurchHeader."Document Type"::Order);
        if not G_PurchHeader.FindFirst() then begin

            RecPosPuRcpt.reset;
            RecPosPuRcpt.SetRange("Order No.", DocumentNoD1);
            if RecPosPuRcpt.FindFirst() then begin
                exit;
            end else begin

            end;

            purchaseheader.Init();
            purchaseheader."Document Type" := purchaseheader."Document Type"::Order;
            purchaseheader.Validate("No.", DocumentNoD1);
            purchaseheader.Validate("Buy-from Vendor No.", supplier_code1);
            purchaseheader.Validate("Your Reference", PO_Reference1);
            purchaseheader.Validate("Document Date", Document_Date1);
            purchaseheader."Sheet Name" := currXMLport.Filename;

            purchaseheader.Insert(true);

            PurchaseLine.Init();
            // PurchaseLine."Document No." := purchaseheader."No.";
            PurchaseLine.Validate("Document Type", purchaseheader."Document Type");
            PurchaseLine.Validate("Document No.", DocumentNoD1);
            PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
            PurchaseLine.Validate("No.", Our_code1);

            G_PurchaseLine.Reset();
            G_PurchaseLine.SetRange("Document No.", purchaseheader."No.");
            G_PurchaseLine.SetRange("Document Type", purchaseheader."Document Type");
            G_PurchaseLine.SetRange(type, G_PurchaseLine.Type::Item);
            if G_PurchaseLine.FindLast() then
                PurchaseLine.Validate("Line No.", G_PurchaseLine."Line No." + 10000)
            else
                PurchaseLine.Validate("Line No.", 10000);



            P_Location.Reset();
            P_Location.SetFilter(Deliveryadd, Delivery_addressn);
            if P_Location.FindFirst() then begin
                PurchaseLine.Validate("Location Code", P_Location.Code);
            end else begin
                P_Location2.Reset();
                P_Location2.SetFilter(Deliveryadd2, Delivery_addressn);
                if P_Location2.FindFirst() then begin
                    PurchaseLine.Validate("Location Code", P_Location2.Code);
                end;
            end;

            PurchaseLine.Validate(Quantity, Quantity_1);
            PurchaseLine.Validate("Direct Unit Cost", Unit_prize1);

            L_ItemVendor.Reset();
            L_ItemVendor.SetRange("Vendor No.", supplier_code1);
            L_ItemVendor.SetRange("Item No.", Our_code1);
            if L_ItemVendor.FindFirst() then begin
                if L_ItemVendor."Variant Code" <> '' then
                    PurchaseLine.Validate("Variant Code", L_ItemVendor."Variant Code");
            end;

            PurchaseLine.Insert(true);

            purchaseheader."Location Code" := PurchaseLine."Location Code";
            purchaseheader.Modify(true);
            //Commit(); //Temporary Removed++

            tempRecPurchHeader.Reset();
            tempRecPurchHeader.SetRange("No.", DocumentNoD1);
            if not tempRecPurchHeader.FindFirst() then begin
                tempRecPurchHeader.Init();
                tempRecPurchHeader."Document Type" := purchaseheader."Document Type"::Order;
                tempRecPurchHeader.Validate("No.", DocumentNoD1);
                tempRecPurchHeader.Insert(true);
                //Commit(); //Temporary Removed++
            end;

            //Message('Order completed1');
        end else begin
            // G_PurchHeader.Reset();
            // G_PurchHeader.SetRange("No.", DocumentNoD);
            // G_PurchHeader.SetRange("Document Type", G_PurchHeader."Document Type"::Order);
            // if G_PurchHeader.FindFirst() then begin

            // FindPurchaseLine.Reset();
            // FindPurchaseLine.SetRange("Document No.", DocumentNoD1);
            // FindPurchaseLine.SetRange("Document Type", FindPurchaseLine."Document Type"::Order);
            // FindPurchaseLine.SetRange(Type, FindPurchaseLine.Type::Item);
            // FindPurchaseLine.SetRange("No.", Our_code1);
            // FindPurchaseLine.SetRange(Quantity, Quantity_1);
            // FindPurchaseLine.SetRange("Direct Unit Cost", Unit_prize1);
            // If FindPurchaseLine.FindFirst() then begin

            // end else begin


            if G_PurchHeader.Status <> G_PurchHeader.Status::Open then begin
                ReleasePurchaseDoc.Reopen(G_PurchHeader);
                //Commit(); //Temporary Removed++
            end;

            PurchaseLine.Init();
            // PurchaseLine."Document No." := purchaseheader."No.";
            PurchaseLine.Validate("Document Type", G_PurchHeader."Document Type");
            PurchaseLine.Validate("Document No.", DocumentNoD1);
            PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
            PurchaseLine.Validate("No.", Our_code1);

            G_PurchaseLine.Reset();
            G_PurchaseLine.SetRange("Document No.", G_PurchHeader."No.");
            G_PurchaseLine.SetRange("Document Type", G_PurchHeader."Document Type");
            G_PurchaseLine.SetRange(type, G_PurchaseLine.Type::Item);
            if G_PurchaseLine.FindLast() then
                PurchaseLine.Validate("Line No.", G_PurchaseLine."Line No." + 10000)
            else
                PurchaseLine.Validate("Line No.", 10000);



            P_Location.Reset();
            P_Location.SetFilter(Deliveryadd, Delivery_addressn);
            if P_Location.FindFirst() then
                PurchaseLine.Validate("Location Code", P_Location.Code);
            PurchaseLine.Validate(Quantity, Quantity_1);
            PurchaseLine.Validate("Direct Unit Cost", Unit_prize1);

            L_ItemVendor.Reset();
            L_ItemVendor.SetRange("Vendor No.", supplier_code1);
            L_ItemVendor.SetRange("Item No.", Our_code1);
            if L_ItemVendor.FindFirst() then begin
                if L_ItemVendor."Variant Code" <> '' then
                    PurchaseLine.Validate("Variant Code", L_ItemVendor."Variant Code");
            end;

            PurchaseLine.Insert(true);
            //purchaseheader."Location Code" := PurchaseLine."Location Code";
            //purchaseheader.Modify(true);
            //Commit(); //Temporary Removed++
            // Message('Order completed2');
            //end;

            tempRecPurchHeader.Reset();
            tempRecPurchHeader.SetRange("No.", DocumentNoD1);
            if not tempRecPurchHeader.FindFirst() then begin
                tempRecPurchHeader.Init();
                tempRecPurchHeader."Document Type" := purchaseheader."Document Type"::Order;
                tempRecPurchHeader.Validate("No.", DocumentNoD1);
                tempRecPurchHeader.Insert(true);
                //Commit(); //Temporary Removed++
            end;


        end;

        // end;

    end;

    procedure SampleTemplate()
    var
        //excelbuffer2: Record "Excel Buffer" temporary;
        Csvbuffer: Record "CSV Buffer" temporary;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;
    begin
        Csvbuffer.DeleteAll();
        Csvbuffer.InsertEntry(1, 1, 'Document Number');
        Csvbuffer.InsertEntry(1, 2, 'Email Address');
        Csvbuffer.InsertEntry(1, 3, 'Email Address2');
        Csvbuffer.InsertEntry(1, 4, 'Email Address3');
        Csvbuffer.InsertEntry(1, 5, 'Company Number');
        Csvbuffer.InsertEntry(1, 6, 'Delivery Address');
        Csvbuffer.InsertEntry(1, 7, 'Delivery Tel');
        Csvbuffer.InsertEntry(1, 8, 'Supplier Code');
        Csvbuffer.InsertEntry(1, 9, 'Supplier Address');
        Csvbuffer.InsertEntry(1, 10, 'Supplier Tel');
        Csvbuffer.InsertEntry(1, 11, 'Supplier Fax');
        Csvbuffer.InsertEntry(1, 12, 'PO Reference');
        Csvbuffer.InsertEntry(1, 13, 'Document Date');
        Csvbuffer.InsertEntry(1, 14, 'Due Date');
        Csvbuffer.InsertEntry(1, 15, 'Page Number');
        Csvbuffer.InsertEntry(1, 16, 'OP Code');
        Csvbuffer.InsertEntry(1, 17, 'Line Number');
        Csvbuffer.InsertEntry(1, 18, 'Our Code');
        Csvbuffer.InsertEntry(1, 19, 'EAN');
        Csvbuffer.InsertEntry(1, 20, 'Case Barcode');
        Csvbuffer.InsertEntry(1, 21, 'Quantity');
        Csvbuffer.InsertEntry(1, 22, 'Size');
        Csvbuffer.InsertEntry(1, 23, 'Description');
        Csvbuffer.InsertEntry(1, 24, 'Unit Price');
        Csvbuffer.InsertEntry(1, 25, 'Line Price');


        Csvbuffer.SaveDataToBlob(TempBLOB, ',');
        TempBLOB.CreateOutStream(outs);
        TempBLOB.CreateInStream(ins);
        filename := 'SamplePOTemplate.csv';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
        // excelbuffer2.DeleteAll();
        // excelbuffer2.AddColumn('Document Number' + DocumentNoD, false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        // excelbuffer2.CreateNewBook('Sample Template');
        // excelbuffer2.WriteSheet('Sample Template', CompanyName, UserId);
        // excelbuffer2.CloseBook();
        // excelbuffer2.SetFriendlyFilename(StrSubstNo('Sample Template', CurrentDateTime, UserId));
        // excelbuffer2.OpenExcel();
    end;

    var
        Line: Integer;
        purchaseheader: Record "Purchase Header";
        G_PurchHeader: Record "Purchase Header";
        G_PurchaseLine: Record "Purchase Line";
        PurchaseLine: Record "Purchase Line";
        FindPurchaseLine: Record "Purchase Line";
        DocumentNoD: Code[100];
        Document_Date: Date;
        supplier_code: code[100];
        Delivery_address: Text[250];
        //Delivery_address1: Text;
        PO_Reference: Code[100];
        P_Location: Record Location;
        P_Location2: Record Location;
        Our_code: code[100];
        Quantity_: Decimal;
        Unit_prize: Decimal;
        Headerfound: Boolean;
        RecPosPuRcpt: Record "Purch. Rcpt. Header";
        tempRecPurchHeader: Record "Purchase Header" temporary;
        RecILETemp: Record "Item Ledger Entry" temporary;
        i: Integer;
        j: Integer;
        k: Integer;
        Skipentry: Boolean;
        RecILETemp2: Record "Item Ledger Entry" temporary;
        excelbuffer: Record "Excel Buffer" temporary;
}