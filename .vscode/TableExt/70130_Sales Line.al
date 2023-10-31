tableextension 70130 "SC Sales Line" extends "Sales Line"
{
    fields
    {
        field(70130; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Location Code" = FIELD("Location Code"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment"),
                                                                  "Variant Code" = FIELD("Variant Code"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70131; "Qty. on Purch. Order"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
                                                                               Type = CONST(Item),
                                                                               "No." = FIELD("No."),
                                                                               "Location Code" = FIELD("Location Code"),
                                                                               "Drop Shipment" = FIELD("Drop Shipment"),
                                                                               "Variant Code" = FIELD("Variant Code"),
                                                                               "Unit of Measure Code" = FIELD("Unit of Measure Code")));
            Caption = 'Qty. on Purch. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70132; "Allocated"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No."),
                                                                            "Location Code" = FIELD("Location Code"),
                                                                            "Drop Shipment" = FIELD("Drop Shipment"),
                                                                            "Variant Code" = FIELD("Variant Code"),
                                                                            "Unit of Measure Code" = FIELD("Unit of Measure Code")));
            Caption = 'Allocated';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }

        field(70133; "Min Sell Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70134; "Original Quantity"; Decimal)
        {
            //GHST Customization++
            //DOnt Use this for another process++
        }
        field(70135; "Variant Assigned"; Boolean)
        {
            //GHST Customization++
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("Document No."), "Variant Code" = filter(<> '')));
        }
        field(70136; "Variant Code mandatory"; Boolean)
        {
            //GHST Customization++
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("No.")));
        }
        field(70137; "Variant Created By"; Integer)
        {
            //GHST Customization++
        }
        // Add changes to table fields here
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                L_SalesHeader: Record "Sales Header";
                L_Item: Record Item;
                _Codeunit: Codeunit "SC Events & Subscriber";
                L_ItemVariant: Record "Item Variant";
            begin
                if (Rec.Type = Rec.Type::Item) AND (Rec."Document Type" = Rec."Document Type"::Order) then begin
                    L_SalesHeader.Reset();
                    L_SalesHeader.SetRange("No.", Rec."Document No.");
                    L_SalesHeader.SetRange("Document Type", Rec."Document Type");
                    if L_SalesHeader.FindFirst() then begin
                        if CheckOOHCustomer(L_SalesHeader) = true then begin
                            if Rec."No." <> '' then begin
                                CheckItemAttribute(Rec)
                            end;
                        end;
                    end;


                    L_Item.Reset();
                    L_Item.SetRange("No.", Rec."No.");
                    if L_Item.FindFirst() then begin
                        Rec."Min Sell Price" := L_Item."Min Sell Price";
                    end;
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                L_ItemUOM: Record "Item Unit of Measure";
                L_CalculateNumber: Decimal;
                L_NextMultipleNumber: Decimal;
                L_SalesHeader: Record "Sales Header";
            begin
                L_SalesHeader.Reset();
                L_SalesHeader.SetRange("No.", Rec."Document No.");
                L_SalesHeader.SetRange("Document Type", Rec."Document Type");
                if L_SalesHeader.FindFirst() then begin
                    if CheckWholesaleCustomer(L_SalesHeader) = true then begin
                        Clear(L_NextMultipleNumber);
                        Clear(L_CalculateNumber);
                        if (Rec.Type = Rec.Type::Item) AND (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Quantity <> 0) then begin
                            L_ItemUOM.Reset();
                            L_ItemUOM.SetRange("Item No.", Rec."No.");
                            L_ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                            L_ItemUOM.SetRange("Sales Order multiple", true);
                            if L_ItemUOM.FindFirst() then begin
                                if Rec.Quantity MOD L_ItemUOM."Qty. per Unit of Measure" <> 0 then
                                    if confirm(StrSubstNo('Quantity should be multiple of UOM "%1". Do you want to continue?', L_ItemUOM.Code), true) then begin
                                        L_CalculateNumber := Round(Rec.Quantity / L_ItemUOM."Qty. per Unit of Measure", 1, '<') + 1;
                                        L_NextMultipleNumber := L_ItemUOM."Qty. per Unit of Measure" * L_CalculateNumber;
                                        Rec.Validate(Quantity, L_NextMultipleNumber);
                                    end;
                            end;

                        end;
                    end;
                end;

                //GHST Customization++
                if (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Type = Rec.Type::Item) then begin
                    Rec.TestField("Quantity Shipped", 0);
                    if Rec.Quantity <> xRec.Quantity then
                        Rec.Validate("Variant Code", '');
                end;

            end;
        }

        modify("Variant Code")
        {

            trigger OnAfterValidate()
            begin
                //GHST Customization++
                if (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Type = Rec.Type::Item) then begin
                    Rec.TestField("Quantity Shipped", 0);
                end;
            end;
        }

        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            var
                L_ItemUOM: Record "Item Unit of Measure";
                L_CalculateNumber: Decimal;
                L_NextMultipleNumber: Decimal;
                L_SalesHeader: Record "Sales Header";
            begin
                if Rec."Unit of Measure Code" <> '' then begin
                    L_SalesHeader.Reset();
                    L_SalesHeader.SetRange("No.", Rec."Document No.");
                    L_SalesHeader.SetRange("Document Type", Rec."Document Type");
                    if L_SalesHeader.FindFirst() then begin
                        if CheckWholesaleCustomer(L_SalesHeader) = true then begin
                            Clear(L_NextMultipleNumber);
                            Clear(L_CalculateNumber);
                            if (Rec.Type = Rec.Type::Item) AND (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Quantity <> 0) then begin
                                L_ItemUOM.Reset();
                                L_ItemUOM.SetRange("Item No.", Rec."No.");
                                L_ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                                L_ItemUOM.SetRange("Sales Order multiple", true);
                                if L_ItemUOM.FindFirst() then begin
                                    if Rec.Quantity MOD L_ItemUOM."Qty. per Unit of Measure" <> 0 then
                                        if confirm(StrSubstNo('Quantity should be multiple of UOM "%1". Do you want to continue?', L_ItemUOM.Code), true) then begin
                                            L_CalculateNumber := Round(Rec.Quantity / L_ItemUOM."Qty. per Unit of Measure", 1, '<') + 1;
                                            L_NextMultipleNumber := L_ItemUOM."Qty. per Unit of Measure" * L_CalculateNumber;
                                            Rec.Validate(Quantity, L_NextMultipleNumber);
                                        end;
                                end;

                            end;
                        end;
                    end;
                end;

            end;
        }
    }

    var
        myInt: Integer;
        tes: Record Item;

    local procedure CheckWholesaleCustomer(L_SalesHeader: Record "Sales Header"): Boolean
    var
        L_DimensionSetEntry: Record "Dimension Set Entry";
    begin
        L_DimensionSetEntry.Reset();
        L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesHeader."Dimension Set ID");
        L_DimensionSetEntry.SetRange("Dimension Code", 'CUSTOMER TYPE');
        L_DimensionSetEntry.SetRange("Dimension Value Code", 'WHOLESALE');
        if L_DimensionSetEntry.FindFirst() then
            exit(true);
    end;

    local procedure CheckOOHCustomer(_SalesHeader: Record "Sales Header"): Boolean
    var
        L_DimensionSetEntry: Record "Dimension Set Entry";
    begin
        L_DimensionSetEntry.SetRange("Dimension Set ID", _SalesHeader."Dimension Set ID");
        L_DimensionSetEntry.SetRange("Dimension Code", 'CUSTOMER TYPE');
        L_DimensionSetEntry.SetRange("Dimension Value Code", 'OOH');
        if L_DimensionSetEntry.FindFirst() then
            exit(true);

    end;

    local procedure CheckItemAttribute(_SalesLine: Record "Sales Line")
    var
        RecItemAttValMap: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
        L_SalesOrderwarningMngSetup: Record "Sales Order warning Mng. Setup";
    begin
        RecItemAttValMap.Reset();
        RecItemAttValMap.SetRange("Table ID", 27);
        RecItemAttValMap.SetRange("No.", _SalesLine."No.");
        if RecItemAttValMap.FindSet() then begin
            repeat
                ItemAttribute.Reset();
                ItemAttribute.SetRange(ID, RecItemAttValMap."Item Attribute ID");
                if ItemAttribute.FindFirst() then begin
                    ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
                    ItemAttributeValue.SetRange(ID, RecItemAttValMap."Item Attribute Value ID");
                    if ItemAttributeValue.FindFirst() then begin
                        if (UpperCase(ItemAttributeValue.Value) = UpperCase('CD-3')) OR (UpperCase(ItemAttributeValue.Value) = UpperCase('CD-2')) then begin
                            L_SalesOrderwarningMngSetup.Reset();
                            L_SalesOrderwarningMngSetup.SetRange("Dimension Code", 'CUSTOMER TYPE');
                            L_SalesOrderwarningMngSetup.SetRange("Dimension Value", 'OOH');
                            L_SalesOrderwarningMngSetup.SetRange("Attribute Value", ItemAttributeValue.Value);
                            L_SalesOrderwarningMngSetup.SetRange("Attribute value ID", ItemAttributeValue.ID);
                            L_SalesOrderwarningMngSetup.SetRange("Attribute ID", ItemAttributeValue."Attribute ID");
                            if L_SalesOrderwarningMngSetup.FindFirst() then
                                Message('CD Requestion form is required for the item %1', _SalesLine."No.");

                        end;
                    end;
                end;
            until RecItemAttValMap.Next() = 0;
        end;
    end;

}