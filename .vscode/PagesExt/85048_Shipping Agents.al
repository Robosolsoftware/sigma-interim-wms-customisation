pageextension 85048 "SC Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Podfather Depot"; Rec."Podfather Depot")
            {
                ApplicationArea = All;
            }
            field("ePOD ID"; Rec."ePOD ID")
            {
                ApplicationArea = All;
            }
            field("Depot Synced"; Rec."Depot Synced")
            {
                ApplicationArea = All;
            }
            field("Cutoff Time"; Rec."Cutoff Time")
            {
                ApplicationArea = All;
            }
        }
        modify(Code)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Name)
        {
            Editable = L_CurrPageEditable;

        }
        modify("Internet Address")
        {
            Editable = L_CurrPageEditable;

        }
        modify("Account No.")
        {
            Editable = L_CurrPageEditable;

        }
        modify("Coupled to Dataverse")
        {
            Editable = L_CurrPageEditable;

        }
        addafter("Internet Address")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = L_EditableStatus;

                trigger OnValidate()
                var
                    L_UserSetup: Record "User Setup";
                begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Edit Shipping Agent", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit');

                    CurrPage.Update();
                end;
            }
            field("Service Type"; Rec."Service Type")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        L_CurrPageEditable: Boolean;
        L_EditableStatus: Boolean;

    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";

    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableStatus);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            L_EditableStatus := true;
        end else begin
            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Shipping Agent" = true then begin
                    if Rec.Status = Rec.Status::Open then
                        L_CurrPageEditable := true
                    else
                        L_CurrPageEditable := false;
                end else
                    L_CurrPageEditable := false;
            end else
                L_CurrPageEditable := false;

            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Shipping Agent" = true then
                    L_EditableStatus := true
                else
                    L_EditableStatus := false;
            end else
                L_EditableStatus := false;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        L_UserSetup: Record "User Setup";
    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableStatus);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            L_EditableStatus := true;
        end else begin
            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Shipping Agent" = true then begin
                    if Rec.Status = Rec.Status::Open then
                        L_CurrPageEditable := true
                    else
                        L_CurrPageEditable := false;
                end else
                    L_CurrPageEditable := false;
            end else
                L_CurrPageEditable := false;

            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Shipping Agent" = true then
                    L_EditableStatus := true
                else
                    L_EditableStatus := false;
            end else
                L_EditableStatus := false;
        end;
    end;

    // trigger OnOpenPage()
    // var
    //     L_UserSetup: Record "User Setup";
    // begin
    //     Clear(L_CurrPageEditable);
    //     Clear(L_EditableStatus);
    //     if Rec.Status = Rec.Status::Open then begin
    //         L_CurrPageEditable := true;
    //         L_EditableStatus := true;
    //     end else begin
    //         L_UserSetup.Reset();
    //         L_UserSetup.SetRange("User ID", UserId);
    //         if L_UserSetup.FindFirst() then begin
    //             if L_UserSetup."Edit Master Data" = true then begin
    //                 if Rec.Status = Rec.Status::Open then
    //                     L_CurrPageEditable := true
    //                 else
    //                     L_CurrPageEditable := false;
    //             end else
    //                 L_CurrPageEditable := false;
    //         end else
    //             L_CurrPageEditable := false;

    //         L_UserSetup.Reset();
    //         L_UserSetup.SetRange("User ID", UserId);
    //         if L_UserSetup.FindFirst() then begin
    //             if L_UserSetup."Edit Master Data" = true then
    //                 L_EditableStatus := true
    //             else
    //                 L_EditableStatus := false;
    //         end else
    //             L_EditableStatus := false;
    //     end;
    // end;
}