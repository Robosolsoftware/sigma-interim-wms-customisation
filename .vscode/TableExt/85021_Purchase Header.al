tableextension 85021 "SC Purchase Header" extends "Purchase Header"
{
    fields
    {
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
                        L_Vendor.TestField("QAU Approved");
                        L_Vendor.TestField(Status, L_Vendor.Status::Released);



                        Rec."Min Order Value" := L_Vendor."Min Order Value";
                        Rec."PO Approval required" := L_Vendor."PO Approval required";
                        //Rec."PO Approval Value" := L_Vendor."PO Approval Value";
                    end;
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
    }

    var
        myInt: Integer;
}