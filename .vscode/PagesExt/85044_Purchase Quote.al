pageextension 85044 "SC Purchase Quote" extends "Purchase Quote"
{
    layout
    {
        moveafter(Status; "Shortcut Dimension 1 Code")
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
        addlast(General)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                caption = 'Created At';
            }
            field(SystemCreatedBy; G_MiscellaneousCharges.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified At';
            }
            field(SystemModifiedBy; G_MiscellaneousCharges.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified By';
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
        G_MiscellaneousCharges: Codeunit "Miscellaneous Charges";
}