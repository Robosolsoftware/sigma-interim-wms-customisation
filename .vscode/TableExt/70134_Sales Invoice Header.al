tableextension 70134 "SC Sales Invoice Header" extends "Sales Invoice Header"
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
        field(70136; "Data Logger Sheet"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70137; "Labels"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70138; "Extra Documents"; Text[100])
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
        field(70143; "Email Sent"; Boolean)
        {

        }
        field(70144; "Default Bank"; Code[20])
        {
            TableRelation = "Bank Account";
            Editable = false;
        }
        field(70150; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(70151; "Weekend Ship. Agnt. Serv. Code"; Code[10])
        {
            Caption = 'Weekend Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
            Editable = false;
        }
        field(70152; "SO Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70153; "IRP Order"; Boolean)
        {

        }
    }

    var
        myInt: Integer;
}