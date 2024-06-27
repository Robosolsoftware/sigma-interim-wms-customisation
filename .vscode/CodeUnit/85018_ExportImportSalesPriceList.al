codeunit 85018 "Export & Import Sales Price"
{
    trigger OnRun()
    begin
        ImportSalesPrice();
    end;

    var
        myInt: Integer;
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        DialoCaption: Text;
        UploadResult: Boolean;
        InStr: InStream;
        FileName: Text[100];
        SheetName: Text[100];
        RowNo: Integer;
        L_PriceListHeader: Record "Price List Header";
        L_SalesPriceListLine: Record "Price List line";
        ErrorLog_excelbuffer: Record "Excel Buffer" temporary;

    procedure ImportSalesPrice()
    var
        L_Statuse: Enum "Price Status";
        L_MinQty: Decimal;
        L_UnitPrice: Decimal;
        L_LineDiscount: Decimal;
        L_BaseVolume: Decimal;
        L_CostUnitThereafter: Decimal;
        L_Rebate: Decimal;
        L_StartDate: Date;
        L_EndDate: Date;
        L_ErrorFound: Boolean;
        PriceListManagement: Codeunit "Price List Management";
        L_IfErrorExit: Boolean;
        Temp_PriceListLine: Record "Price List Line" temporary; //Dont Remove Temp Property++
        L_PriceListLine: Record "Price List Line";
        L_PriceListHeader: Record "Price List Header";
        L_Item: Record Item;
    begin
        Temp_PriceListLine.DeleteAll();
        ErrorLog_excelbuffer.DeleteAll();
        Clear(L_ErrorFound);
        Clear(L_IfErrorExit);

        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialoCaption := 'Select File to upload';

        UploadResult := UploadIntoStream(DialoCaption, '', '', FileName, InStr);

        if FileName <> '' then
            SheetName := Rec_ExcelBuffer.SelectSheetsNameStream(InStr)
        else
            exit;

        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.OpenBookStream(InStr, SheetName);
        Rec_ExcelBuffer.ReadSheet();
        Commit();

        //Finiding Total No of Rows to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        If Rec_ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until Rec_ExcelBuffer.Next() = 0;

        //Finiding Total No of Columns to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;

        #Region Create Excel Header for Error++
        ErrorLog_excelbuffer.NewRow();
        ErrorLog_excelbuffer.AddColumn('Sales Price List Code', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Sales Price Description', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Item No.', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Error', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        #EndRegion Create Excel Header for Error++

        for RowNo := 2 to Rows do begin
            Clear(L_ErrorFound);

            #Region Create Temp Record to check dulicate line in the excel++
            Temp_PriceListLine.Reset();
            Temp_PriceListLine.SetRange("Price List Code", GetValueAtIndex(RowNo, 1));
            Temp_PriceListLine.SetRange("Asset Type", Temp_PriceListLine."Asset Type"::Item);
            Temp_PriceListLine.SetRange("Product No.", GetValueAtIndex(RowNo, 3));
            Clear(L_MinQty);
            if (GetValueAtIndex(RowNo, 4) <> '0') then
                Evaluate(L_MinQty, GetValueAtIndex(RowNo, 4))
            else
                L_MinQty := 0;
            Temp_PriceListLine.SetRange("Minimum Quantity", L_MinQty);
            if not Temp_PriceListLine.FindFirst() then begin
                Temp_PriceListLine.Init();
                Temp_PriceListLine."Price List Code" := GetValueAtIndex(RowNo, 1);
                Temp_PriceListLine."Product No." := GetValueAtIndex(RowNo, 3);
                Temp_PriceListLine."Minimum Quantity" := L_MinQty;
                Temp_PriceListLine."Line No." := RowNo;
                Temp_PriceListLine."No of Count" := 1;
                Temp_PriceListLine.Insert();
            end else begin
                Temp_PriceListLine."No of Count" += 1;
                Temp_PriceListLine.Modify();
            end;
            #EndRegion Create Temp Record to check dulicate line in the excel++

            #Region Excel Body For Error++
            ErrorLog_excelbuffer.NewRow();
            ErrorLog_excelbuffer.AddColumn(GetValueAtIndex(RowNo, 1), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
            ErrorLog_excelbuffer.AddColumn(GetValueAtIndex(RowNo, 2), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
            ErrorLog_excelbuffer.AddColumn(GetValueAtIndex(RowNo, 3), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
            #EndRegion Excel Body For Error++

            #Region Check Basic Error++
            //Error Seq 1
            if GetValueAtIndex(RowNo, 1) = '' then begin
                ErrorLog_excelbuffer.AddColumn(StrSubstNo('The column Sales Price Code is blank. Row Number: %1', RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                L_ErrorFound := true;
                L_IfErrorExit := true;
            end;

            //Error Seq 2
            if GetValueAtIndex(RowNo, 3) = '' then begin
                ErrorLog_excelbuffer.AddColumn(StrSubstNo('The column Item Number is blank. Row Number: %1', RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                L_ErrorFound := true;
                L_IfErrorExit := true;
            end;

            //Error Seq 3
            Temp_PriceListLine.Reset();
            Temp_PriceListLine.SetRange("Price List Code", GetValueAtIndex(RowNo, 1));
            Temp_PriceListLine.SetRange("Asset Type", Temp_PriceListLine."Asset Type"::Item);
            Temp_PriceListLine.SetRange("Product No.", GetValueAtIndex(RowNo, 3));
            Clear(L_MinQty);
            if (GetValueAtIndex(RowNo, 4) <> '0') then
                Evaluate(L_MinQty, GetValueAtIndex(RowNo, 4))
            else
                L_MinQty := 0;
            Temp_PriceListLine.SetRange("Minimum Quantity", L_MinQty);
            if Temp_PriceListLine.FindFirst() then begin
                if Temp_PriceListLine."No of Count" = 2 then begin
                    ErrorLog_excelbuffer.AddColumn(StrSubstNo('Duplicate Line. Row Number: %1', RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                    L_ErrorFound := true;
                    L_IfErrorExit := true;
                end;
            end;

            L_Item.Reset();
            L_Item.SetRange("No.", GetValueAtIndex(RowNo, 3));
            if L_Item.FindFirst() then begin
                if L_Item."Special Product" = true then begin
                    L_PriceListLine.Reset();
                    L_PriceListLine.SetRange("Price List Code", GetValueAtIndex(RowNo, 1));
                    L_PriceListLine.SetRange("Asset Type", L_PriceListLine."Asset Type"::Item);
                    L_PriceListLine.SetRange("Product No.", GetValueAtIndex(RowNo, 3));
                    if L_PriceListLine.FindFirst() then begin
                        L_PriceListHeader.Reset();
                        L_PriceListHeader.SetRange(Code, L_PriceListLine."Price List Code");
                        if L_PriceListHeader.FindFirst() then begin
                            if L_PriceListHeader."Drug Special" = false then begin
                                ErrorLog_excelbuffer.AddColumn(StrSubstNo('Special Product is not allowed for this Contract Code %1. Row Number: %2', GetValueAtIndex(RowNo, 1), RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                                L_ErrorFound := true;
                                L_IfErrorExit := true;
                            end;
                        end;
                    end;
                end;
            end;
            #EndRegion Check Basic Error--

            if (SalesPriceHeaderExit(GetValueAtIndex(RowNo, 1)) = true) AND (L_ErrorFound = false) then begin
                //Create Excel Body For Error++
                //Error Seq 5
                if ((GetValueAtIndex(RowNo, 5) <> '0')) AND ((GetValueAtIndex(RowNo, 6) <> '0')) then begin
                    ErrorLog_excelbuffer.AddColumn(StrSubstNo('The columns Unit Price and Line discount contain value. Either one of them should be blank'), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                    L_ErrorFound := true;
                    L_IfErrorExit := true;
                end;

                if L_ErrorFound = false then begin
                    Clear(L_MinQty);
                    if (GetValueAtIndex(RowNo, 4) <> '0') then
                        Evaluate(L_MinQty, GetValueAtIndex(RowNo, 4))
                    else
                        L_MinQty := 0;

                    if SalesPriceLineExit(GetValueAtIndex(RowNo, 1), GetValueAtIndex(RowNo, 3), L_MinQty) = true then begin
                        //Delete Line If Columns Unit Price and Line discount conatins value are blank++
                        if (GetValueAtIndex(RowNo, 5) = '0') AND (GetValueAtIndex(RowNo, 6) = '0') then begin
                            L_SalesPriceListLine.Reset();
                            L_SalesPriceListLine.SetRange("Price List Code", GetValueAtIndex(RowNo, 1));
                            L_SalesPriceListLine.SetRange("Asset Type", L_SalesPriceListLine."Asset Type"::Item);
                            L_SalesPriceListLine.SetRange("Product No.", GetValueAtIndex(RowNo, 3));
                            L_SalesPriceListLine.SetRange("Minimum Quantity", L_MinQty);
                            if L_SalesPriceListLine.FindFirst() then begin
                                L_SalesPriceListLine.Delete(true);
                            end;
                        end else begin
                            L_SalesPriceListLine.Reset();
                            L_SalesPriceListLine.SetRange("Price List Code", GetValueAtIndex(RowNo, 1));
                            L_SalesPriceListLine.SetRange("Asset Type", L_SalesPriceListLine."Asset Type"::Item);
                            L_SalesPriceListLine.SetRange("Product No.", GetValueAtIndex(RowNo, 3));
                            L_SalesPriceListLine.SetRange("Minimum Quantity", L_MinQty);
                            if L_SalesPriceListLine.FindFirst() then begin
                                L_SalesPriceListLine.Validate("Minimum Quantity", L_MinQty);

                                Clear(L_UnitPrice);
                                if (GetValueAtIndex(RowNo, 5) <> '0') then
                                    Evaluate(L_UnitPrice, GetValueAtIndex(RowNo, 5));
                                L_SalesPriceListLine.Validate("Unit Price", L_UnitPrice);

                                Clear(L_LineDiscount);
                                if (GetValueAtIndex(RowNo, 6) <> '0') then
                                    Evaluate(L_LineDiscount, GetValueAtIndex(RowNo, 6));
                                L_SalesPriceListLine.Validate("Line Discount %", L_LineDiscount);

                                Clear(L_BaseVolume);
                                if (GetValueAtIndex(RowNo, 7) <> '0') then
                                    Evaluate(L_BaseVolume, GetValueAtIndex(RowNo, 7));
                                L_SalesPriceListLine.Validate("Base Volume", L_BaseVolume);

                                Clear(L_CostUnitThereafter);
                                if (GetValueAtIndex(RowNo, 8) <> '0') then
                                    Evaluate(L_CostUnitThereafter, GetValueAtIndex(RowNo, 8));
                                L_SalesPriceListLine.Validate("Cost Unit Thereafter", L_CostUnitThereafter);

                                Clear(L_Rebate);
                                if (GetValueAtIndex(RowNo, 9) <> '0') then
                                    Evaluate(L_Rebate, GetValueAtIndex(RowNo, 9));
                                L_SalesPriceListLine.Validate(Rebate, L_Rebate);
                                L_SalesPriceListLine.Modify(true);
                            end;
                        end;
                    end else begin
                        //Insert New Price Line++
                        //Clear Filter++
                        L_SalesPriceListLine.Reset();

                        //Get Header
                        L_PriceListHeader.Reset();
                        L_PriceListHeader.SetRange(Code, GetValueAtIndex(RowNo, 1));
                        if L_PriceListHeader.FindFirst() then;

                        L_SalesPriceListLine.Init();
                        L_SalesPriceListLine.Validate("Price List Code", GetValueAtIndex(RowNo, 1));
                        L_SalesPriceListLine.Validate("Asset Type", L_SalesPriceListLine."Asset Type"::Item);
                        L_SalesPriceListLine.Validate("Product No.", GetValueAtIndex(RowNo, 3));
                        L_SalesPriceListLine.Validate("Line No.", GetLastLineNo(GetValueAtIndex(RowNo, 1)));
                        L_SalesPriceListLine.Validate("Amount Type", L_SalesPriceListLine."Amount Type"::Any);
                        L_SalesPriceListLine.Insert(true);
                        L_SalesPriceListLine.Validate("Minimum Quantity", L_MinQty);

                        Clear(L_UnitPrice);
                        if (GetValueAtIndex(RowNo, 5) <> '0') then
                            Evaluate(L_UnitPrice, GetValueAtIndex(RowNo, 5));
                        L_SalesPriceListLine.Validate("Unit Price", L_UnitPrice);

                        Clear(L_LineDiscount);
                        if (GetValueAtIndex(RowNo, 6) <> '0') then
                            Evaluate(L_LineDiscount, GetValueAtIndex(RowNo, 6));
                        L_SalesPriceListLine.Validate("Line Discount %", L_LineDiscount);

                        Clear(L_BaseVolume);
                        if (GetValueAtIndex(RowNo, 7) <> '0') then
                            Evaluate(L_BaseVolume, GetValueAtIndex(RowNo, 7));
                        L_SalesPriceListLine.Validate("Base Volume", L_BaseVolume);

                        Clear(L_CostUnitThereafter);
                        if (GetValueAtIndex(RowNo, 8) <> '0') then
                            Evaluate(L_CostUnitThereafter, GetValueAtIndex(RowNo, 8));
                        L_SalesPriceListLine.Validate("Cost Unit Thereafter", L_CostUnitThereafter);

                        Clear(L_Rebate);
                        if (GetValueAtIndex(RowNo, 9) <> '0') then
                            Evaluate(L_Rebate, GetValueAtIndex(RowNo, 9));
                        L_SalesPriceListLine.Validate(Rebate, L_Rebate);

                        L_SalesPriceListLine.Validate(Status, L_SalesPriceListLine.Status::Active);
                        L_SalesPriceListLine.Modify();
                    end;
                end;
            end else begin
                //Create Excel Body For Error++
                //Error Seq 4
                if L_ErrorFound = false then begin
                    ErrorLog_excelbuffer.AddColumn(StrSubstNo('Sales Price Code %1 does not exist', GetValueAtIndex(RowNo, 1)), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                    L_ErrorFound := true;
                    L_IfErrorExit := true;
                end;
            end;

            if L_ErrorFound = false then begin
                ErrorLog_excelbuffer.AddColumn('No Error', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
            end;
        end;

        // for RowNo := 2 to Rows do begin
        //     if SalesPriceHeaderExit(GetValueAtIndex(RowNo, 1)) = true then begin
        //         if SalesPriceLineExit(GetValueAtIndex(RowNo, 1), GetValueAtIndex(RowNo, 3)) = true then begin
        //             L_SalesPriceListLine.Reset();
        //             L_SalesPriceListLine.SetRange("Price List Code", GetValueAtIndex(RowNo, 1));
        //             L_SalesPriceListLine.SetRange("Asset Type", L_SalesPriceListLine."Asset Type"::Item);
        //             L_SalesPriceListLine.SetRange("Product No.", GetValueAtIndex(RowNo, 3));
        //             if L_SalesPriceListLine.FindFirst() then begin
        //                 // Clear(L_Statuse);
        //                 // Evaluate(L_Statuse, GetValueAtIndex(RowNo, 1));
        //                 // L_SalesPriceListLine.Validate(Status, L_Statuse);

        //                 Clear(L_MinQty);
        //                 Evaluate(L_MinQty, GetValueAtIndex(RowNo, 4));
        //                 L_SalesPriceListLine.Validate("Minimum Quantity", L_MinQty);

        //                 Clear(L_UnitPrice);
        //                 Evaluate(L_UnitPrice, GetValueAtIndex(RowNo, 5));
        //                 L_SalesPriceListLine.Validate("Unit Price", L_UnitPrice);

        //                 Clear(L_LineDiscount);
        //                 Evaluate(L_LineDiscount, GetValueAtIndex(RowNo, 6));
        //                 L_SalesPriceListLine.Validate("Line Discount %", L_LineDiscount);

        //                 Clear(L_BaseVolume);
        //                 Evaluate(L_BaseVolume, GetValueAtIndex(RowNo, 7));
        //                 L_SalesPriceListLine.Validate("Base Volume", L_BaseVolume);

        //                 Clear(L_CostUnitThereafter);
        //                 Evaluate(L_CostUnitThereafter, GetValueAtIndex(RowNo, 8));
        //                 L_SalesPriceListLine.Validate("Cost Unit Thereafter", L_CostUnitThereafter);

        //                 Clear(L_Rebate);
        //                 Evaluate(L_Rebate, GetValueAtIndex(RowNo, 9));
        //                 L_SalesPriceListLine.Validate(Rebate, L_Rebate);

        //                 // Clear(L_StartDate);
        //                 // if GetValueAtIndex(RowNo, 12) <> '' then begin
        //                 //     Evaluate(L_StartDate, GetValueAtIndex(RowNo, 12));
        //                 //     L_SalesPriceListLine.Validate("Starting Date", L_StartDate);
        //                 // end;

        //                 // Clear(L_EndDate);
        //                 // if GetValueAtIndex(RowNo, 13) <> '' then begin
        //                 //     Evaluate(L_EndDate, GetValueAtIndex(RowNo, 13));
        //                 //     L_SalesPriceListLine.Validate("Ending Date", L_EndDate);
        //                 // end;

        //                 L_SalesPriceListLine.Modify(true);
        //             end;
        //         end else begin
        //             //Insert New Price Line++

        //             //Clear Filter++
        //             L_SalesPriceListLine.Reset();

        //             //Get Header
        //             L_PriceListHeader.Reset();
        //             L_PriceListHeader.SetRange(Code, GetValueAtIndex(RowNo, 1));
        //             if L_PriceListHeader.FindFirst() then;

        //             L_SalesPriceListLine.Init();
        //             L_SalesPriceListLine.Validate("Price List Code", GetValueAtIndex(RowNo, 1));
        //             L_SalesPriceListLine.Validate("Asset Type", L_SalesPriceListLine."Asset Type"::Item);
        //             L_SalesPriceListLine.Validate("Product No.", GetValueAtIndex(RowNo, 3));
        //             L_SalesPriceListLine.Validate("Line No.", GetLastLineNo(GetValueAtIndex(RowNo, 1)));
        //             L_SalesPriceListLine.Validate("Amount Type", L_SalesPriceListLine."Amount Type"::Any);
        //             L_SalesPriceListLine.Insert(true);

        //             Clear(L_MinQty);
        //             Evaluate(L_MinQty, GetValueAtIndex(RowNo, 4));
        //             L_SalesPriceListLine.Validate("Minimum Quantity", L_MinQty);

        //             Clear(L_UnitPrice);
        //             Evaluate(L_UnitPrice, GetValueAtIndex(RowNo, 5));
        //             L_SalesPriceListLine.Validate("Unit Price", L_UnitPrice);

        //             Clear(L_LineDiscount);
        //             Evaluate(L_LineDiscount, GetValueAtIndex(RowNo, 6));
        //             L_SalesPriceListLine.Validate("Line Discount %", L_LineDiscount);

        //             Clear(L_BaseVolume);
        //             Evaluate(L_BaseVolume, GetValueAtIndex(RowNo, 7));
        //             L_SalesPriceListLine.Validate("Base Volume", L_BaseVolume);

        //             Clear(L_CostUnitThereafter);
        //             Evaluate(L_CostUnitThereafter, GetValueAtIndex(RowNo, 8));
        //             L_SalesPriceListLine.Validate("Cost Unit Thereafter", L_CostUnitThereafter);

        //             Clear(L_Rebate);
        //             Evaluate(L_Rebate, GetValueAtIndex(RowNo, 9));
        //             L_SalesPriceListLine.Validate(Rebate, L_Rebate);

        //             // Clear(L_StartDate);
        //             // if GetValueAtIndex(RowNo, 12) <> '' then begin
        //             //     Evaluate(L_StartDate, GetValueAtIndex(RowNo, 12));
        //             //     L_SalesPriceListLine.Validate("Starting Date", L_StartDate);
        //             // end;

        //             // Clear(L_EndDate);
        //             // if GetValueAtIndex(RowNo, 13) <> '' then begin
        //             //     Evaluate(L_EndDate, GetValueAtIndex(RowNo, 13));
        //             //     L_SalesPriceListLine.Validate("Ending Date", L_EndDate);
        //             // end;
        //             L_SalesPriceListLine.Validate(Status, L_SalesPriceListLine.Status::Active);
        //             L_SalesPriceListLine.Modify();
        //         end;
        //     end else begin
        //         Error('Sales Price Code %1 does not exist', GetValueAtIndex(RowNo, 1));
        //         //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //         // //Insert New Price Header++

        //         // //Create Price List Header++
        //         // L_PriceListHeader.Reset();
        //         // L_PriceListHeader.Init();
        //         // L_PriceListHeader.Validate(Code, GetValueAtIndex(RowNo, 1));
        //         // L_PriceListHeader.Validate(Description, GetValueAtIndex(RowNo, 2));
        //         // L_PriceListHeader.Validate("Source Type", L_PriceListHeader."Source Type"::"Customer Price Group");
        //         // L_PriceListHeader.Validate("Source No.", GetValueAtIndex(RowNo, 10));
        //         // L_PriceListHeader.Validate("Assign-to No.", GetValueAtIndex(RowNo, 10));
        //         // L_PriceListHeader.Validate("Price Type", L_PriceListHeader."Price Type"::Sale);
        //         // L_PriceListHeader.Validate("Allow Invoice Disc.", true);
        //         // L_PriceListHeader.Validate("Allow Line Disc.", true);
        //         // L_PriceListHeader.Validate(Status, L_PriceListHeader.Status::Active);
        //         // L_PriceListHeader.Insert(true);
        //         // L_PriceListHeader.Validate("Amount Type", L_PriceListHeader."Amount Type"::Any);
        //         // L_PriceListHeader.Modify();

        //         // //Create Proce List Line++
        //         // L_SalesPriceListLine.Reset();
        //         // L_SalesPriceListLine.Init();
        //         // L_SalesPriceListLine.Validate("Price List Code", GetValueAtIndex(RowNo, 1));
        //         // L_SalesPriceListLine.Validate("Asset Type", L_SalesPriceListLine."Asset Type"::Item);
        //         // L_SalesPriceListLine.Validate("Product No.", GetValueAtIndex(RowNo, 3));
        //         // L_SalesPriceListLine.Validate("Line No.", GetLastLineNo(GetValueAtIndex(RowNo, 1)));
        //         // L_SalesPriceListLine.Validate("Amount Type", L_SalesPriceListLine."Amount Type"::Any);
        //         // L_SalesPriceListLine.Insert(true);

        //         // Clear(L_MinQty);
        //         // Evaluate(L_MinQty, GetValueAtIndex(RowNo, 4));
        //         // L_SalesPriceListLine.Validate("Minimum Quantity", L_MinQty);

        //         // Clear(L_UnitPrice);
        //         // Evaluate(L_UnitPrice, GetValueAtIndex(RowNo, 5));
        //         // L_SalesPriceListLine.Validate("Unit Price", L_UnitPrice);

        //         // Clear(L_LineDiscount);
        //         // Evaluate(L_LineDiscount, GetValueAtIndex(RowNo, 6));
        //         // L_SalesPriceListLine.Validate("Line Discount %", L_LineDiscount);

        //         // Clear(L_BaseVolume);
        //         // Evaluate(L_BaseVolume, GetValueAtIndex(RowNo, 7));
        //         // L_SalesPriceListLine.Validate("Base Volume", L_BaseVolume);

        //         // Clear(L_CostUnitThereafter);
        //         // Evaluate(L_CostUnitThereafter, GetValueAtIndex(RowNo, 8));
        //         // L_SalesPriceListLine.Validate("Cost Unit Thereafter", L_CostUnitThereafter);

        //         // Clear(L_Rebate);
        //         // Evaluate(L_Rebate, GetValueAtIndex(RowNo, 9));
        //         // L_SalesPriceListLine.Validate(Rebate, L_Rebate);

        //         // // Clear(L_StartDate);
        //         // // if GetValueAtIndex(RowNo, 12) <> '' then begin
        //         // //     Evaluate(L_StartDate, GetValueAtIndex(RowNo, 12));
        //         // //     L_SalesPriceListLine.Validate("Starting Date", L_StartDate);
        //         // // end;

        //         // // Clear(L_EndDate);
        //         // // if GetValueAtIndex(RowNo, 13) <> '' then begin
        //         // //     Evaluate(L_EndDate, GetValueAtIndex(RowNo, 13));
        //         // //     L_SalesPriceListLine.Validate("Ending Date", L_EndDate);
        //         // // end;
        //         // L_SalesPriceListLine.Validate(Status, L_SalesPriceListLine.Status::Active);
        //         // L_SalesPriceListLine.Modify();
        //         //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //     end;
        // end;

        //Verify Sales Price++
        //Note:- System Skip sales price which is already verified++
        L_PriceListHeader.Reset();
        L_PriceListHeader.SetFilter(Status, '%1|%2', L_PriceListHeader.Status::Active, L_PriceListHeader.Status::Draft);
        if L_PriceListHeader.FindSet() then begin
            repeat
                PriceListManagement.ActivateDraftLines(L_PriceListHeader, true);
            until L_PriceListHeader.Next() = 0;
        end;


        //Export Error Excel File++
        if L_IfErrorExit = true then begin
            ErrorLog_excelbuffer.CreateNewBook('Errors');
            ErrorLog_excelbuffer.WriteSheet('Errors', CompanyName, UserId);
            ErrorLog_excelbuffer.CloseBook();
            ErrorLog_excelbuffer.SetFriendlyFilename(StrSubstNo('Error', CurrentDateTime, UserId));
            ErrorLog_excelbuffer.OpenExcel();
        end;
    end;


    local procedure GetLastLineNo(SalesPriceCode: Code[50]): Integer
    var
        L_PriceListLine: Record "Price List Line";
    begin
        L_PriceListLine.Reset();
        L_PriceListLine.SetRange("Price List Code", SalesPriceCode);
        if L_PriceListLine.FindLast() then
            exit(L_PriceListLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure SalesPriceLineExit(_Code: Code[20]; _ProductCode: Code[20]; _MinQty: Decimal): Boolean
    var
        L_SalesPriceListLine: Record "Price List line";
    begin
        L_SalesPriceListLine.Reset();
        L_SalesPriceListLine.SetRange("Price List Code", _Code);
        L_SalesPriceListLine.SetRange("Asset Type", L_SalesPriceListLine."Asset Type"::Item);
        L_SalesPriceListLine.SetRange("Product No.", _ProductCode);
        L_SalesPriceListLine.SetRange("Minimum Quantity", _MinQty);
        if L_SalesPriceListLine.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    local procedure SalesPriceHeaderExit(_Code: Code[20]): Boolean
    var
        L_SalesPriceListHeader: Record "Price List Header";
    begin
        L_SalesPriceListHeader.Reset();
        L_SalesPriceListHeader.SetRange(Code, _Code);
        if L_SalesPriceListHeader.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
        Rec_ExcelBuffer: Record "Excel Buffer";
    begin
        Rec_ExcelBuffer.Reset();
        If Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");
    end;



    procedure ExportSalesPriceTemplate()
    var
        Excelbuffer: Record "Excel Buffer" temporary;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;

        L_PriceListLine: Record "Price List Line";
        L_PriceListHeader: Record "Price List Header";
    begin
        Excelbuffer.Reset();
        Excelbuffer.DeleteAll();

        //Create Header++
        Excelbuffer.NewRow();
        //Excelbuffer.AddColumn('Status', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Sales Price List Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Sales Price Description', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Item No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Min Qty', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Unit Price', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Line Discount %', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Base Volume', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Cost Unit Thereafter', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Rebate', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Assign-to No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        //Excelbuffer.AddColumn('Starting Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        //Excelbuffer.AddColumn('End Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);

        //Create Body++
        L_PriceListHeader.Reset();
        L_PriceListHeader.SetFilter("Ending Date", '>=%1|%2', Today, 0D);
        L_PriceListHeader.SetRange(Status, L_PriceListHeader.Status::Active);
        L_PriceListHeader.SetCurrentKey(Code);
        L_PriceListHeader.Ascending(true);
        if L_PriceListHeader.FindSet() then begin
            repeat
                L_PriceListLine.Reset();
                L_PriceListLine.SetRange("Asset Type", L_PriceListLine."Asset Type"::Item);
                //L_PriceListLine.SetRange(Status, L_PriceListHeader.Status);
                L_PriceListLine.SetRange("Price List Code", L_PriceListHeader.Code);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        Excelbuffer.NewRow;
                        //Excelbuffer.AddColumn(L_PriceListLine.Status, FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Text);
                        Excelbuffer.AddColumn(L_PriceListLine."Price List Code", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Text);
                        Excelbuffer.AddColumn(L_PriceListHeader.Description, FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Text);
                        Excelbuffer.AddColumn(L_PriceListLine."Product No.", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Text);
                        Excelbuffer.AddColumn(L_PriceListLine."Minimum Quantity", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Number);
                        Excelbuffer.AddColumn(L_PriceListLine."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Number);
                        Excelbuffer.AddColumn(L_PriceListLine."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Number);
                        Excelbuffer.AddColumn(L_PriceListLine."Base Volume", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Number);
                        Excelbuffer.AddColumn(L_PriceListLine."Cost Unit Thereafter", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Number);
                        Excelbuffer.AddColumn(L_PriceListLine.Rebate, FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Number);
                        Excelbuffer.AddColumn(L_PriceListLine."Assign-to No.", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Text);
                    //Excelbuffer.AddColumn(L_PriceListHeader."Starting Date", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Date);
                    //Excelbuffer.AddColumn(L_PriceListHeader."Ending Date", FALSE, '', FALSE, FALSE, FALSE, '', Excelbuffer."Cell Type"::Date);
                    until L_PriceListLine.Next() = 0;
                end;
            until L_PriceListHeader.Next() = 0;
        end;


        //Create Book++
        Excelbuffer.CreateNewBook('Sales Price');
        Excelbuffer.WriteSheet('Sales Price', CompanyName, UserId);
        Excelbuffer.CloseBook();
        TempBLOB.CreateOutStream(outs);
        Excelbuffer.SaveToStream(outs, false);
        TempBLOB.CreateInStream(ins);
        filename := 'SalesPrice_' + Format(CurrentDateTime) + '.xlsx';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
    end;
}