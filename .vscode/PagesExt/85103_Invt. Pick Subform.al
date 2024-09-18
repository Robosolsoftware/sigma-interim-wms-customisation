pageextension 85103 "SC Invt. Pick Subform" extends "Invt. Pick Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Unable to Pick"; Rec."Unable to Pick")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    L_SalesLine: Record "Sales Line";
                begin
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    L_SalesLine.SetRange("Document No.", Rec."Source No.");
                    L_SalesLine.SetRange("Line No.", Rec."Source Line No.");
                    if L_SalesLine.FindFirst() then begin
                        if L_SalesLine."Unable to Pick" <> '' then begin
                            Clear(L_SalesLine."Unable to Pick");
                            L_SalesLine.Modify();
                        end;
                    end;
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        te: page "Vendor Ledger Entries";
}