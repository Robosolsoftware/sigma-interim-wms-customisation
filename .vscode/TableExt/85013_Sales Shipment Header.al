tableextension 85013 "SC Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
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
            Editable = false;
        }
        field(85152; "SO Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85153; "IRP Order"; Boolean)
        {

        }
        field(85156; "Rejection"; Boolean)
        {

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
                end;
            end;
        }
        field(85166; "Inv. Pick No."; Code[20])
        {

        }
        field(85168; RXFarma; Boolean)
        {

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

        }
    }

    var
        myInt: Integer;
}