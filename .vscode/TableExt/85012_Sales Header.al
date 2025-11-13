tableextension 85012 "SC Sales Header" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                L_Customer: Record Customer;
                L_SalesPriceHeader: Record "Price List Header";
                L_Date: Record Date;
                L_ShipingAgentService: Record "Shipping Agent Services";
                L_BlankDatFormula: DateFormula;
                //CheckCreditLimit: codeunit "Cust-Check Cr. Limit";
                L_BilltoCustomer: Record Customer;
                L_UserSetp: Record "User Setup";
            begin
                if Rec."Sell-to Customer No." <> '' then begin
                    if Rec."IRP Order" = true then
                        Rec."Order Category" := Rec."Order Category"::Web
                    else begin
                        Rec.CalcFields("Special Order", "Drop/Special Order");
                        if (Rec."Special Order" = true) OR (Rec."Drop/Special Order" = true) then begin
                            Rec."Order Category" := Rec."Order Category"::"Special/DropShipment";
                        end else begin
                            L_UserSetp.Reset();
                            L_UserSetp.SetRange("User ID", UserId);
                            if L_UserSetp.FindFirst() then begin
                                Rec."Order Category" := L_UserSetp."Order Category";
                            end;
                        end;
                    end;

                    L_Customer.Reset();
                    L_Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if L_Customer.FindFirst() then begin
                        L_Customer.CalcFields("Balance (LCY)");
                        if L_Customer."Type of Account" = L_Customer."Type of Account"::Stock then begin
                            if Rec."IRP Order" = false then begin //As discussed with Adesh+++
                                L_Customer.TestField("QAU Approved");
                                L_Customer.TestField(Status, L_Customer.Status::Released);

                                // //Check Credit Limit & Balance Due+++
                                // //Have managed all the conditions in default code (Codeunit 85007). But when we create sales order from customer card page (New Sales Order) then this default code not working as sigma process. to manage this scanrio have added the below code also.
                                // CheckCreditLimit.SalesHeaderCheck(Rec);
                            end;
                        end;

                        Rec.Validate("Delivery Note", L_Customer."Delivery Note");
                        Rec.Validate("Collection Note", L_Customer."Collection Note");
                        Rec.Validate(_Invoice, L_Customer.Invoice);
                        Rec.Validate("Packing list", L_Customer."Packing list");
                        Rec.Validate("Export Checklist", L_Customer."Export Checklist");
                        Rec.Validate("Data Logger Sheet", L_Customer."Data Logger Sheet");
                        Rec.Validate(Labels, L_Customer.Labels);
                        Rec.Validate("Extra Documents", L_Customer."Extra Documents");
                        Rec."Send By" := L_Customer."Send By";
                        Rec."QAU Approved" := L_Customer."QAU Approved";
                        Rec."Default Bank" := L_Customer."Default Bank";
                        Rec."Min Order Value" := L_Customer."Min Order Value";
                        // Rec."Weekend Shipping Agent Code" := L_Customer."Weekend Shipping Agent Code";
                        // Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                        Rec."SO Approval Required" := L_Customer."SO Approval Required";

                        L_BilltoCustomer.Reset();
                        L_BilltoCustomer.SetRange("No.", Rec."Bill-to Customer No.");
                        if L_BilltoCustomer.FindFirst() then begin
                            Rec.Hospital := L_BilltoCustomer.Hospital; //Exempt from Credit check
                            Rec."Exempt from Overdue check" := L_BilltoCustomer."Exempt from Overdue check";
                        end;


                        //Manul & Web Order+++
                        L_Date.Reset();
                        L_Date.SetRange(L_Date."Period Type", L_Date."Period Type"::Date);
                        L_Date.SetRange(L_Date."Period Start", WorkDate());
                        if L_Date.FindFirst() then begin
                            if UpperCase(L_Date."Period Name") = UpperCase('FRIDAY') then begin
                                Rec."Weekend Shipping Agent Code" := L_Customer."Weekend Shipping Agent Code";
                                Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                            end;
                        end;

                        Rec."Order Time" := DT2Time(rec.SystemCreatedAt);

                        //This code moved into Ochannel Extension [For Manual, and Web Order all process]
                        // L_Date.Reset();
                        // L_Date.SetRange(L_Date."Period Type", L_Date."Period Type"::Date);
                        // L_Date.SetRange(L_Date."Period Start", WorkDate());
                        // if L_Date.FindFirst() then
                        //     if UpperCase(L_Date."Period Name") = UpperCase('FRIDAY') then begin
                        //         Rec."Weekend Shipping Agent Code" := L_Customer."Weekend Shipping Agent Code";
                        //         Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                        //         if Rec."Weekend Ship. Agnt. Serv. Code" <> '' then
                        //             //Update Saturday++
                        //             Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()))
                        //         else begin
                        //             //Update Monday
                        //             Rec.Validate("Shipment Date", CalcDate('<+3D>', WorkDate()));
                        //         end;
                        //     end else begin
                        //         //As discussed shipment date shoud be next day all condistion++
                        //         Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()));

                        //         // //New Code based on calendar+++
                        //         // if UpperCase(L_Date."Period Name") = UpperCase('SATURDAY') then begin
                        //         //     if L_Customer."Base Calendar Code" <> '' then
                        //         //         Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //     else begin
                        //         //         L_ShipingAgentService.Reset();
                        //         //         L_ShipingAgentService.SetRange("Shipping Agent Code", L_Customer."Shipping Agent Code");
                        //         //         L_ShipingAgentService.SetRange(Code, L_Customer."Shipping Agent Service Code");
                        //         //         if L_ShipingAgentService.FindFirst() then begin
                        //         //             if L_ShipingAgentService."Base Calendar Code" <> '' then
                        //         //                 Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //             else
                        //         //                 //Update Monday
                        //         //                 Rec.Validate("Shipment Date", CalcDate('<+2D>', WorkDate()));
                        //         //         end;
                        //         //     end;
                        //         // end else begin
                        //         //     if L_Customer."Base Calendar Code" <> '' then
                        //         //         Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //     else begin
                        //         //         L_ShipingAgentService.Reset();
                        //         //         L_ShipingAgentService.SetRange("Shipping Agent Code", L_Customer."Shipping Agent Code");
                        //         //         L_ShipingAgentService.SetRange(Code, L_Customer."Shipping Agent Service Code");
                        //         //         if L_ShipingAgentService.FindFirst() then begin
                        //         //             if L_ShipingAgentService."Base Calendar Code" <> '' then
                        //         //                 Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //             else begin
                        //         //                 if L_Customer."Shipping Time" <> L_BlankDatFormula then begin
                        //         //                     Rec.Validate("Shipment Date", CalcDate(L_Customer."Shipping Time", Rec."Shipment Date"))
                        //         //                 end else begin
                        //         //                     L_ShipingAgentService.Reset();
                        //         //                     L_ShipingAgentService.SetRange("Shipping Agent Code", L_Customer."Shipping Agent Code");
                        //         //                     L_ShipingAgentService.SetRange(Code, L_Customer."Shipping Agent Service Code");
                        //         //                     if L_ShipingAgentService.FindFirst() then begin
                        //         //                         if L_ShipingAgentService."Shipping Time" <> L_BlankDatFormula then
                        //         //                             Rec.Validate("Shipment Date", CalcDate(L_ShipingAgentService."Shipping Time", Rec."Shipment Date"));
                        //         //                     end;
                        //         //                 end;
                        //         //             end;
                        //         //         end;
                        //         //     end;
                        //         // end;
                        //     end;
                        //This code moved into Ochannel Extension [For Manual, and Web Order all process]

                        if ((Rec."Document Type" = Rec."Document Type"::"Return Order") OR (Rec."Document Type" = Rec."Document Type"::"Credit Memo")) then begin //SBB-228
                            Rec.Validate("Shipping Agent Code", L_Customer."Shipping Agent Code");
                            Rec.Validate("Shipping Agent Service Code", L_Customer."Shipping Agent Service Code");
                        end;
                    end;

                    // "Special Price Daily" should be only one++
                    L_SalesPriceHeader.Reset();
                    L_SalesPriceHeader.SetRange("Special Price Daily", true);
                    if L_SalesPriceHeader.FindFirst() then
                        Rec."Sales Price List Code" := L_SalesPriceHeader.Code;
                end;
            end;
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var
                L_Customer: Record Customer;
                L_SalesPriceHeader: Record "Price List Header";
                L_Date: Record Date;
                L_BilltoCustomer: Record Customer;
            begin
                if Rec."Sell-to Customer Name" <> '' then begin
                    L_Customer.Reset();
                    L_Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if L_Customer.FindFirst() then begin
                        if Rec."IRP Order" = false then begin //As discussed with Adesh+++
                            L_Customer.TestField("QAU Approved");
                            L_Customer.TestField(Status, L_Customer.Status::Released);
                        end;

                        Rec.Validate("Delivery Note", L_Customer."Delivery Note");
                        Rec.Validate("Collection Note", L_Customer."Collection Note");
                        Rec.Validate(_Invoice, L_Customer.Invoice);
                        Rec.Validate("Packing list", L_Customer."Packing list");
                        Rec.Validate("Export Checklist", L_Customer."Export Checklist");
                        Rec.Validate("Data Logger Sheet", L_Customer."Data Logger Sheet");
                        Rec.Validate(Labels, L_Customer.Labels);
                        Rec.Validate("Extra Documents", L_Customer."Extra Documents");
                        Rec."Send By" := L_Customer."Send By";
                        Rec."QAU Approved" := L_Customer."QAU Approved";
                        Rec."Default Bank" := L_Customer."Default Bank";
                        Rec."Min Order Value" := L_Customer."Min Order Value";
                        // Rec."Weekend Shipping Agent Code" := L_Customer."Weekend Shipping Agent Code";
                        // Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                        Rec."SO Approval Required" := L_Customer."SO Approval Required";

                        L_BilltoCustomer.Reset();
                        L_BilltoCustomer.SetRange("No.", Rec."Bill-to Customer No.");
                        if L_BilltoCustomer.FindFirst() then begin
                            Rec.Hospital := L_BilltoCustomer.Hospital; //Exempt from Credit check
                            Rec."Exempt from Overdue check" := L_BilltoCustomer."Exempt from Overdue check";
                        end;

                        L_Date.Reset();
                        L_Date.SetRange(L_Date."Period Type", L_Date."Period Type"::Date);
                        L_Date.SetRange(L_Date."Period Start", WorkDate());
                        if L_Date.FindFirst() then begin
                            if UpperCase(L_Date."Period Name") = UpperCase('FRIDAY') then begin
                                Rec."Weekend Shipping Agent Code" := L_Customer."Weekend Shipping Agent Code";
                                Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                            end;
                        end;

                        //This code moved into Ochannel Extension [For Manual, and Web Order all process]
                        // L_Date.Reset();
                        // L_Date.SetRange(L_Date."Period Type", L_Date."Period Type"::Date);
                        // L_Date.SetRange(L_Date."Period Start", WorkDate());
                        // if L_Date.FindFirst() then
                        //     if UpperCase(L_Date."Period Name") = UpperCase('FRIDAY') then begin
                        //         Rec."Weekend Shipping Agent Code" := L_Customer."Weekend Shipping Agent Code";
                        //         Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                        //         if Rec."Weekend Ship. Agnt. Serv. Code" <> '' then
                        //             //Update Saturday++
                        //             Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()))
                        //         else begin
                        //             //Update Monday
                        //             Rec.Validate("Shipment Date", CalcDate('<+3D>', WorkDate()));
                        //         end;
                        //     end else begin
                        //         //As discussed shipment date shoud be next day all condistion++
                        //         Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()));

                        //         // //New Code based on calendar+++
                        //         // if UpperCase(L_Date."Period Name") = UpperCase('SATURDAY') then begin
                        //         //     if L_Customer."Base Calendar Code" <> '' then
                        //         //         Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //     else begin
                        //         //         L_ShipingAgentService.Reset();
                        //         //         L_ShipingAgentService.SetRange("Shipping Agent Code", L_Customer."Shipping Agent Code");
                        //         //         L_ShipingAgentService.SetRange(Code, L_Customer."Shipping Agent Service Code");
                        //         //         if L_ShipingAgentService.FindFirst() then begin
                        //         //             if L_ShipingAgentService."Base Calendar Code" <> '' then
                        //         //                 Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //             else
                        //         //                 //Update Monday
                        //         //                 Rec.Validate("Shipment Date", CalcDate('<+2D>', WorkDate()));
                        //         //         end;
                        //         //     end;
                        //         // end else begin
                        //         //     if L_Customer."Base Calendar Code" <> '' then
                        //         //         Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //     else begin
                        //         //         L_ShipingAgentService.Reset();
                        //         //         L_ShipingAgentService.SetRange("Shipping Agent Code", L_Customer."Shipping Agent Code");
                        //         //         L_ShipingAgentService.SetRange(Code, L_Customer."Shipping Agent Service Code");
                        //         //         if L_ShipingAgentService.FindFirst() then begin
                        //         //             if L_ShipingAgentService."Base Calendar Code" <> '' then
                        //         //                 Rec.Validate("Shipment Date", Rec.CalcPlannedShptDate(21))
                        //         //             else begin
                        //         //                 if L_Customer."Shipping Time" <> L_BlankDatFormula then begin
                        //         //                     Rec.Validate("Shipment Date", CalcDate(L_Customer."Shipping Time", Rec."Shipment Date"))
                        //         //                 end else begin
                        //         //                     L_ShipingAgentService.Reset();
                        //         //                     L_ShipingAgentService.SetRange("Shipping Agent Code", L_Customer."Shipping Agent Code");
                        //         //                     L_ShipingAgentService.SetRange(Code, L_Customer."Shipping Agent Service Code");
                        //         //                     if L_ShipingAgentService.FindFirst() then begin
                        //         //                         if L_ShipingAgentService."Shipping Time" <> L_BlankDatFormula then
                        //         //                             Rec.Validate("Shipment Date", CalcDate(L_ShipingAgentService."Shipping Time", Rec."Shipment Date"));
                        //         //                     end;
                        //         //                 end;
                        //         //             end;
                        //         //         end;
                        //         //     end;
                        //         // end;
                        //     end;
                        //This code moved into Ochannel Extension [For Manual, and Web Order all process]




                        if Rec."Document Type" = Rec."Document Type"::"Return Order" then begin
                            Rec.Validate("Shipping Agent Code", L_Customer."Shipping Agent Code");
                            Rec.Validate("Shipping Agent Service Code", L_Customer."Shipping Agent Service Code");
                        end;
                    end;


                    // "Special Price Daily" should be only one++
                    L_SalesPriceHeader.Reset();
                    L_SalesPriceHeader.SetRange("Special Price Daily", true);
                    if L_SalesPriceHeader.FindFirst() then
                        Rec."Sales Price List Code" := L_SalesPriceHeader.Code;
                end;
            end;
        }
        modify("Shipping Agent Code")
        {
            trigger OnBeforeValidate()
            var
                ShippingAgent: Record "Shipping Agent";
            begin
                if Rec."Shipping Agent Code" <> '' then begin
                    ShippingAgent.Reset();
                    ShippingAgent.SetRange(code, Rec."Shipping Agent Code");
                    ShippingAgent.SetRange(Status, ShippingAgent.Status::Released);
                    if Not ShippingAgent.FindFirst() then
                        Error('Status must be equal to Released in Shipping Agent');

                    ShippingAgent.Reset();
                    ShippingAgent.SetRange(Code, Rec."Shipping Agent Code");
                    if ShippingAgent.FindFirst() then begin
                        ShippingAgent.TestField("Service Type", ShippingAgent."Service Type"::Out);
                    end;
                end;
            end;
        }
        modify("Shipping Agent Service Code")
        {
            trigger OnBeforeValidate()
            var
                ShippingAgentServices: Record "Shipping Agent Services";
            begin
                if Rec."Shipping Agent Service Code" <> '' then begin
                    ShippingAgentServices.Reset();
                    ShippingAgentServices.SetRange(code, Rec."Shipping Agent Service Code");
                    ShippingAgentServices.SetRange(Status, ShippingAgentServices.Status::Released);
                    if Not ShippingAgentServices.FindFirst() then
                        Error('Status must be equal to Released in Shipping Agent Service');
                end;
            end;
        }

        // Add changes to table fields here
        field(85131; "Delivery Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85132; "Collection Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85133; "_Invoice"; Boolean)
        {
            Caption = 'Invoice';
            DataClassification = ToBeClassified;
        }
        field(85134; "Packing list"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85135; "Export Checklist"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85136; "Data Logger Sheet"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85137; "Labels"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85138; "Extra Documents"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(85139; "Sheet Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85140; "Import Date"; Date)
        {

        }
        field(85141; "Sales Price List Code"; Code[50])
        {

        }
        field(85142; "Send By"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Email,Print,"Email & Print";
        }
        field(85144; "Default Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(85145; "QAU Approved"; Boolean)
        {

        }
        field(85146; "Pick Registered"; Boolean)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Shipment Line" where("Source No." = field("No."), "Source Document" = const("Sales Order"), "Qty. Picked" = filter(> 0)));
        }
        field(85148; "Shortcut Dimension 3 Code"; Code[50])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '85148,83';
        }
        field(85149; "Warehouse Shipment Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Shipment Line" where("Source Document" = filter("Sales Order"), "Source No." = field("No.")));
        }
        field(85150; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(85151; "Weekend Ship. Agnt. Serv. Code"; Code[10])
        {
            Caption = 'Weekend Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Weekend Shipping Agent Code"));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                ShippingAgentServices: Record "Shipping Agent Services";
            begin
                if Rec."Weekend Ship. Agnt. Serv. Code" <> '' then begin
                    ShippingAgentServices.Reset();
                    ShippingAgentServices.SetRange(code, Rec."Weekend Ship. Agnt. Serv. Code");
                    ShippingAgentServices.SetRange(Status, ShippingAgentServices.Status::Released);
                    if Not ShippingAgentServices.FindFirst() then
                        Error('Status must be equal to Released in Shipping Agent Service');
                end;
            end;
        }
        field(85152; "SO Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85153; "IRP Order"; Boolean)
        {

        }
        field(85154; "Return Order No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Return Order No." where("Document No." = field("No."), "Document Type" = field("Document Type"), Type = const(Item)));
            Editable = false;
        }
        field(85156; "Rejection"; Boolean)
        {

        }
        field(85157; "Inv. Pick Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Activity Header" where("Source No." = field("No."), "Source Document" = const("Sales Order")));
        }
        field(85158; "No of Boxes"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(85159; "Weekend Shipping Agent Code"; Text[30])
        {
            Caption = 'Weekend Shipping Agent Code';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Agent";
            Editable = false;

            trigger OnValidate()
            var
                ShippingAgent: Record "Shipping Agent";
            begin
                if Rec."Weekend Shipping Agent Code" <> '' then begin
                    ShippingAgent.Reset();
                    ShippingAgent.SetRange(code, Rec."Weekend Shipping Agent Code");
                    ShippingAgent.SetRange(Status, ShippingAgent.Status::Released);
                    if Not ShippingAgent.FindFirst() then
                        Error('Status must be equal to Released in Shipping Agent');

                    if Rec."Weekend Shipping Agent Code" <> xRec."Weekend Shipping Agent Code" then
                        Rec."Weekend Ship. Agnt. Serv. Code" := '';
                end;
            end;
        }
        field(85160; "Unit Price Approval"; Boolean)
        {

        }
        field(85161; "Total Order Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line".Quantity where(Type = filter(Item), "Document No." = field("No."), "Document Type" = field("Document Type")));
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(85162; "Drop/Special Order"; Boolean)
        {
            Caption = 'Drop Shipment Order';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "Drop Shipment" = const(true)));
        }
        field(85163; "Special Order"; Boolean)
        {
            Caption = 'Special Order';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "Special Order" = const(true)));
        }
        field(85165; "SO Min Order Approval Required"; Boolean)
        {
            // FieldClass = FlowField;
            // CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "SO Min Order Approval Required" = const(true), Amount = filter(> 0)));
        }
        field(85168; RXFarma; Boolean)
        {

        }
        field(85169; "Zero Price Approval"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "Unit Price" = filter(0), Type = filter(Item | "Charge (Item)"), Quantity = filter(> 0)));
        }
        field(85170; "Credit Limit Approval"; Boolean)
        {

        }
        field(85171; "Drop Number"; Text[5])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Drop Number" where("No." = field("Sell-to Customer No.")));
        }
        field(85172; "Weekend Drop Number"; Text[5])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Weekend Drop Number" where("No." = field("Sell-to Customer No.")));
        }
        field(85174; "Check & Split Order"; Boolean)
        {

        }
        field(85175; "Reference Sales Order"; Code[20])
        {

        }
        field(85176; "Hospital"; Boolean)
        {
            Caption = 'Exempt from Credit check';
        }
        field(85006; "Credit limit Exceeded"; Boolean)
        {

        }
        field(85007; "Overdue Balance"; Boolean)
        {

        }
        field(85008; "Exempt from Overdue check"; Boolean)
        {

        }
        field(85009; "ePOD ID"; Integer)
        {

        }
        field(85010; "ePOD Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Allocated,Unallocated,Pending,Deleted,Cancelled,On_Run,On_Handheld,Completed,Unknown;
        }
        field(85011; "ePOD RunID"; Integer)
        {

        }
        field(85012; "ePOD Job Consolidated"; Boolean)
        {

        }
        field(85013; "Order Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",RX,Hospital,Web,Wholesale,Tender,"Special/DropShipment",Export;

            trigger OnValidate()
            var
                L_WarehouseActivityHeader: Record "Warehouse Activity Header";
            begin
                if Rec."IRP Order" = true then
                    Error('You cannot change Order Category of electronic Order')
                else begin
                    L_WarehouseActivityHeader.Reset();
                    L_WarehouseActivityHeader.SetRange(Type, L_WarehouseActivityHeader.Type::"Invt. Pick");
                    L_WarehouseActivityHeader.SetRange("Source No.", Rec."No.");
                    if L_WarehouseActivityHeader.FindFirst() then begin
                        Error('You cannot change Order Category if inventory pick is exist');
                    end;
                end;
            end;
        }
        field(85016; "Sales Return Order Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //Use for EDI+++
        }
        field(85017; "Approval Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Approval Entry" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }
        field(85018; "Order Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;


    procedure CalcPlannedShptDate(CurrFieldNo: Integer) PlannedShipmentDate: Date
    var
        CustomCalendarChange: array[2] of Record "Customized Calendar Change";
        IsHandled: Boolean;
        CalChange: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
    begin
        CustomCalendarChange[2].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
        case CurrFieldNo of
            FieldNo("Shipment Date"):
                begin
                    CustomCalendarChange[1].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');
                    exit(CalendarMgmt.CalcDateBOC(Format("Outbound Whse. Handling Time"), "Shipment Date", CustomCalendarChange, true));
                end;
        end;
    end;
}