tableextension 85005 ILE extends "Item Ledger Entry"
{
    fields
    {
        field(85000; "Your ref Temp"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Del Adress Temp"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
        }
        field(85004; "Daily Priority Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("Item No."), Code = field("Variant Code"), Priority = filter(> 0)));
        }
        field(85005; "Alternate Vendor Address"; Code[20])
        {

        }
        field(85006; "Child Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Item Category Code")));
        }
        field(85007; "Parent Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Child Category")));
        }
        field(85008; "Posting Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(85009; "Cost Amount Expected Date Wise"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Amount (Expected)" where("Item Ledger Entry No." = field("Entry No."), "Posting Date" = field("Posting Date Filter")));
            Caption = 'Cost Amount Expected Date Wise';
            Editable = false;
            FieldClass = FlowField;
        }
        field(85010; "Cost Amount Actual Date Wise"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry No." = field("Entry No."), "Posting Date" = field("Posting Date Filter")));
            Caption = 'Cost Amount Actual Date Wise';
            Editable = false;
            FieldClass = FlowField;
        }
        field(85011; "WebOrder No."; Code[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Line"."WebOrder No." where("Document No." = field("Document No."), "Line No." = field("Document Line No.")));
        }

    }


    var


}