page 85004 "Shipping Agent Restrict Item"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Shipping Agent Restrict Item";
    DelayedInsert = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;

                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                }
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Caption = 'Attribute';
                    TableRelation = "Item Attribute".Name WHERE(Blocked = CONST(false));
                    ToolTip = 'Specifies the item attribute.';
                }
                field("Attribute Value"; Rec."Attribute Value")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    TableRelation = "Item Attribute Value".Value WHERE("Attribute ID" = FIELD("Attribute ID"), Blocked = CONST(false));
                    ToolTip = 'Specifies the value of the item attribute.';
                }
                field("QAU Approved"; Rec."QAU Approved")
                {
                    ApplicationArea = All;
                    Editable = L_EditableQUAApproved;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    var
        L_EditableQUAApproved: Boolean;


    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";
    begin
        Clear(L_EditableQUAApproved);
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data QAU Approved" = true then
                L_EditableQUAApproved := true
            else
                L_EditableQUAApproved := false;
        end else
            L_EditableQUAApproved := false;

    end;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";
    begin
        Clear(L_EditableQUAApproved);
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data QAU Approved" = true then
                L_EditableQUAApproved := true
            else
                L_EditableQUAApproved := false;
        end else
            L_EditableQUAApproved := false;

    end;

}