//This CodeUnit Used for Sales Price changes on SO line+++
codeunit 85011 "Customer Price Group Changes"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_CalledByFieldNo: Integer;

    [EventSubscriber(ObjectType::Table, Database::"Price Source", 'OnBeforeVerifyAmountTypeForSourceType', '', false, false)]
    local procedure OnBeforeVerifyAmountTypeForSourceType(var IsHandled: Boolean)
    begin
        //Ignore View Columns validation+++
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price Source", 'OnBeforeGetDefaultAmountType', '', false, false)]
    local procedure OnBeforeGetDefaultAmountType(var IsHandled: Boolean; PriceSource: Record "Price Source" temporary; var AmountType: Enum "Price Amount Type")
    begin
        //Set always "Price and Discount"
        AmountType := AmountType::Any;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure UnitPrice_OnAfterValidateEvent(var Rec: Record "Price List Line")
    var
    // L_PriceListLine: Record "Price List Line";
    // L_PriceListManagement: codeunit "Price List Management";
    // L_PriceListHeader: Record "Price List Header";
    // DuplicatePriceLine: Record "Duplicate Price Line";
    begin
        //User can enter only unit price or Line Discount
        if Rec."Unit Price" <> 0 then
            Rec.TestField("Line Discount %", 0);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure LineDiscount_OnAfterValidateEvent(var Rec: Record "Price List Line")
    var
    // L_PriceListLine: Record "Price List Line";
    // L_PriceListManagement: codeunit "Price List Management";
    // L_PriceListHeader: Record "Price List Header";
    // DuplicatePriceLine: Record "Duplicate Price Line";
    begin
        //User can enter only unit price or Line Discount
        if Rec."Line Discount %" <> 0 then
            Rec.TestField("Unit Price", 0);

    end;


    //New Code++02/10/2024++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateUnitPrice', '', false, false)]
    local procedure OnBeforeUpdateUnitPrice(var SalesLine: Record "Sales Line"; var Handled: Boolean)
    begin
        //Skip Defualt code+++
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then
            Handled := true
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure No_OnAfterValidateEvent(CurrFieldNo: Integer; var Rec: Record "Sales Line")
    var
        L_PriceListLine: Record "Price List Line";
        L_Customer: Record Customer;
        L_SalesHeader: Record "Sales Header";
        i: Integer;
        Loop: Integer;
        L_Item: Record Item;
        L_PriceFound: Boolean;
    begin
        //Get Sales Header++
        If L_SalesHeader.Get(Rec."Document Type", Rec."Document No.") then;

        //If Special Product (DT) +++
        L_Item.Reset();
        IF L_Item.Get(Rec."No.") then begin
            if L_Item."Special Product" = true then begin
                if L_SalesHeader."Currency Factor" > 0 then
                    Rec.Validate("Unit Price", L_Item."Unit Price" / L_SalesHeader."Currency Factor")
                else
                    Rec.Validate("Unit Price", L_Item."Unit Price");
                exit;
            end;
        end;


        //Finding Best Price++
        Clear(L_PriceFound);
        If L_Customer.Get(L_SalesHeader."Bill-to Customer No.") then begin
            //1st Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");

                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end;
            end;

            //2nd Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 2");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");

                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //3rd Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 3");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //4th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 4");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //5th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 5");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //6th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 6");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //7th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 7");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //8th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 8");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //9th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 9");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //10th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 10");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;


            //If Price List not found
            if L_PriceFound = false then begin
                L_Item.Reset();
                IF L_Item.Get(Rec."No.") then begin
                    if L_SalesHeader."Currency Factor" > 0 then
                        Rec.Validate("Unit Price", L_Item."Unit Price" / L_SalesHeader."Currency Factor")
                    else
                        Rec.Validate("Unit Price", L_Item."Unit Price")
                end;
            end;

            Clear(G_CalledByFieldNo);
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure Qty_OnAfterValidateEvent(CurrFieldNo: Integer; var Rec: Record "Sales Line")
    var
        L_PriceListLine: Record "Price List Line";
        L_Customer: Record Customer;
        L_SalesHeader: Record "Sales Header";
        i: Integer;
        Loop: Integer;
        L_Item: Record Item;
        L_PriceFound: Boolean;


        DiffVolume: Decimal;
        DiffVolumePrice: Decimal;
        FinalPrice: Decimal;
        SalesLine3: Record "Sales Line";
        statis: page 400;
        Customer2: Record Customer;
        CustomerPriceGroupText: Text[20000];
        PriceLineList2: Record "Price List Line";
        L_DiscountedUnitPrice: Decimal;
    begin
        CLEAR(DiffVolume);
        CLEAR(DiffVolumePrice);
        CLEAR(FinalPrice);
        Clear(CustomerPriceGroupText);

        //Get Sales Header++
        If L_SalesHeader.Get(Rec."Document Type", Rec."Document No.") then;

        //If Special Product (DT) +++
        L_Item.Reset();
        IF L_Item.Get(Rec."No.") then begin
            if L_Item."Special Product" = true then begin
                if Customer2.get(Rec."Bill-to Customer No.") then begin
                    if Customer2."Customer Price Group" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + Customer2."Customer Price Group";
                    if Customer2."Customer Price Group 2" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 2";
                    if Customer2."Customer Price Group 3" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 3";
                    if Customer2."Customer Price Group 4" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 4";
                    if Customer2."Customer Price Group 5" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 5";
                    if Customer2."Customer Price Group 6" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 6";
                    if Customer2."Customer Price Group 7" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 7";
                    if Customer2."Customer Price Group 8" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 8";
                    if Customer2."Customer Price Group 9" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 9";
                    if Customer2."Customer Price Group 10" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 10";

                end;



                PriceLineList2.Reset();
                PriceLineList2.SetRange(Status, PriceLineList2.Status::Active);
                PriceLineList2.SetRange("Source Type", PriceLineList2."Source Type"::"Customer Price Group");
                PriceLineList2.SetFilter("Source No.", CustomerPriceGroupText);
                PriceLineList2.SetRange("Asset Type", PriceLineList2."Asset Type"::Item);
                PriceLineList2.Setrange("Asset No.", Rec."No.");
                PriceLineList2.Setrange("Special Product", true);
                PriceLineList2.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                PriceLineList2.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                PriceLineList2.SetRange("Currency Code", L_SalesHeader."Currency Code");
                IF PriceLineList2.FindFirst() then begin
                    if Rec."Unit Volume" > PriceLineList2."Base Volume" then begin
                        DiffVolume := Rec."Unit Volume" - PriceLineList2."Base Volume";
                        DiffVolumePrice := DiffVolume * PriceLineList2."Cost Unit Thereafter";
                        if PriceLineList2."Unit Price" <> 0 then begin
                            Clear(L_DiscountedUnitPrice);
                            if PriceLineList2."Line Discount %" > 0 then begin
                                L_DiscountedUnitPrice := (PriceLineList2."Unit Price") - ((PriceLineList2."Unit Price" * PriceLineList2."Line Discount %") / 100);
                            end else
                                L_DiscountedUnitPrice := PriceLineList2."Unit Price";

                            FinalPrice := (DiffVolumePrice + L_DiscountedUnitPrice);
                        end else begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", Rec."No.");
                            if L_Item.FindFirst() then begin
                                Clear(L_DiscountedUnitPrice);
                                if PriceLineList2."Line Discount %" > 0 then begin
                                    L_DiscountedUnitPrice := (L_Item."Unit Price") - ((L_Item."Unit Price" * PriceLineList2."Line Discount %") / 100);
                                end else
                                    L_DiscountedUnitPrice := L_Item."Unit Price";

                                FinalPrice := (DiffVolumePrice + L_DiscountedUnitPrice);
                            end;
                        end;
                        // IF L_SalesHeader."Currency Factor" <> 0 THEN
                        //     FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price") / L_SalesHeader."Currency Factor"
                        // ELSE
                        //     FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price");
                    end else begin
                        if PriceLineList2."Unit Price" <> 0 then begin
                            Clear(L_DiscountedUnitPrice);
                            if PriceLineList2."Line Discount %" > 0 then begin
                                L_DiscountedUnitPrice := (PriceLineList2."Unit Price") - ((PriceLineList2."Unit Price" * PriceLineList2."Line Discount %") / 100);
                            end else
                                L_DiscountedUnitPrice := PriceLineList2."Unit Price";

                            FinalPrice := L_DiscountedUnitPrice;
                        end else begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", Rec."No.");
                            if L_Item.FindFirst() then begin
                                Clear(L_DiscountedUnitPrice);
                                if PriceLineList2."Line Discount %" > 0 then begin
                                    L_DiscountedUnitPrice := (L_Item."Unit Price") - ((L_Item."Unit Price" * PriceLineList2."Line Discount %") / 100);
                                end else
                                    L_DiscountedUnitPrice := L_Item."Unit Price";

                                FinalPrice := L_DiscountedUnitPrice;
                            end;
                        end;
                    end;


                    Rec.Validate("Unit Price", FinalPrice);
                    Rec.Validate(Rebate, PriceLineList2.Rebate);
                    //Rec.Validate("Line Discount %", PriceLineList2."Line Discount %");
                    Rec."Discount Applied on BasePrice" := PriceLineList2."Line Discount %";
                end;
                exit;
            end;
        end;


        //For Normal Products+++++
        //Finding Best Price++
        Clear(L_PriceFound);
        If L_Customer.Get(L_SalesHeader."Bill-to Customer No.") then begin
            //1st Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");

                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end;
            end;

            //2nd Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 2");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");

                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //3rd Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 3");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //4th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 4");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //5th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 5");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //6th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 6");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //7th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 7");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //8th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 8");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //9th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 9");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;

            //10th Price++
            if L_PriceFound = false then begin
                L_PriceListLine.Reset();
                L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
                L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
                L_PriceListLine.SetRange("Asset No.", Rec."No.");
                L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
                L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 10");
                L_PriceListLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
                //L_PriceListLine.SetRange("Variant Code", Rec."Variant Code");
                L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                if L_PriceListLine.FindSet() then begin
                    repeat
                        if L_PriceListLine."Minimum Quantity" <> 0 then begin
                            if L_PriceListLine."Minimum Quantity" <= Rec.Quantity then begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", Rec."No.");
                                    if L_Item.FindFirst() then
                                        Rec.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        end else begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", Rec."No.");
                                if L_Item.FindFirst() then
                                    Rec.Validate("Unit Price", L_Item."Unit Price");
                            end else
                                Rec.Validate("Unit Price", L_PriceListLine."Unit Price");


                            if L_PriceListLine."Line Discount %" <> 0 then
                                Rec.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                            L_PriceFound := true;
                        end;
                    until L_PriceListLine.Next() = 0;
                end
            end;


            //If Price List not found
            if L_PriceFound = false then begin
                L_Item.Reset();
                IF L_Item.Get(Rec."No.") then begin
                    if L_SalesHeader."Currency Factor" > 0 then
                        Rec.Validate("Unit Price", L_Item."Unit Price" / L_SalesHeader."Currency Factor")
                    else
                        Rec.Validate("Unit Price", L_Item."Unit Price")
                end;
            end;

            Clear(G_CalledByFieldNo);
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterValidateEvent', 'Asset No.', false, false)]
    local procedure OnafterValidateEventItemNoOnPriceList(CurrFieldNo: Integer; var Rec: Record "Price List Line"; var xRec: Record "Price List Line")
    var
        Item3: Record Item;
    begin
        If Rec."Asset Type" = Rec."Asset Type"::Item then begin
            if Item3.Get(rec."Asset No.") then begin
                Rec.Strength := Item3.Strength;
                Rec."Special Product" := Item3."Special Product";
                Rec."No. 2" := Item3."No. 2";
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Volume', false, false)]
    local procedure OnAfterValidateEventUnitVolume(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        DiffVolume: Decimal;
        DiffVolumePrice: Decimal;
        FinalPrice: Decimal;
        SalesLine3: Record "Sales Line";
        statis: page 400;
        Customer2: Record Customer;
        CustomerPriceGroupText: Text[20000];
        PriceLineList2: Record "Price List Line";
        L_SalesHeader: Record "Sales Header";
        L_Item: Record Item;
        L_DiscountedUnitPrice: Decimal;
    begin
        CLEAR(DiffVolume);
        CLEAR(DiffVolumePrice);
        CLEAR(FinalPrice);
        Clear(CustomerPriceGroupText);

        if Rec.Type <> Rec.Type::Item then
            exit;

        L_SalesHeader.Reset();
        IF L_SalesHeader.get(Rec."Document Type", Rec."Document No.") then begin
            IF rec."Special Product" then begin
                if Customer2.get(Rec."Bill-to Customer No.") then begin
                    if Customer2."Customer Price Group" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + Customer2."Customer Price Group";
                    if Customer2."Customer Price Group 2" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 2";
                    if Customer2."Customer Price Group 3" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 3";
                    if Customer2."Customer Price Group 4" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 4";
                    if Customer2."Customer Price Group 5" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 5";
                    if Customer2."Customer Price Group 6" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 6";
                    if Customer2."Customer Price Group 7" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 7";
                    if Customer2."Customer Price Group 8" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 8";
                    if Customer2."Customer Price Group 9" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 9";
                    if Customer2."Customer Price Group 10" <> '' then
                        CustomerPriceGroupText := CustomerPriceGroupText + '|' + Customer2."Customer Price Group 10";
                end;

                PriceLineList2.Reset();
                PriceLineList2.SetRange(Status, PriceLineList2.Status::Active);
                PriceLineList2.SetRange("Source Type", PriceLineList2."Source Type"::"Customer Price Group");
                PriceLineList2.SetFilter("Source No.", CustomerPriceGroupText);
                PriceLineList2.SetRange("Asset Type", PriceLineList2."Asset Type"::Item);
                PriceLineList2.Setrange("Asset No.", Rec."No.");
                PriceLineList2.Setrange("Special Product", true);
                PriceLineList2.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
                PriceLineList2.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
                PriceLineList2.SetRange("Currency Code", L_SalesHeader."Currency Code");
                IF PriceLineList2.FindFirst() then begin
                    if Rec."Unit Volume" >= PriceLineList2."Base Volume" then begin
                        DiffVolume := Rec."Unit Volume" - PriceLineList2."Base Volume";
                        DiffVolumePrice := DiffVolume * PriceLineList2."Cost Unit Thereafter";
                        if PriceLineList2."Unit Price" <> 0 then begin
                            Clear(L_DiscountedUnitPrice);
                            if PriceLineList2."Line Discount %" > 0 then begin
                                L_DiscountedUnitPrice := (PriceLineList2."Unit Price") - ((PriceLineList2."Unit Price" * PriceLineList2."Line Discount %") / 100);
                            end else
                                L_DiscountedUnitPrice := PriceLineList2."Unit Price";

                            FinalPrice := (DiffVolumePrice + L_DiscountedUnitPrice);
                        end else begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", Rec."No.");
                            if L_Item.FindFirst() then begin
                                Clear(L_DiscountedUnitPrice);
                                if PriceLineList2."Line Discount %" > 0 then begin
                                    L_DiscountedUnitPrice := (L_Item."Unit Price") - ((L_Item."Unit Price" * PriceLineList2."Line Discount %") / 100);
                                end else
                                    L_DiscountedUnitPrice := L_Item."Unit Price";


                                FinalPrice := (DiffVolumePrice + L_DiscountedUnitPrice);
                            end;
                        end;
                        // IF L_SalesHeader."Currency Factor" <> 0 THEN
                        //     FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price") / L_SalesHeader."Currency Factor"
                        // ELSE
                        //     FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price");

                    end else begin
                        if PriceLineList2."Unit Price" <> 0 then begin
                            Clear(L_DiscountedUnitPrice);
                            if PriceLineList2."Line Discount %" > 0 then begin
                                L_DiscountedUnitPrice := (PriceLineList2."Unit Price") - ((PriceLineList2."Unit Price" * PriceLineList2."Line Discount %") / 100);
                            end else
                                L_DiscountedUnitPrice := PriceLineList2."Unit Price";

                            FinalPrice := L_DiscountedUnitPrice;
                        end else begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", Rec."No.");
                            if L_Item.FindFirst() then begin
                                Clear(L_DiscountedUnitPrice);
                                if PriceLineList2."Line Discount %" > 0 then begin
                                    L_DiscountedUnitPrice := (L_Item."Unit Price") - ((L_Item."Unit Price" * PriceLineList2."Line Discount %") / 100);
                                end else
                                    L_DiscountedUnitPrice := L_Item."Unit Price";


                                FinalPrice := L_DiscountedUnitPrice;
                            end;
                        end;
                    end;

                    Rec.Validate("Unit Price", FinalPrice);
                    Rec.Validate(Rebate, PriceLineList2.Rebate);
                    //Rec.Validate("Line Discount %", PriceLineList2."Line Discount %");
                    Rec."Discount Applied on BasePrice" := PriceLineList2."Line Discount %";
                end;
            end;
        end;
    end;
    //New Code++02/10/2024++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    /*
        //Commented Code+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 02/10/2024+++
        //Multiple Customer Price Group++
        [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateUnitPrice', '', false, false)]
        local procedure OnBeforeUpdateUnitPrice(CalledByFieldNo: Integer)
        begin
            Clear(G_CalledByFieldNo);
            G_CalledByFieldNo := CalledByFieldNo;
        end;



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
            //If Validate from Variant code++
            if G_CalledByFieldNo = 5402 then
                exit;


            //Get Sales Header++
            If L_SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then;

            //Check Source Type++
            if PriceListLine."Source Type" = PriceListLine."Source Type"::Customer then
                exit;

            //If Special Product (DT) +++
            if SalesLine."Special Product" = true then begin
                IF L_Item.Get(SalesLine."No.") then begin
                    if L_SalesHeader."Currency Factor" > 0 then
                        SalesLine.Validate("Unit Price", L_Item."Unit Price" / L_SalesHeader."Currency Factor")
                    else
                        SalesLine.Validate("Unit Price", L_Item."Unit Price")
                end;
                exit;
            end;

            //Finding Best Price++
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");

                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");

                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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
                    if L_PriceListLine.FindSet() then begin
                        repeat
                            if L_PriceListLine."Minimum Quantity" <> 0 then begin
                                if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
                                    if L_PriceListLine."Unit Price" = 0 then begin
                                        L_Item.Reset();
                                        L_Item.SetRange("No.", SalesLine."No.");
                                        if L_Item.FindFirst() then
                                            SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                    end else
                                        SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                    if L_PriceListLine."Line Discount %" <> 0 then
                                        SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                    L_PriceFound := true;
                                end;
                            end else begin
                                if L_PriceListLine."Unit Price" = 0 then begin
                                    L_Item.Reset();
                                    L_Item.SetRange("No.", SalesLine."No.");
                                    if L_Item.FindFirst() then
                                        SalesLine.Validate("Unit Price", L_Item."Unit Price");
                                end else
                                    SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");


                                if L_PriceListLine."Line Discount %" <> 0 then
                                    SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
                                L_PriceFound := true;
                            end;
                        until L_PriceListLine.Next() = 0;
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

                Clear(G_CalledByFieldNo);
            end;



            // //Finding Best Price++
            // Clear(L_PriceFound);
            // If L_Customer.Get(L_SalesHeader."Bill-to Customer No.") then begin
            //     //1st Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end;
            //     end;

            //     //2nd Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 2");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //3rd Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 3");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //4th Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 4");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //5th Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 5");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //6th Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 6");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //7th Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 7");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //8th Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 8");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //9th Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 9");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;

            //     //10th Price++
            //     if L_PriceFound = false then begin
            //         L_PriceListLine.Reset();
            //         L_PriceListLine.SetFilter(Status, '%1', L_PriceListLine.Status::Active);
            //         L_PriceListLine.SetRange("Price Type", L_PriceListLine."Price Type"::Sale);
            //         L_PriceListLine.SetRange("Asset No.", SalesLine."No.");
            //         L_PriceListLine.SetRange("Source Type", L_PriceListLine."Source Type"::"Customer Price Group");
            //         L_PriceListLine.SetRange("Source No.", L_Customer."Customer Price Group 10");
            //         L_PriceListLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
            //         L_PriceListLine.SetRange("Currency Code", L_SalesHeader."Currency Code");
            //         //L_PriceListLine.SetRange("Variant Code", SalesLine."Variant Code");
            //         L_PriceListLine.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            //         L_PriceListLine.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);
            //         if L_PriceListLine.FindFirst() then begin
            //             if L_PriceListLine."Minimum Quantity" <> 0 then begin
            //                 if L_PriceListLine."Minimum Quantity" <= SalesLine.Quantity then begin
            //                     SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                     if L_PriceListLine."Line Discount %" <> 0 then
            //                         SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                     L_PriceFound := true;
            //                 end;
            //             end else begin
            //                 SalesLine.Validate("Unit Price", L_PriceListLine."Unit Price");
            //                 if L_PriceListLine."Line Discount %" <> 0 then
            //                     SalesLine.Validate("Line Discount %", L_PriceListLine."Line Discount %");
            //                 L_PriceFound := true;
            //             end;
            //         end
            //     end;


            //     //If Price List not found
            //     if L_PriceFound = false then begin
            //         IF L_Item.Get(SalesLine."No.") then begin
            //             if L_SalesHeader."Currency Factor" > 0 then
            //                 SalesLine.Validate("Unit Price", L_Item."Unit Price" / L_SalesHeader."Currency Factor")
            //             else
            //                 SalesLine.Validate("Unit Price", L_Item."Unit Price")
            //         end;
            //     end;
            // end;
        end;
        //Commented Code+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 02/10/2024+++
        */



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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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
            if L_PriceListLine.FindSet() then begin
                repeat
                    if L_PriceListLine."Minimum Quantity" <> 0 then begin
                        if L_PriceListLine."Minimum Quantity" <= _SalesLine.Quantity then begin
                            if L_PriceListLine."Unit Price" = 0 then begin
                                L_Item.Reset();
                                L_Item.SetRange("No.", _SalesLine."No.");
                                if L_Item.FindFirst() then
                                    exit(L_Item."Unit Price")
                            end else
                                exit(L_PriceListLine."Unit Price");
                        end;
                    end else begin
                        if L_PriceListLine."Unit Price" = 0 then begin
                            L_Item.Reset();
                            L_Item.SetRange("No.", _SalesLine."No.");
                            if L_Item.FindFirst() then
                                exit(L_Item."Unit Price")
                        end else
                            exit(L_PriceListLine."Unit Price");
                    end;
                until L_PriceListLine.Next() = 0;
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