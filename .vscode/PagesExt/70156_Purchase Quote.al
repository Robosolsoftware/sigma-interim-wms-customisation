pageextension 70156 "SC Purchase Quote" extends "Purchase Quote"
{
    layout
    {
        moveafter(Status; "Shortcut Dimension 1 Code")

        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
        // Add changes to page layout here
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
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Shortcut Dimension 1 Code");
            end;
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                //Rec.TestField("Quality & Regulatory Check");
                //Rec.TestField("Second Check");
                Rec.TestField("Shortcut Dimension 1 Code");
            end;
        }
        modify(MakeOrder)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
            end;
        }
    }

    var
        myInt: Integer;
        G_Functions: Codeunit "SC Events & Subscriber";
}