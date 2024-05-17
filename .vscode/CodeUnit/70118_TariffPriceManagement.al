codeunit 70118 "Tariff Price Management"
{
    TableNo = 36;

    trigger OnRun()
    begin
        //TESTFIELD("Sell-to Country/Region Code");
        rec.TESTFIELD(Status, rec.Status::Open);
        G_SalesHeader1 := Rec;

        G_SalesLine.RESET;
        G_SalesLine.SETCURRENTKEY("Document Type", "Document No.", Type);
        G_SalesLine.SETRANGE("Document Type", rec."Document Type");
        G_SalesLine.SETRANGE("Document No.", rec."No.");
        G_SalesLine.SETRANGE(Type, G_SalesLine.Type::Item);
        G_SalesLine.SETRANGE("Special Product", TRUE);
        IF G_SalesLine.FINDSET THEN
            REPEAT
                CalculateTariff(G_SalesLine, G_SalesHeader1."Currency Factor");

            UNTIL G_SalesLine.NEXT = 0;



    end;

    var
        G_SalesLine: Record "Sales Line";
        Text001: Label 'Do you want to recalculate price for Sales Order No. %1?';
        G_SalesHeader1: Record 36;

    procedure CalculateTariff(SalesLine2: Record "Sales Line"; Currencyfactor: Decimal)
    var
        //TariffSalesPrice: Record 71001; //"50014";
        DiffVolume: Decimal;
        DiffVolumePrice: Decimal;
        FinalPrice: Decimal;
        SalesLine3: Record "Sales Line";
        statis: page 400;
        Customer2: Record Customer;
        CustomerPriceGroupText: Text[250];
        PriceLineList2: Record "Price List Line";
        L_SalesHeader: Record "Sales Header";
    begin



        if SalesLine2."Special Product" then begin
            CLEAR(DiffVolume);
            CLEAR(DiffVolumePrice);
            CLEAR(FinalPrice);
            Clear(CustomerPriceGroupText);

            if Customer2.get(SalesLine2."Bill-to Customer No.") then begin
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

            if L_SalesHeader.get(SalesLine2."Document Type"::Order, SalesLine2."Document No.") then;

            PriceLineList2.Reset();
            PriceLineList2.SetRange(Status, PriceLineList2.Status::Active);
            PriceLineList2.SetRange("Source Type", PriceLineList2."Source Type"::"Customer Price Group");
            PriceLineList2.SetFilter("Source No.", CustomerPriceGroupText);
            PriceLineList2.SetRange("Asset Type", PriceLineList2."Asset Type"::Item);
            PriceLineList2.Setrange("Asset No.", SalesLine2."No.");
            PriceLineList2.Setrange("Special Product", true);
            PriceLineList2.SetFilter("Ending Date", '>%1|%2', L_SalesHeader."Order Date", 0D);
            PriceLineList2.SetFilter("Starting Date", '<%1|%2', L_SalesHeader."Order Date", 0D);

            IF PriceLineList2.FindFirst() then begin
                if SalesLine2."Unit Volume" >= PriceLineList2."Base Volume" then begin
                    DiffVolume := SalesLine2."Unit Volume" - PriceLineList2."Base Volume";
                    DiffVolumePrice := DiffVolume * PriceLineList2."Cost Unit Thereafter";
                    IF Currencyfactor <> 0 THEN
                        FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price") / Currencyfactor
                    ELSE
                        FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price");

                    SalesLine3.RESET;
                    SalesLine3.SETRANGE(SalesLine3."Document Type", SalesLine2."Document Type");
                    SalesLine3.SETRANGE(SalesLine3."Document No.", SalesLine2."Document No.");
                    SalesLine3.SETRANGE(SalesLine3."Line No.", SalesLine2."Line No.");
                    IF SalesLine3.FINDFIRST THEN BEGIN
                        SalesLine3.VALIDATE(SalesLine3."Unit Price", FinalPrice);
                        SalesLine2.Validate(Rebate, PriceLineList2.Rebate);
                        SalesLine3.MODIFY;
                    END;

                end
                else begin
                    SalesLine3.RESET;
                    SalesLine3.SETRANGE(SalesLine3."Document Type", SalesLine2."Document Type");
                    SalesLine3.SETRANGE(SalesLine3."Document No.", SalesLine2."Document No.");
                    SalesLine3.SETRANGE(SalesLine3."Line No.", SalesLine2."Line No.");
                    IF SalesLine3.FINDFIRST THEN BEGIN
                        SalesLine3.VALIDATE(SalesLine3."Unit Price", PriceLineList2."Unit Price");
                        SalesLine2.Validate(Rebate, PriceLineList2.Rebate);
                        SalesLine3.MODIFY;

                    end;
                end;
            end;

        end;


    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateEventItemNo(var Rec: Record "Sales Line")
    var
        Item2: Record Item;
    begin
        if Item2.get(Rec."No.") then begin
            Rec.Strength := Item2.Strength;
            Rec."Special Product" := Item2."Special Product";
            //Rec."Unit Volume" := Item2."Unit Volume";

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
        CustomerPriceGroupText: Text[250];
        PriceLineList2: Record "Price List Line";
        L_SalesHeader: Record "Sales Header";

    begin
        CLEAR(DiffVolume);
        CLEAR(DiffVolumePrice);
        CLEAR(FinalPrice);
        Clear(CustomerPriceGroupText);

        IF L_SalesHeader.get(Rec."Document Type", Rec."Document No.") then;

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

            IF PriceLineList2.FindFirst() then begin
                if Rec."Unit Volume" >= PriceLineList2."Base Volume" then begin
                    DiffVolume := Rec."Unit Volume" - PriceLineList2."Base Volume";
                    DiffVolumePrice := DiffVolume * PriceLineList2."Cost Unit Thereafter";
                    IF L_SalesHeader."Currency Factor" <> 0 THEN
                        FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price") / L_SalesHeader."Currency Factor"
                    ELSE
                        FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price");

                end
                else begin
                    FinalPrice := PriceLineList2."Unit Price";

                end;


            end;

            Rec.Validate("Unit Price", FinalPrice);
            Rec.Validate(Rebate, PriceLineList2.Rebate);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure Quantity_OnAfterValidateEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var

        DiffVolume: Decimal;
        DiffVolumePrice: Decimal;
        FinalPrice: Decimal;
        SalesLine3: Record "Sales Line";
        statis: page 400;
        Customer2: Record Customer;
        CustomerPriceGroupText: Text[250];
        PriceLineList2: Record "Price List Line";
        L_SalesHeader: Record "Sales Header";

    begin
        CLEAR(DiffVolume);
        CLEAR(DiffVolumePrice);
        CLEAR(FinalPrice);
        Clear(CustomerPriceGroupText);

        IF L_SalesHeader.get(Rec."Document Type", Rec."Document No.") then;

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

            IF PriceLineList2.FindFirst() then begin
                if Rec."Unit Volume" > PriceLineList2."Base Volume" then begin
                    DiffVolume := Rec."Unit Volume" - PriceLineList2."Base Volume";
                    DiffVolumePrice := DiffVolume * PriceLineList2."Cost Unit Thereafter";
                    IF L_SalesHeader."Currency Factor" <> 0 THEN
                        FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price") / L_SalesHeader."Currency Factor"
                    ELSE
                        FinalPrice := (DiffVolumePrice + PriceLineList2."Unit Price");

                end
                else begin
                    FinalPrice := PriceLineList2."Unit Price";

                end;


            end;

            Rec.Validate("Unit Price", FinalPrice);
            Rec.Validate(Rebate, PriceLineList2.Rebate);
        end;
    end;
}