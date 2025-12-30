pageextension 85062 "SC Sales Credit Memos" extends "Sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(SendApprovalRequest)
        {
            action("Send Multiple Approval Request")
            {
                ApplicationArea = all;
                Caption = 'Send Multiplel Approval Request';
                Image = SendApprovalRequest;
                ToolTip = 'Request approval of the document.';
                trigger OnAction()
                var
                    L_SalesHeader: Record "Sales Header";
                    RequestToApproval: Record "Sales Header";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    L_SalesHeader.Reset();
                    CurrPage.SetSelectionFilter(L_SalesHeader);
                    L_SalesHeader.SetRange(Status, L_SalesHeader.Status::Open);
                    if L_SalesHeader.FindSet() then begin
                        repeat
                            RequestToApproval.Reset();
                            RequestToApproval.SetRange("Document Type", L_SalesHeader."Document Type");
                            RequestToApproval.SetRange("No.", L_SalesHeader."No.");
                            if RequestToApproval.FindFirst() then begin
                                if ApprovalsMgmt.CheckSalesApprovalPossible(RequestToApproval) then
                                    ApprovalsMgmt.OnSendSalesDocForApproval(RequestToApproval);
                            end;
                        until L_SalesHeader.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}