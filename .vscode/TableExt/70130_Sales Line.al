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
            //Caption = 'Inventory';
            Caption = 'Total Physical';
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
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No."),
                                                                            "Location Code" = FIELD("Location Code"),
                                                                            "Drop Shipment" = FIELD("Drop Shipment"),
                                                                            "Variant Code" = FIELD("Variant Code"),
                                                                            "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                            "Outstanding Qty. (Base)" = filter(> 0)));
            //Caption = 'Allocated';
            Caption = 'Total Allocated';
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
        field(70138; "Last Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70139; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70140; "Parent Category"; Code[20])
        {
        }
        field(70141; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70142; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70143; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
        }
        field(70145; "Qty on SO(Saleable)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = CONST(Order), Type = CONST(Item), "No." = field("No."), "Variant Code" = field("Variant Code"), "Outstanding Quantity" = filter(> 0), "Saleable Location" = const(true), "Location Code" = field("Location Code"), "Drop Shipment" = FIELD("Drop Shipment"), "Unit of Measure Code" = FIELD("Unit of Measure Code")));
            DecimalPlaces = 0 : 5;
            //Caption = 'Qty on Sales Order (Saleable)';
            Caption = 'Allocated (Saleable)';
        }
        field(70146; "Saleable Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Variant Code" = FIELD("Variant Code"), "Saleable Location" = const(true), "Location Code" = field("Location Code"), "Unit of Measure Code" = FIELD("Unit of Measure Code"), "Drop Shipment" = FIELD("Drop Shipment")));
            //Caption = 'Saleable Inventory';
            Caption = 'Physical (Saleable)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70147; "UnShipped Qty."; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No."),
                                                                            "Location Code" = FIELD("Location Code"),
                                                                            "Drop Shipment" = FIELD("Drop Shipment"),
                                                                            "Variant Code" = FIELD("Variant Code"),
                                                                            "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                            "Outstanding Qty. (Base)" = filter(> 0)));
            Caption = 'UnShipped Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }

        // modify("Unit Price")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         UserSetup: Record "User Setup";
        //         DisUnitPrice: Decimal;
        //     begin
        //         if Rec."Unit Price" > 0 then begin
        //             Clear(DisUnitPrice);
        //             UserSetup.Reset();
        //             UserSetup.SetRange("User ID", UserId);
        //             UserSetup.SetRange("Allow to change unit price", true);
        //             if not UserSetup.FindFirst() then begin
        //                 if Rec."Min Sell Price" > 0 then begin
        //                     if Rec."Unit Price" < Rec."Min Sell Price" then begin
        //                         Error('Unit price should not be less than Min Sell Price');
        //                     end;
        //                 end else begin
        //                     DisUnitPrice := (xRec."Unit Price" / 100) * 10;
        //                     if (xRec."Unit Price" - DisUnitPrice) > Rec."Unit Price" then
        //                         Error('Unit price should not be less than %1', xRec."Unit Price" - DisUnitPrice);
        //                 end;
        //             end;
        //         end;
        //     end;
        // }

        modify("Unit Price")
        {
            trigger OnAfterValidate()
            var
                UserSetup: Record "User Setup";
                DisUnitPrice: Decimal;
            begin
                Clear(DisUnitPrice);
                UserSetup.Reset();
                UserSetup.SetRange("User ID", UserId);
                UserSetup.SetRange("Allow to change unit price", true);
                if not UserSetup.FindFirst() then begin
                    if Rec."Min Sell Price" > 0 then begin
                        if Rec."Unit Price" < Rec."Min Sell Price" then begin
                            Error('Unit price should not be less than Min Sell Price');
                        end;
                    end else begin
                        if CurrFieldNo = 22 then begin
                            DisUnitPrice := (xRec."Unit Price" / 100) * 10;
                            if (xRec."Unit Price" - DisUnitPrice) > Rec."Unit Price" then
                                Error('Unit price should not be less than %1', xRec."Unit Price" - DisUnitPrice);
                        end;
                    end;
                end;
            end;
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
                CH_SShip: Record "Sales Shipment Line";
                L_ItemUnitofMeasure: Record "Item Unit of Measure";
                ShippingAgent: Record "Shipping Agent";
                L_Function: Codeunit "SC Events & Subscriber";
                UserSetup: Record "User Setup";
                DisUnitPrice: Decimal;
                L_Location: Record Location;
                ConsolidateWarehouseShipment: Codeunit "Consolidate Warehouse Shipment";
            begin
                if (Rec.Type = Rec.Type::Item) then begin
                    L_SalesHeader.Reset();
                    L_SalesHeader.SetRange("No.", Rec."Document No.");
                    L_SalesHeader.SetRange("Document Type", Rec."Document Type");
                    if L_SalesHeader.FindFirst() then begin
                        //++Shipping Agent Restriction(18274)
                        if L_SalesHeader."Shipping Agent Code" <> '' then begin
                            L_Function.CheckShippingAgentRestriction(L_SalesHeader, Rec);
                        end;

                        //++Sales Order warning message(15813)
                        L_Function.SalesOrderWarningMessage(L_SalesHeader, Rec);
                    end;

                    L_Item.Reset();
                    L_Item.SetRange("No.", Rec."No.");
                    if L_Item.FindFirst() then begin
                        Rec."Min Sell Price" := L_Item."Min Sell Price";
                        Rec."Parent Category" := L_Item."Parent Category";
                    end;

                    L_ItemUnitofMeasure.Reset();
                    L_ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
                    L_ItemUnitofMeasure.SetRange(Code, Rec."Unit of Measure Code");
                    if L_ItemUnitofMeasure.FindFirst() then begin
                        Rec."Shipper Qty." := L_ItemUnitofMeasure."Shipper Qty.";
                        Rec."Outer Qty." := L_ItemUnitofMeasure."Outer Qty.";
                        Rec."Pallet Qty." := L_ItemUnitofMeasure."Pallet Qty.";
                    end;

                    CH_SShip.Reset();
                    CH_SShip.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    CH_SShip.SetRange("No.", Rec."No.");
                    CH_SShip.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                    if CH_SShip.FindLast() then
                        Rec."Last Price" := CH_SShip."Unit Price";

                    Clear(DisUnitPrice);
                    UserSetup.Reset();
                    UserSetup.SetRange("User ID", UserId);
                    UserSetup.SetRange("Allow to change unit price", true);
                    if not UserSetup.FindFirst() then begin
                        if Rec."Min Sell Price" > 0 then begin
                            if Rec."Unit Price" < Rec."Min Sell Price" then begin
                                Error('Unit price should not be less than Min Sell Price');
                            end;
                        end else begin
                            DisUnitPrice := (xRec."Unit Price" / 100) * 10;
                            if (xRec."Unit Price" - DisUnitPrice) > Rec."Unit Price" then
                                Error('Unit price should not be less than %1', xRec."Unit Price" - DisUnitPrice);
                        end;
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
                if CurrFieldNo = 15 then begin
                    // L_SalesHeader.Reset();
                    // L_SalesHeader.SetRange("No.", Rec."Document No.");
                    // L_SalesHeader.SetRange("Document Type", Rec."Document Type");
                    // if L_SalesHeader.FindFirst() then begin
                    //     if CheckWholesaleCustomer(L_SalesHeader) = true then begin
                    //         Clear(L_NextMultipleNumber);
                    //         Clear(L_CalculateNumber);
                    //         if (Rec.Type = Rec.Type::Item) AND (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Quantity <> 0) then begin
                    //             L_ItemUOM.Reset();
                    //             L_ItemUOM.SetRange("Item No.", Rec."No.");
                    //             L_ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                    //             L_ItemUOM.SetFilter("Sales Order multiple", '>%1', 0);
                    //             if L_ItemUOM.FindFirst() then begin
                    //                 if Rec.Quantity MOD L_ItemUOM."Sales Order multiple" <> 0 then
                    //                     if confirm(StrSubstNo('Quantity should be multiple of UOM "%1" quantity. Do you want to continue?', L_ItemUOM."Sales Order multiple"), true) then begin
                    //                         L_CalculateNumber := Round(Rec.Quantity / L_ItemUOM."Sales Order multiple", 1, '<') + 1;
                    //                         L_NextMultipleNumber := L_ItemUOM."Sales Order multiple" * L_CalculateNumber;
                    //                         Rec.Validate(Quantity, L_NextMultipleNumber);
                    //                     end;
                    //             end;

                    //         end;
                    //     end;
                    // end;


                    //GHST Customization++
                    if (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Type = Rec.Type::Item) then begin
                        Rec.TestField("Quantity Shipped", 0);
                        if Rec.Quantity <> xRec.Quantity then
                            Rec.Validate("Variant Code", '');
                    end;
                end;
            end;
        }

        modify("Variant Code")
        {

            trigger OnAfterValidate()
            begin
                if CurrFieldNo > 0 then begin
                    //GHST Customization++
                    if (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Type = Rec.Type::Item) then begin
                        Rec.TestField("Quantity Shipped", 0);
                    end;
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
                // if CurrFieldNo > 0 then begin
                //     if Rec."Unit of Measure Code" <> '' then begin
                //         L_SalesHeader.Reset();
                //         L_SalesHeader.SetRange("No.", Rec."Document No.");
                //         L_SalesHeader.SetRange("Document Type", Rec."Document Type");
                //         if L_SalesHeader.FindFirst() then begin
                //             if CheckWholesaleCustomer(L_SalesHeader) = true then begin
                //                 Clear(L_NextMultipleNumber);
                //                 Clear(L_CalculateNumber);
                //                 if (Rec.Type = Rec.Type::Item) AND (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec.Quantity <> 0) then begin
                //                     L_ItemUOM.Reset();
                //                     L_ItemUOM.SetRange("Item No.", Rec."No.");
                //                     L_ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                //                     L_ItemUOM.SetFilter("Sales Order multiple", '>%1', 0);
                //                     if L_ItemUOM.FindFirst() then begin
                //                         if Rec.Quantity MOD L_ItemUOM."Sales Order multiple" <> 0 then
                //                             if confirm(StrSubstNo('Quantity should be multiple of UOM "%1" quantity. Do you want to continue?', L_ItemUOM."Sales Order multiple"), true) then begin
                //                                 L_CalculateNumber := Round(Rec.Quantity / L_ItemUOM."Sales Order multiple", 1, '<') + 1;
                //                                 L_NextMultipleNumber := L_ItemUOM."Sales Order multiple" * L_CalculateNumber;
                //                                 Rec.Validate(Quantity, L_NextMultipleNumber);
                //                             end;
                //                     end;
                //                 end;
                //             end;
                //         end;
                //     end;
                // end;

            end;
        }
    }

    var
        myInt: Integer;
        tes: Record "Item Reference";

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
}