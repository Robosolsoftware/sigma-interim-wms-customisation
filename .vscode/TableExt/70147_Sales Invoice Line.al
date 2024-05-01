tableextension 70147 "SC Sales Invoice Line" extends "Sales Invoice Line"
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
        field(70144; "Qty on Return"; Decimal) // Rehan++
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Receipt Line".Quantity where("Return Invoice No." = field("Document No."), "Return Invoice Line No." = field("Line No."), "Source Document" = filter("Sales Return Order")));
        }
        field(70149; "Warehouse Class Code"; Code[10])
        {

        }

        field(70150; "Whs. Calss Code type"; Code[20])
        {
            //OptionMembers = Blank,CD,Fridge;
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
        field(70157; RRP; Decimal)
        {
            DecimalPlaces = 0 : 5;
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