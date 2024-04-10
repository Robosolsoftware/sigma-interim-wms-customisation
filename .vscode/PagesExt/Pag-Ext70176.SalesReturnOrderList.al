pageextension 70176 "Sales Return Order List" extends "Sales Return Order List"
{

    layout
    {
        modify("Completely Shipped")
        {
            Visible = true;
            Editable = false;
            Caption = 'Fully Receipt';
        }
        addbefore("Completely Shipped")
        {
            field(PartiallyShipped; PartiallyShipped)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Partially Receipt';
            }
            field(Rejection; Rec.Rejection)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        moveafter(Status; "Completely Shipped")

        addlast(Control1)
        {
            field("System CreatedBy"; GetUserName(rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Caption = 'Created By';
            }
            field("System CreatedAt"; rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                caption = 'Created At';

            }
        }
    }

    actions
    {
        addafter("P&osting")
        {
            group("Import/Export SR")
            {
                Caption = 'Import/Export Sales Return Order';
                action("Export Sales Order Return Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Sales Return Order Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Export Import Sales Return";
                    begin
                        OpningStock.SampleSOTemplate();

                    end;
                }
                action("Import Sales Return Order")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportSO: codeunit "Export Import Sales Return";
                    begin
                        ImportSO.Run();
                        Message('Completed..');
                    end;
                }

            }
        }
    }

    var
        PartiallyShipped: Boolean;

    procedure GetUserName(UserSecurityId: Code[50]): Text[100]
    var
        Users: Record User;
    begin
        Users.Reset();
        Users.SetRange("User Security ID", UserSecurityId);
        if Users.FindFirst() then
            exit(Users."Full Name");

    end;

    trigger OnAfterGetRecord()
    var
        L_SalesLine: Record "Sales Line";
    begin
        Clear(PartiallyShipped);
        L_SalesLine.Reset();
        L_SalesLine.SetRange("Document Type", Rec."Document Type");
        L_SalesLine.SetRange("Document No.", Rec."No.");
        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
        if L_SalesLine.FindSet() then begin
            L_SalesLine.CalcSums("Return Qty. Received", Quantity);
            if (L_SalesLine."Return Qty. Received" > 0) AND (L_SalesLine."Return Qty. Received" < L_SalesLine.Quantity) then begin
                PartiallyShipped := true;
            end;
        end;
    end;
}
