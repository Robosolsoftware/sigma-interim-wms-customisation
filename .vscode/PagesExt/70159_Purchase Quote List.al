pageextension 70159 "SC Purchase Quote List" extends "Purchase Quotes"
{
    layout
    {
        // Add changes to page layout here
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
}