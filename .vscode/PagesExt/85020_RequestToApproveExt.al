pageextension 85020 "Ext Request to Approve" extends "Requests to Approve"
{
    layout
    {
        addbefore(ToApprove)
        {
            field("Approval Code"; Rec."Approval Code")
            {
                ApplicationArea = All;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
