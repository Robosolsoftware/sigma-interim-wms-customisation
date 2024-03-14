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