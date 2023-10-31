tableextension 70131 "SC Customer" extends Customer
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
        field(70133; "Invoice"; Boolean)
        {
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
        field(70139; "Last Year Sales Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            //This field upate on the "Sales Hist. Sell-to FactBox" of sales order.
            //Dont Use ++
        }
        field(70140; "This Year Sales Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            //This field upate on the "Sales Hist. Sell-to FactBox" of sales order.
            //Dont Use ++
        }
        field(70141; "Send By"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Email,Print,"Email & Print";
        }
        field(70142; "Default Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(70143; "Customer Price Group 2"; Code[10])
        {
            Caption = 'Customer Price Group 2';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 2" <> '' then begin
                    if Rec."Customer Price Group" = Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 3" = Rec."Customer Price Group 2" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }
        field(70144; "Customer Price Group 3"; Code[10])
        {
            Caption = 'Customer Price Group 3';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                if Rec."Customer Price Group 3" <> '' then begin
                    if Rec."Customer Price Group" = Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 2" = Rec."Customer Price Group 3" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }
        modify("Customer Price Group")
        {
            Caption = 'Customer Price Group 1';

            trigger OnAfterValidate()
            begin
                if Rec."Customer Price Group" <> '' then begin
                    if Rec."Customer Price Group 2" = Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');

                    if Rec."Customer Price Group 3" = Rec."Customer Price Group" then
                        Error('Customer Price Group already exist');
                end;
            end;
        }

    }

    var
        myInt: Integer;
}