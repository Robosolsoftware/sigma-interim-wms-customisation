codeunit 85001 "Send SO Approval"
{
    trigger OnRun()
    var
        L_SalesHeader: Record "Sales Header";
        L_SalesLine: Record "Sales Line";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        L_SalesHeader.Reset();
        L_SalesHeader.SetRange("Document Type", L_SalesHeader."Document Type"::Order);
        L_SalesHeader.SetRange("IRP Order", true);
        L_SalesHeader.SetRange(Status, L_SalesHeader.Status::Open);
        //L_SalesHeader.SetRange("No.", '0000120475');
        if L_SalesHeader.FindSet() then begin
            repeat
                L_SalesLine.Reset();
                L_SalesLine.CalcFields("Variant Code mandatory");
                L_SalesLine.SetRange("Document Type", L_SalesHeader."Document Type");
                L_SalesLine.SetRange("Document No.", L_SalesHeader."No.");
                L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                L_SalesLine.SetFilter("Variant Code", '%1', '');
                L_SalesLine.SetRange("Variant Code mandatory", true);
                L_SalesLine.SetFilter("Quantity Shipped", '%1', 0);
                L_SalesLine.SetFilter("Location Code", '<>%1', '');
                if not L_SalesLine.FindFirst() then begin
                    //if ApprovalsMgmt.IsSalesHeaderPendingApproval(L_SalesHeader) = false then
                    if ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled(L_SalesHeader) then begin
                        if L_SalesHeader.SalesLinesExist() then begin
                            ApprovalsMgmt.OnSendSalesDocForApproval(L_SalesHeader);
                            Commit();
                        end;
                    end;
                end;
            until L_SalesHeader.Next() = 0;
        end;
    end;
}