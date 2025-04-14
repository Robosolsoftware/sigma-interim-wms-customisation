tableextension 85030 "SC Customer" extends Customer
{
    fields
    {
        // Add changes to table fields here

        modify(Blocked)
        {
            trigger OnAfterValidate()
            begin
                if Rec.Blocked = Rec.Blocked::" " then
                    Rec.TestField("Block Reason", '');
            end;
        }
        field(85131; "Delivery Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85132; "Collection Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85133; "Invoice"; Boolean)
        {
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
        field(85139; "Last Year Sales Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            //This field upate on the "Sales Hist. Sell-to FactBox" of sales order.
            //Dont Use ++
        }
        field(85140; "This Year Sales Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            //This field upate on the "Sales Hist. Sell-to FactBox" of sales order.
            //Dont Use ++
        }
        field(85141; "Send By"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Email,Print,"Email & Print";
        }
        field(85142; "Default Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(85143; "Customer Price Group 2"; Code[10])
        {
            Caption = 'Customer Price Group 2';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 2" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(2, Rec);
                end;
            end;
        }
        field(85144; "Customer Price Group 3"; Code[10])
        {
            Caption = 'Customer Price Group 3';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 3" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(3, Rec);
                end;
            end;
        }
        field(85145; "Concerto Customer No."; Code[50])
        {

        }
        modify("Customer Price Group")
        {
            Caption = 'Customer Price Group 1';

            trigger OnAfterValidate()
            begin
                if Rec."Customer Price Group" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(1, Rec);
                end;
            end;
        }
        field(85146; "QAU Approved"; Boolean)
        {

        }
        field(85147; "Customer Price Group 4"; Code[10])
        {
            Caption = 'Customer Price Group 4';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 4" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(4, Rec);
                end;
            end;
        }
        field(85148; "Customer Price Group 5"; Code[10])
        {
            Caption = 'Customer Price Group 5';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 5" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(5, Rec);
                end;
            end;
        }
        field(85149; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released;

            trigger OnValidate()
            var
                DefaultDimention: Record "Default Dimension";
                L_Dimension: Record Dimension;
            begin
                if Rec.Status = Rec.Status::Released then begin
                    rec.TestField("No.");
                    rec.TestField("Phone No.");
                    rec.TestField(Address);
                    // rec.TestField(Type);
                    rec.TestField("Post Code");
                    rec.TestField(Name);
                    rec.TestField("Territory Code");
                    rec.TestField("Payment Terms Code");
                    rec.TestField("Name 2");
                    rec.TestField("Shipping Agent Code");
                    rec.TestField("Shipping Agent Service Code");
                    rec.TestField("Location Code");


                    L_Dimension.Reset();
                    L_Dimension.SetRange("Mandatory For Customer", true);
                    if L_Dimension.FindSet() then begin
                        repeat
                            DefaultDimention.Reset();
                            DefaultDimention.SetRange("Table ID", 18);
                            DefaultDimention.SetRange("No.", Rec."No.");
                            DefaultDimention.SetRange("Dimension Code", L_Dimension.Code);
                            if not DefaultDimention.FindFirst() then begin
                                Error('Default Dimention %1 Is Missing.', L_Dimension.Code);
                            end;
                        until L_Dimension.Next() = 0;
                    end;
                end;
            end;
        }
        field(85156; Funded; Boolean)
        {

        }
        field(85157; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(85158; "Weekend Ship. Agnt. Serv. Code"; Code[10])
        {
            Caption = 'Weekend Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Weekend Shipping Agent Code"));

            trigger OnValidate()
            var
                ShippingAgentService: Record "Shipping Agent Services";
            begin
                if Rec."Weekend Ship. Agnt. Serv. Code" <> '' then begin
                    ShippingAgentService.Reset();
                    ShippingAgentService.SetRange(code, Rec."Weekend Ship. Agnt. Serv. Code");
                    ShippingAgentService.SetRange(Status, ShippingAgentService.Status::Released);
                    if Not ShippingAgentService.FindFirst() then
                        Error('Status must be equal to Released in Shipping Agent Service');
                end;

                ShippingAgentService.Reset();
                if ("Shipping Agent Code" <> '') and
                   ("Weekend Ship. Agnt. Serv. Code" <> '')
                then
                    if ShippingAgentService.Get("Shipping Agent Code", "Weekend Ship. Agnt. Serv. Code") then
                        "Shipping Time" := ShippingAgentService."Shipping Time"
                    else
                        Evaluate("Shipping Time", '<>');
            end;
        }
        field(85159; "Magazine Mailout"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85160; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Main,Site,"Main/Site";
        }
        field(85161; "SO Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85162; "Customer Price Group 6"; Code[10])
        {
            Caption = 'Customer Price Group 6';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 6" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(6, Rec);
                end;
            end;
        }
        field(85163; "Customer Price Group 7"; Code[10])
        {
            Caption = 'Customer Price Group 7';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 7" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(7, Rec);
                end;
            end;
        }
        field(85164; "Customer Price Group 8"; Code[10])
        {
            Caption = 'Customer Price Group 8';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 8" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(8, Rec);
                end;
            end;
        }
        field(85165; "Customer Price Group 9"; Code[10])
        {
            Caption = 'Customer Price Group 9';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 9" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(9, Rec);
                end;
            end;
        }
        field(85166; "Customer Price Group 10"; Code[10])
        {
            Caption = 'Customer Price Group 10';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 10" <> '' then begin
                    SalesEventFunction.CheckDulicatePriceGroup(10, Rec);
                end;
            end;
        }
        field(85167; "Weekend Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Weekend Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                if Rec."Weekend Shipping Agent Code" <> xRec."Weekend Shipping Agent Code" then
                    Validate("Weekend Ship. Agnt. Serv. Code", '');
            end;
        }
        field(85168; "Market Code"; Text[50])
        {

        }
        field(85169; "Shop Group"; Text[50])
        {

        }
        field(85170; Bluechip; Boolean)
        {
            Caption = 'Bluechain';
        }
        field(85171; "Block Reason"; Code[20])
        {
            TableRelation = "Cust. Block Reason Code".Code;

            trigger OnValidate()
            begin
                if Rec."Block Reason" <> '' then begin
                    if Rec.Blocked = Rec.Blocked::" " then
                        Error('Field Blocked must have a value. Current value is blank');
                end;
            end;
        }
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            begin
                //Not Required in Sigma Process++
                Rec.TestField("Ship-to Code", '');
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
        field(85000; "Drop Number"; Text[5])
        {
            DataClassification = ToBeClassified;
        }
        field(85001; "Assigned Credit Controller"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(85002; "Weekend Drop Number"; Text[5])
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "Last Statement Date"; Date)
        {

        }
        field(85004; "Hospital"; Boolean)
        {
            Caption = 'Exempt from Credit check';
        }
        field(85005; "Type of Account"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Stock,"Non-Stock";
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
    }

    fieldgroups
    {
        addlast(DropDown; "Name 2", "QAU Approved", Status)
        {

        }
        addlast(Brick; "Name 2", "QAU Approved", Status)
        {

        }
    }

    var
        SalesEventFunction: Codeunit "Sales Event & Function";
}