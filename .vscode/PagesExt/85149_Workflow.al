pageextension 85149 "Workflow Multi Level" extends Workflow
{
    layout
    {
        addlast(content)
        {
            group(MultiLevelWorkflowGroup)
            {
                Caption = 'Multi Level Workflow';

                field("Multi Level Workflow"; Rec."Multi Level Workflow")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this workflow uses multi-level approval, where each approval level in the selected Workflow User Group can have more than one approver.';
                }
            }
        }
    }
}
