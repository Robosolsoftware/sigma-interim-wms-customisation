tableextension 70146 "SC Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        // Add changes to table fields here
        field(70133; "Min Sell Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70138; "Last Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70141; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70142; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70149; "Warehouse Class Code"; Code[10])
        {

        }

        field(70150; "Whs. Calss Code type"; Code[20])
        {
            //OptionMembers = Blank,CD,Fridge;
        }
        field(70151; "Order Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Order Date" where("No." = field("Document No.")));
            Editable = false;
        }
        field(70152; "Sales Return Order Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70153; "Sales Return Order Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70154; "Return Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70155; "Return Order Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70156; "Rejection"; Boolean)
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