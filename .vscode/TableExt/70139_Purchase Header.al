tableextension 70139 "SC Purchase Header" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                L_Vendor: Record Vendor;
            begin
                L_Vendor.Reset();
                L_Vendor.SetRange("No.", Rec."Buy-from Vendor No.");
                if L_Vendor.FindFirst() then begin
                    Rec."Min Order Value" := L_Vendor."Min Order Value";
                end;

            end;
        }
        field(70139; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
    }

    var
        myInt: Integer;
}