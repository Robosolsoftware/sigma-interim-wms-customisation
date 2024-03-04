tableextension 70131 "SC Customer" extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(70131; "Delivery Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70132; "Collection Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70133; "Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134; "Packing list"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70135; "Export Checklist"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70136; "Data Logger Sheet"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70137; "Labels"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70138; "Extra Documents"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70139; "Last Year Sales Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            //This field upate on the "Sales Hist. Sell-to FactBox" of sales order.
            //Dont Use ++
        }
        field(70140; "This Year Sales Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            //This field upate on the "Sales Hist. Sell-to FactBox" of sales order.
            //Dont Use ++
        }
        field(70141; "Send By"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Email,Print,"Email & Print";
        }
        field(70142; "Default Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(70143; "Customer Price Group 2"; Code[10])
        {
            Caption = 'Customer Price Group 2';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 2" <> '' then begin
                    if Rec."Customer Price Group" = Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 3" = Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 4" = Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 5" = Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }
        field(70144; "Customer Price Group 3"; Code[10])
        {
            Caption = 'Customer Price Group 3';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 3" <> '' then begin
                    if Rec."Customer Price Group" = Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 2" = Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 4" = Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 5" = Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }
        field(70145; "Concerto Customer No."; Code[50])
        {

        }
        modify("Customer Price Group")
        {
            Caption = 'Customer Price Group 1';

            trigger OnAfterValidate()
            begin
                if Rec."Customer Price Group" <> '' then begin
                    if Rec."Customer Price Group 2" = Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 3" = Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 4" = Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 5" = Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }
        field(70146; "QAU Approved"; Boolean)
        {

        }
        field(70147; "Customer Price Group 4"; Code[10])
        {
            Caption = 'Customer Price Group 4';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 4" <> '' then begin
                    if Rec."Customer Price Group" = Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 2" = Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 3" = Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 5" = Rec."Customer Price Group 4" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }
        field(70148; "Customer Price Group 5"; Code[10])
        {
            Caption = 'Customer Price Group 5';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 4" <> '' then begin
                    if Rec."Customer Price Group" = Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 2" = Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 3" = Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 4" = Rec."Customer Price Group 5" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }
        field(70149; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Released;
        }
        field(70156; Funded; Boolean)
        {

        }
        field(70157; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(70158; "Weekend Ship. Agnt. Serv. Code"; Code[10])
        {
            Caption = 'Weekend Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));

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
        field(70159; "Magazine Mailout"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70160; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Main,Site,"Main/Site";
        }
        field(70161; "SO Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
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
        myInt: Integer;
}