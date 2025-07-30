tableextension 85021 "SC Purchase Header" extends "Purchase Header"
{
    fields
    {
        modify("Vendor Invoice No.")
        {
            trigger OnAfterValidate()
            var
                L_PurchaseHeader: Record "Purchase Header";
                PurchInvHeader: Record "Purch. Inv. Header";
            begin
                if Rec."Vendor Invoice No." <> '' then begin
                    L_PurchaseHeader.Reset();
                    L_PurchaseHeader.SetRange("Vendor Invoice No.", Rec."Vendor Invoice No.");
                    L_PurchaseHeader.SetRange("Pay-to Vendor No.", Rec."Pay-to Vendor No.");
                    L_PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    L_PurchaseHeader.SetFilter("No.", '<>%1', Rec."No.");
                    if L_PurchaseHeader.FindFirst() then
                        Error('Vendor Invoice No. %1 is already exist', Rec."Vendor Invoice No.");

                    PurchInvHeader.Reset();
                    PurchInvHeader.SetRange("Pay-to Vendor No.", Rec."Pay-to Vendor No.");
                    PurchInvHeader.SetRange("Vendor Invoice No.", Rec."Vendor Invoice No.");
                    if PurchInvHeader.FindFirst() then
                        Error('Vendor Invoice No. %1 is already exist', Rec."Vendor Invoice No.");
                end;


            end;
        }

        field(85000; "Purchase Order No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                L_Vendor: Record Vendor;
            begin
                if "Buy-from Vendor No." <> '' then begin
                    L_Vendor.Reset();
                    L_Vendor.SetRange("No.", Rec."Buy-from Vendor No.");
                    if L_Vendor.FindFirst() then begin
                        //Check Master Restriction++
                        if L_Vendor.Type = L_Vendor.Type::Stock then begin
                            L_Vendor.TestField("QAU Approved");
                            L_Vendor.TestField(Status, L_Vendor.Status::Released);
                        end;



                        Rec."Min Order Value" := L_Vendor."Min Order Value";
                        Rec."PO Approval required" := L_Vendor."PO Approval required";
                        //Rec."PO Approval Value" := L_Vendor."PO Approval Value";
                    end;

                    Rec."Invoice Received Date" := WorkDate();
                end;

            end;
        }

        modify("Buy-from Vendor Name")
        {
            trigger OnAfterValidate()
            var
                L_Vendor: Record Vendor;
            begin
                L_Vendor.Reset();
                L_Vendor.SetRange("No.", Rec."Buy-from Vendor No.");
                if L_Vendor.FindFirst() then begin
                    L_Vendor.TestField("QAU Approved");
                    L_Vendor.TestField(Status, L_Vendor.Status::Released);



                    Rec."Min Order Value" := L_Vendor."Min Order Value";
                    Rec."PO Approval required" := L_Vendor."PO Approval required";
                    //Rec."PO Approval Value" := L_Vendor."PO Approval Value";
                end;
            end;
        }
        field(70139; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(70140; "PO Approval required"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
            Caption = 'Approval required';
        }
        // field(70141; "PO Approval Value"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 0 : 5;
        // }
        field(70141; "Sheet Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70142; "Import Date"; Date)
        {

        }
        field(70143; "Warehouse Receipt Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Receipt Line" where("Source Document" = filter("Purchase Order"), "Source No." = field("No.")));
        }
        field(70144; "Inventory Put-away Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Activity Header" where("Source Document" = filter("Purchase Order"), "Source No." = field("No.")));
        }
        field(85021; "Invoice Type"; Option)
        {
            //OptionMembers = " ",Opex,Stock,Capex;
            OptionMembers = " ",Opex,Stock;

        }
    }

    var
        myInt: Integer;
}