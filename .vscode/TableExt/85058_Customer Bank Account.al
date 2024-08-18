tableextension 85058 "SC Customer Bank Account" extends "Customer Bank Account"
{
    fields
    {

        modify(Code)
        {
            trigger OnAfterValidate()
            begin
                if Rec.Code <> xRec.Code then
                    "DD Mandate Generated" := false;
            end;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                if Rec.Name <> xRec.Name then
                    "DD Mandate Generated" := false;
            end;
        }

        modify("Bank Account No.")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Bank Account No." <> xRec."Bank Account No." then
                    "DD Mandate Generated" := false;
            end;
        }
        modify("Bank Branch No.")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Bank Branch No." <> xRec."Bank Branch No." then
                    "DD Mandate Generated" := false;
            end;
        }

        // Add changes to table fields here
        field(85058; Active; Boolean)
        {
            trigger OnValidate()
            var
                L_CustBankAccount: Record "Customer Bank Account";
            begin
                if Rec.Active = true then begin
                    L_CustBankAccount.Reset();
                    L_CustBankAccount.SetRange("Customer No.", Rec."Customer No.");
                    L_CustBankAccount.SetFilter(Code, '<>%1', Rec.Code);
                    L_CustBankAccount.SetRange(Active, true);
                    if L_CustBankAccount.FindFirst() then
                        Error('You cannot activate more than one account.');

                end;
            end;
        }
        field(85059; "DD Mandate Generated"; Boolean)
        {

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