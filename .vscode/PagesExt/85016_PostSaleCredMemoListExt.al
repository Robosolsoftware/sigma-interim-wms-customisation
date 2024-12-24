pageextension 85016 PostSaleCreditMemoListExt extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Due Date")
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = all;
            }
            field("Email Sent"; Rec."Email Sent")
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