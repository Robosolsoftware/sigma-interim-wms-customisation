codeunit 85017 "Customized Workflow Handler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        SiblingEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if not IsMultiLevelWorkflowApplicable(ApprovalEntry) then
            exit;

        SiblingEntry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        SiblingEntry.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        SiblingEntry.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
        SiblingEntry.SetRange(Status, SiblingEntry.Status::Open);
        SiblingEntry.SetFilter("Entry No.", '<>%1', ApprovalEntry."Entry No.");
        if SiblingEntry.FindSet(true) then
            repeat
                ApprovalsMgmt.ApproveApprovalRequests(SiblingEntry);
            until SiblingEntry.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCheckUserAsApprovalAdministrator', '', false, false)]
    local procedure OnBeforeCheckUserAsApprovalAdministrator(ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    begin
        if IsMultiLevelWorkflowApplicable(ApprovalEntry) then
            IsHandled := true;
    end;

    local procedure IsMultiLevelWorkflowApplicable(ApprovalEntry: Record "Approval Entry"): Boolean
    var
        WorkflowStepInstance: Record "Workflow Step Instance";
        Workflow: Record Workflow;
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        RecRef: RecordRef;
    begin
        WorkflowStepInstance.SetRange(ID, ApprovalEntry."Workflow Step Instance ID");
        if not WorkflowStepInstance.FindFirst() then
            exit(false);

        if not Workflow.Get(WorkflowStepInstance."Workflow Code") then
            exit(false);

        if not Workflow."Multi Level Workflow" then
            exit(false);

        if not RecRef.Get(ApprovalEntry."Record ID to Approve") then
            exit(false);

        case RecRef.Number of
            Database::"Sales Header":
                begin
                    RecRef.SetTable(SalesHeader);
                    exit(SalesHeader."Document Type" = SalesHeader."Document Type"::Order);
                end;
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    exit(PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order);
                end;
            else
                exit(false);
        end;
    end;
}