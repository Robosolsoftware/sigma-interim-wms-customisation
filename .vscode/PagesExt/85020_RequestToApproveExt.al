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
            field("Running Total MOV"; Rec."Running Total MOV")
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
    trigger OnAfterGetRecord()
    var
        salesH: Record "Sales Header";
    begin
        salesH.Reset();
        salesH.SetRange("Sell-to Customer No.", Rec."Customer No.");
        salesH.SetRange(Status, salesH.Status::"Pending Approval");
        salesH.SetRange("Order Date", WorkDate());
        if salesH.FindSet() then begin
            repeat
                salesH.CalcFields("Amount Including VAT");
                Rec."Running Total MOV" += salesH."Amount Including VAT";
            until salesH.Next() = 0;

        end;

    end;
}
