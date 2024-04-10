//This CodeUnit Used for Sales Price changes on SO line+++
codeunit 70113 "Customer Price Group Changes"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

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
                            if L_PriceListLine."Line Discount %" <> 0 then
                                SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        if L_PriceListLine."Line Discount %" <> 0 then
                            SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
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
                            if L_PriceListLine."Line Discount %" <> 0 then
                                SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        if L_PriceListLine."Line Discount %" <> 0 then
                            SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
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
                            if L_PriceListLine."Line Discount %" <> 0 then
                                SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        if L_PriceListLine."Line Discount %" <> 0 then
                            SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
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
                            if L_PriceListLine."Line Discount %" <> 0 then
                                SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        if L_PriceListLine."Line Discount %" <> 0 then
                            SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
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
                            if L_PriceListLine."Line Discount %" <> 0 then
                                SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    end else begin
                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
                        if L_PriceListLine."Line Discount %" <> 0 then
                            SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
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
}