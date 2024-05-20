tableextension 85015 WHSESHpHeaderExt extends "Warehouse Shipment Header"
{
    fields
    {
        field(85000; "Time of Shipment"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(85001; "Time of Receipt"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Vehicle Reg No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "Pallet ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Shipped By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "Receipted By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85006; "Requested By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85007; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85008; "Seal No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }

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
        field(85138; "Extra Documents"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85139; "Work Description"; Text[2048])
        {
            Caption = 'Work Description';
        }
    }

    var
        myInt: Integer;
}