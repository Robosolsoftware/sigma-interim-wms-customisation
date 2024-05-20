pageextension 85052 ShippingAgentServices extends "Shipping Agent Services"
{
    layout
    {
        modify(Code)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Description)
        {
            Editable = L_CurrPageEditable;

        }
        modify("Shipping Time")
        {
            Editable = L_CurrPageEditable;

        }
        modify("Base Calendar Code")
        {
            Editable = L_CurrPageEditable;

        }
        modify(CustomizedCalendar)
        {
            Editable = L_CurrPageEditable;

        }
        addlast(Control1)
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
                    L_UserSetup.SetRange("Edit Master Data", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit');

                    CurrPage.Update();
                end;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst(Creation)
        {
            action("Restrict Item")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                RunObject = page "Shipping Agent Restrict Item";
                RunPageLink = "Shipping Agent Code" = field("Shipping Agent Code"), "Shipping Agent Service Code" = field(Code);
            }
        }
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
                if L_UserSetup."Edit Master Data" = true then begin
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
                if L_UserSetup."Edit Master Data" = true then
                    L_EditableStatus := true
                else
                    L_EditableStatus := false;
            end else
                L_EditableStatus := false;
        end;
    end;

    trigger OnOpenPage()
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
                if L_UserSetup."Edit Master Data" = true then begin
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
                if L_UserSetup."Edit Master Data" = true then
                    L_EditableStatus := true
                else
                    L_EditableStatus := false;
            end else
                L_EditableStatus := false;
        end;
    end;
}