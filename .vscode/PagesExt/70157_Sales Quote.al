pageextension 70157 "SC Sales Quote" extends "Sales Quote"
{
    layout
    {
        // Add changes to page layout here
        modify("Sell-to Customer No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                L_Customer: Record Customer;
                L_CUstomerLookup: page "Customer Lookup";
            begin
                Clear(L_CUstomerLookup);
                L_Customer.Reset();
                L_Customer.SetRange("QAU Approved", true);
                L_Customer.SetRange(Status, L_Customer.Status::Released);
                L_CUstomerLookup.LookupMode(true);
                L_CUstomerLookup.SetTableView(L_Customer);
                if L_CUstomerLookup.RunModal() = Action::LookupOK then begin
                    L_CUstomerLookup.GetRecord(L_Customer);
                    Rec.Validate("Sell-to Customer No.", L_Customer."No.");
                end;
            end;
        }
        addlast(General)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Created At';
            }
            field(SystemCreatedBy; G_Functions.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified At';
            }
            field(SystemModifiedBy; G_Functions.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified By';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        G_Functions: Codeunit "SC Events & Subscriber";
}