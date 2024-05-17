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


        if SalesLine."Special Product" = true then begin
            IF L_Item.Get(SalesLine."No.") then begin
                if L_SalesHeader."Currency Factor" > 0 then
                    SalesLine.Validate("Unit Price", L_Item."Unit Price" / L_SalesHeader."Currency Factor")
                else
                    SalesLine.Validate("Unit Price", L_Item."Unit Price")
            end;
            exit;
        end;

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
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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

            //6th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 6");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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

            //7th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 7");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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

            //8th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 8");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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

            //9th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 9");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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

            //10th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 10");
                L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindFirst() then begin
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
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
                IF L_Item.Get(SalesLine."No.") then begin
                    if L_SalesHeader."Currency Factor" > 0 then
                        SalesLine.Validate("Unit Price", L_Item."Unit Price" / L_SalesHeader."Currency Factor")
                    else
                        SalesLine.Validate("Unit Price", L_Item."Unit Price")
                end;
            end;
        end;
    end;



    //Get the Original Sales Price+++
    procedure GetOriginalUnitPrice(_SalesHeader: Record "Sales Header"; _SalesLine: Record "Sales Line"): Decimal
    var
        L_PriceListLine: Record "Price List Line";
        L_Customer: Record Customer;
        L_Item: Record Item;
    begin
        L_Customer.Reset();
        If L_Customer.Get(_SalesHeader."Bill-to Customer No.") then begin
            //1st Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;


            //2nd Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 2");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;


            //3rd Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 3");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;


            //4th Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 4");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;

            //5th Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 5");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;

            //6th Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 6");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;

            //7th Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 7");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;

            //8th Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 8");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;

            //9th Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 9");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;

            //10th Price++
            L_PriceListLine.Reset();
            L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            L_PriceListLine.SetRange("Asset No.", _SalesLine."No.");
            L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 10");
            L_PriceListLine.SetRange("Unit of Measure Code", _SalesLine."Unit of Measure Code");
            L_PriceListLine.SetFilter("Ending Date", '>%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetFilter("Starting Date", '<%1|%2', _SalesHeader."Order Date", 0D);
            L_PriceListLine.SetRange("Currency Code", _SalesHeader."Currency Code");
            if L_PriceListLine.FindFirst() then begin
                if L_PriceListLine."Minimum Quantity" <> 0 then begin
                    if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                        exit(L_PriceListLine."Unit Price");
                    end;
                end else begin
                    exit(L_PriceListLine."Unit Price");
                end;
            end;



            //If Price List not found
            IF L_Item.Get(_SalesLine."No.") then begin
                if _SalesHeader."Currency Factor" > 0 then
                    exit(L_Item."Unit Price" / _SalesHeader."Currency Factor")
                else
                    exit(L_Item."Unit Price");
            end;
        end;
    end;
}