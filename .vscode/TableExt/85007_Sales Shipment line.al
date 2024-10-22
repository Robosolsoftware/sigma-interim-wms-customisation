tableextension 85007 "SC Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        // Add changes to table fields here
        field(85003; "Min Sell Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(85004; "Original Quantity"; Decimal)
        {
            //GHST Customization++
            //DOnt Use this for another process++
        }
        field(85005; "Variant Assigned"; Boolean)
        {
            //GHST Customization++
            FieldClass = FlowField;
            CalcFormula = exist("Sales Shipment Line" where("Variant Code" = filter(<> '')));
        }
        field(85006; "Variant Code mandatory"; Boolean)
        {
            //GHST Customization++
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("No.")));
        }
        field(85007; "Variant Created By"; Integer)
        {
            //GHST Customization++
        }
        field(85008; "Last Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(85009; "Outer Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85010; "Parent Category"; Code[20])
        {
        }
        field(85011; "Shipper Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85012; "Pallet Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85013; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
        }
        field(85016; "Warehouse Class Code"; Code[10])
        {

        }

        field(85017; "Whs. Calss Code type"; Code[20])
        {
        }

        field(85018; "Order Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Order Date" where("No." = field("Document No.")));
            Editable = false;
        }
        field(85019; "Sales Return Order Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85020; "Sales Return Order Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(85021; "Return Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85022; "Return Order Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(85023; "Rejection"; Boolean)
        {

        }
        field(85024; RRP; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(85025; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(85026; Strength; Code[35])
        {
            DataClassification = ToBeClassified;
            Description = 'Product Strength';
            Editable = false;
        }
        field(85027; "Special Product"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85028; Rebate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85029; "Strength UoM"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Relation with Pack Code in Table Strength Master';
            //TableRelation = "Strength Master".Code;
        }
        field(85030; "SO Min Order Approval Required"; Boolean)
        {

        }
        field(85031; "Unable to Pick"; Text[100])
        {

        }
        field(85033; "Back Order"; Boolean)
        {

        }
        field(85034; "Changed UnitPrice"; Boolean)
        {

        }
        field(85035; "MLD %"; Decimal)
        {

        }
        field(85036; "Original Line Discount"; Decimal)
        {
            Caption = 'Original Line Discount %';
        }
        field(85037; Reclassified; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85038; "TO Discount %"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(85039; "Discount Applied on BasePrice"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(85040; "Custom Unit Price"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(85041; "Item Is Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("No.")));
            //This field is used for skip Line at the time of creating In pick++
        }
        field(85042; "Item Is Sales Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Sales Blocked" where("No." = field("No.")));
            //This field is used for skip Line at the time of creating In pick++
        }
        field(85043; "Item Is OPS Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Ops Sales Blocked" where("No." = field("No.")));
            //This field is used for skip Line at the time of creating In pick++
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