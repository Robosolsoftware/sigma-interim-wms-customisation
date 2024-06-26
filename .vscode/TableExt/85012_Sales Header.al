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
            begin
                if Rec."Sell-to Customer No." <> '' then begin
                    L_Customer.Reset();
                    L_Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if L_Customer.FindFirst() then begin
                        L_Customer.TestField("QAU Approved");
                        L_Customer.TestField(Status, L_Customer.Status::Released);


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
                        Rec."Weekend Shipping Agent Code" := L_Customer."Weekend Shipping Agent Code";
                        Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                        Rec."SO Approval Required" := L_Customer."SO Approval Required";
                    end;


                    // "Special Price Daily" should be only one++
                    L_SalesPriceHeader.Reset();
                    L_SalesPriceHeader.SetRange("Special Price Daily", true);
                    if L_SalesPriceHeader.FindFirst() then
                        Rec."Sales Price List Code" := L_SalesPriceHeader.Code;
                end;


                //Update Shipment Date++if 
                L_Date.Reset();
                L_Date.SetRange(L_Date."Period Type", L_Date."Period Type"::Date);
                L_Date.SetRange(L_Date."Period Start", WorkDate());
                if L_Date.FindFirst() then
                    if UpperCase(L_Date."Period Name") = UpperCase('FRIDAY') then begin
                        if Rec."Weekend Ship. Agnt. Serv. Code" <> '' then
                            //Update Saturday++
                            Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()))
                        else begin
                            //Update Monday
                            Rec.Validate("Shipment Date", CalcDate('<+3D>', WorkDate()));
                        end;
                    end else begin
                        //As discussed shipment date shoud be next day all condistion++
                        Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()));
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
            begin
                if Rec."Sell-to Customer Name" <> '' then begin
                    L_Customer.Reset();
                    L_Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if L_Customer.FindFirst() then begin
                        L_Customer.TestField("QAU Approved");
                        L_Customer.TestField(Status, L_Customer.Status::Released);

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
                        Rec."Weekend Ship. Agnt. Serv. Code" := L_Customer."Weekend Ship. Agnt. Serv. Code";
                        Rec."SO Approval Required" := L_Customer."SO Approval Required";
                    end;


                    // "Special Price Daily" should be only one++
                    L_SalesPriceHeader.Reset();
                    L_SalesPriceHeader.SetRange("Special Price Daily", true);
                    if L_SalesPriceHeader.FindFirst() then
                        Rec."Sales Price List Code" := L_SalesPriceHeader.Code;

                    //Update Shipment Date++if 
                    L_Date.Reset();
                    L_Date.SetRange(L_Date."Period Type", L_Date."Period Type"::Date);
                    L_Date.SetRange(L_Date."Period Start", WorkDate());
                    if L_Date.FindFirst() then
                        if UpperCase(L_Date."Period Name") = UpperCase('FRIDAY') then begin
                            if Rec."Weekend Ship. Agnt. Serv. Code" <> '' then
                                //Update Saturday++
                                Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()))
                            else begin
                                //Update Monday
                                Rec.Validate("Shipment Date", CalcDate('<+3D>', WorkDate()));
                            end;
                        end else begin
                            //As discussed shipment date shoud be next day all condistion++
                            Rec.Validate("Shipment Date", CalcDate('<+1D>', WorkDate()));
                        end;
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

    }

    var
        myInt: Integer;
}