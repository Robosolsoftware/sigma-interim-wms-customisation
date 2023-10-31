tableextension 70123 POWHSESHpHeaderExt extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(70000; "Time of Shipment"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Time of Receipt"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Vehicle Reg No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70003; "Pallet ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70004; "Shipped By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70005; "Receipted By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70006; "Requested By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70007; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70008; "Seal No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(70131; "Delivery Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70132; "Collection Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70133; "_Invoice"; Boolean)
        {
            Caption = 'Invoice';
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
        field(70136; "Data logger"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70137; "Labels"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70138; "Custom Documents"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}