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
            field("Running Total Achieved"; Rec."Running Total Achieved")
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
        salesH.SetRange("Document Type", salesH."Document Type"::Order);
        salesH.SetFilter(Status, '%1|%2', salesH.Status::"Pending Approval", salesH.Status::Released);
        salesH.SetRange("Order Date", WorkDate());
        if salesH.FindSet() then begin
            repeat
                salesH.CalcFields(Amount);
                Rec."Running Total MOV" += salesH.Amount;

            until salesH.Next() = 0;
            Rec.CalcFields("Min Order Value");
            if rec."Running Total MOV" >= rec."Min Order Value" then
                Rec."Running Total Achieved" := true;
        end;

    end;
}
