tableextension 70132 "SC Sales Header" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                L_Customer: Record Customer;
                L_SalesPriceHeader: Record "Price List Header";
            begin
                if Rec."Sell-to Customer No." <> '' then begin
                    L_Customer.Reset();
                    L_Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if L_Customer.FindFirst() then begin
                        L_Customer.TestField("QAU Approved");


                        Rec.Validate("Delivery Note", L_Customer."Delivery Note");
                        Rec.Validate("Collection Note", L_Customer."Collection Note");
                        Rec.Validate(_Invoice, L_Customer.Invoice);
                        Rec.Validate("Packing list", L_Customer."Packing list");
                        Rec.Validate("Export Checklist", L_Customer."Export Checklist");
                        Rec.Validate("Data logger", L_Customer."Data logger");
                        Rec.Validate(Labels, L_Customer.Labels);
                        Rec.Validate("Custom Documents", L_Customer."Custom Documents");
                        Rec."Send By" := L_Customer."Send By";
                        Rec."QAU Approved" := L_Customer."QAU Approved";
                        Rec."Default Bank" := L_Customer."Default Bank";
                    end;


                    // "Special Price Daily" should be only one++
                    L_SalesPriceHeader.Reset();
                    L_SalesPriceHeader.SetRange("Special Price Daily", true);
                    if L_SalesPriceHeader.FindFirst() then
                        Rec."Sales Price List Code" := L_SalesPriceHeader.Code;
                end;

            end;
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var
                L_Customer: Record Customer;
                L_SalesPriceHeader: Record "Price List Header";
            begin
                if Rec."Sell-to Customer Name" <> '' then begin
                    L_Customer.Reset();
                    L_Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if L_Customer.FindFirst() then begin
                        L_Customer.TestField("QAU Approved");

                        Rec.Validate("Delivery Note", L_Customer."Delivery Note");
                        Rec.Validate("Collection Note", L_Customer."Collection Note");
                        Rec.Validate(_Invoice, L_Customer.Invoice);
                        Rec.Validate("Packing list", L_Customer."Packing list");
                        Rec.Validate("Export Checklist", L_Customer."Export Checklist");
                        Rec.Validate("Data logger", L_Customer."Data logger");
                        Rec.Validate(Labels, L_Customer.Labels);
                        Rec.Validate("Custom Documents", L_Customer."Custom Documents");
                        Rec."Send By" := L_Customer."Send By";
                        Rec."QAU Approved" := L_Customer."QAU Approved";
                        Rec."Default Bank" := L_Customer."Default Bank";
                    end;


                    // "Special Price Daily" should be only one++
                    L_SalesPriceHeader.Reset();
                    L_SalesPriceHeader.SetRange("Special Price Daily", true);
                    if L_SalesPriceHeader.FindFirst() then
                        Rec."Sales Price List Code" := L_SalesPriceHeader.Code;
                end;
            end;
        }

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
        field(70141; "Sales Price List Code"; Code[50])
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
        }
        field(70145; "QAU Approved"; Boolean)
        {

        }

    }

    var
        myInt: Integer;
}