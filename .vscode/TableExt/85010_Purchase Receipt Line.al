tableextension 85010 "SC Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        // Add changes to table fields here
        field(85103; "Pack"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(85102; "Size"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(85000; "Pack Size"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85001; Brand; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
        }
        field(85003; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85135; "Sell-to Customer No."; Code[20])
        {

        }
        field(85136; "Sell-to Customer Name"; Text[100])
        {

        }
        field(85137; "Net Unit Cost"; Decimal)
        {

        }
        field(85138; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(85139; "Child Category"; Code[20])
        {
            Editable = false;
        }
        field(85140; "Parent Category"; Code[20])
        {
            Editable = false;
        }
        // field(85141; "Order Date"; Date)
        // {
        //     Editable = false;
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Purch. Rcpt. Header"."Order Date" where("No." = field("Document No.")));
        // }
        field(85142; "Unable to Receive"; Text[100])
        {

        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}