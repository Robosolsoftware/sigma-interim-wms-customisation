tableextension 85076 "Workflow Multi Level" extends Workflow
{
    fields
    {
        field(60050; "Multi Level Workflow"; Boolean)
        {
            Caption = 'Multi Level Workflow';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Multi Level Workflow" then
                    CheckMultiLevelWorkflowSetup();
            end;
        }
    }

    var
        NoWorkflowUserGroupStepErr: Label 'Multi Level Workflow can only be enabled if the workflow has a response step whose Approver Type is set to Workflow User Group.';
        InvalidWorkflowUserGroupSetupErr: Label 'Multi Level Workflow can only be enabled if the Workflow User Group %1 has at least two Sequence No. levels, with at least one user assigned to each Sequence No. level (e.g. User 1 on Sequence No. 1, User 2 and User 3 on Sequence No. 2).', Comment = '%1 = Workflow User Group Code';

    local procedure CheckMultiLevelWorkflowSetup()
    var
        WorkflowStep: Record "Workflow Step";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowUserGroupStepFound: Boolean;
    begin
        WorkflowStep.SetRange("Workflow Code", Code);
        WorkflowStep.SetRange(Type, WorkflowStep.Type::Response);
        if WorkflowStep.FindSet() then
            repeat
                if not IsNullGuid(WorkflowStep.Argument) and WorkflowStepArgument.Get(WorkflowStep.Argument) then
                    if WorkflowStepArgument."Approver Type" = WorkflowStepArgument."Approver Type"::"Workflow User Group" then begin
                        WorkflowUserGroupStepFound := true;
                        CheckWorkflowUserGroupSequenceSetup(WorkflowStepArgument."Workflow User Group Code");
                    end;
            until WorkflowStep.Next() = 0;

        if not WorkflowUserGroupStepFound then
            Error(NoWorkflowUserGroupStepErr);
    end;

    local procedure CheckWorkflowUserGroupSequenceSetup(WorkflowUserGroupCode: Code[20])
    var
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        PrevSequenceNo: Integer;
        SequenceLevelCount: Integer;
    begin
        WorkflowUserGroupMember.SetCurrentKey("Workflow User Group Code", "Sequence No.", "User Name");
        WorkflowUserGroupMember.SetRange("Workflow User Group Code", WorkflowUserGroupCode);
        if not WorkflowUserGroupMember.FindSet() then
            Error(InvalidWorkflowUserGroupSetupErr, WorkflowUserGroupCode);

        repeat
            if WorkflowUserGroupMember."Sequence No." <> PrevSequenceNo then begin
                SequenceLevelCount += 1;
                PrevSequenceNo := WorkflowUserGroupMember."Sequence No.";
            end;
        until WorkflowUserGroupMember.Next() = 0;

        if SequenceLevelCount < 2 then
            Error(InvalidWorkflowUserGroupSetupErr, WorkflowUserGroupCode);
    end;
}
