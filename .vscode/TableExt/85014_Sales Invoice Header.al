tableextension 85014 "SC Sales Invoice Header" extends "Sales Invoice Header"
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
        field(70143; "Email Sent"; Boolean)
        {

        }
        field(85144; "Default Bank"; Code[20])
        {
            TableRelation = "Bank Account";
            Editable = false;
        }
        field(85145; "QAU Approved"; Boolean)
        {

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
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."No of Boxes" where("Inv. Pick No." = field("Inv. Pick No.")));
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

        field(85167; "Inv. Pick No."; Code[20])
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
            Caption = 'Exempt from Credit check';
        }
        field(85177; "Shipping Agent Service Code 2"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
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
        // field(85009; "ePOD ID"; Integer)
        // {

        // }
        field(85010; "ePOD Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Allocated,Unallocated,Pending,Deleted,Cancelled,On_Run,On_Handheld,Completed,Unknown;
        }
        // field(85011; "ePOD RunID"; Integer)
        // {

        // }
        // field(85012; "ePOD Job Consolidated"; Boolean)
        // {

        // }
        field(85013; "Order Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",RX,Hospital,Web,Wholesale,Tender,"Special/DropShipment",Export;
            Editable = false;
        }
        field(85014; "Customer Synced"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist(Customer where("No." = field("Bill-to Customer No."), "ePOD ID" = filter(> 0)));
        }
        field(85015; "Route Synced"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Shipping Agent" where(Code = field("Shipping Agent Code"), "ePOD ID" = filter(> 0)));
        }
        field(85016; "Sales Return Order Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //Use for EDI+++
        }
        //85017 used
        field(85018; "Order Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(85019; "ePOD Sync"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("ePOD Job Line"."Synced to ePOD" where("BC Invoice Number" = field("No.")));
        }

    }


    var
        myInt: Integer;
        tes: Codeunit 80;
}