pageextension 85015 PostDocSInvSubform extends "Get Post.Doc - S.InvLn Subform"
{
    layout
    {
        addafter(QtyReturned)
        {
            field("Qty on Return"; Rec."Qty on Return")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}