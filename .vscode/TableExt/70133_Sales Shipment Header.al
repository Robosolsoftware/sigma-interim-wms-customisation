tableextension 70133 "SC Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        // Add changes to table fields here
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
        field(70139; "Sheet Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70140; "Import Date"; Date)
        {

        }
        field(70142; "Send By"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Email,Print,"Email & Print";
        }
        field(70144; "Default Bank"; Code[20])
        {
            TableRelation = "Bank Account";
            Editable = false;
        }
    }

    var
        myInt: Integer;
}