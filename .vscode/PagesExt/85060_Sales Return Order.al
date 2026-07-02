pageextension 85060 "SC Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Sales Return Order Invoice No."; Rec."Sales Return Order Invoice No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Rejection; Rec.Rejection)
            {
                ApplicationArea = All;
            }
            field("Sigma Driver Collection"; Rec."Sigma Driver Collection")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    Rec.CalcFields("ePOD Sync");
                    if Rec."Sigma Driver Collection" = false then begin
                        if Rec."ePOD Sync" = true then
                            Error('This cannot be disabled as the SRO has already been synced to the POD Father.');
                    end;
                end;
            }
            field("Sigma Driver Collection Instr."; Rec."Sigma Driver Collection Instr.")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
        addafter("Shipping Agent Service Code")
        {
            field("Weekend Shipping Agent Code"; Rec."Weekend Shipping Agent Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Weekend Ship. Agnt. Serv. Code"; Rec."Weekend Ship. Agnt. Serv. Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        tes: Page "Posted Sales Document Lines";
}