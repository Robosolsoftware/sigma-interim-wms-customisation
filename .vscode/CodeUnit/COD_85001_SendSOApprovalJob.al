codeunit 85001 "Send SO Approval"
{
    trigger OnRun()
    var
        L_SalesHeader: Record "Sales Header";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        L_SalesHeader.Reset();
        L_SalesHeader.SetRange("Document Type", L_SalesHeader."Document Type"::Order);
        L_SalesHeader.SetRange("IRP Order", true);
        L_SalesHeader.SetRange(Status, L_SalesHeader.Status::Open);
        //L_SalesHeader.SetRange("No.", '0000120475');
        if L_SalesHeader.FindSet() then begin
            repeat
                //if ApprovalsMgmt.IsSalesHeaderPendingApproval(L_SalesHeader) = false then
                if ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled(L_SalesHeader) then begin
                    if L_SalesHeader.SalesLinesExist() then begin
                        ApprovalsMgmt.OnSendSalesDocForApproval(L_SalesHeader);
                        Commit();
                    end;
                end;
            until L_SalesHeader.Next() = 0;
        end;
    end;
}