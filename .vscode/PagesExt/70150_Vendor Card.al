pageextension 70150 "SC Vendor Card" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        //Editable Condition++
        modify("No.")
        {
            Editable = L_CurrPageEditable;
        }
        modify(Name)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Name 2")
        {
            Editable = L_CurrPageEditable;
        }
        modify(Blocked)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Privacy Blocked")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Last Date Modified")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Balance (LCY)")
        {
            Editable = L_CurrPageEditable;
        }
        modify(BalanceAsCustomer)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Balance Due (LCY)")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Document Sending Profile")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Disable Search by Name")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Search Name")
        {
            Editable = L_CurrPageEditable;
        }
        modify("IC Partner Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Purchaser Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Responsibility Center")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Company Size Code")
        {
            Editable = L_CurrPageEditable;
        }



        //Group++
        modify("Address & Contact")
        {
            Editable = L_CurrPageEditable;
        }
        modify(Invoicing)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Payments)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Receiving)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Intrastat)
        {
            Editable = L_CurrPageEditable;
        }
        //Editable Condition++



        addafter("No.")
        {
            field("Concerto Vendor No."; Rec."Concerto Vendor No.")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
        }
        addlast(General)
        {
            field("PO Approval required"; Rec."PO Approval required")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;

                trigger OnValidate()
                begin
                    Clear(G_EnableMinOrderValue);
                    if Rec."PO Approval required" = Rec."PO Approval required"::Yes then
                        G_EnableMinOrderValue := true
                    else
                        G_EnableMinOrderValue := false;
                    CurrPage.Update();
                end;
            }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = L_EditableQUAApproved;
            }
            field(EDI; Rec.EDI)
            {
                ApplicationArea = all;
                Editable = L_CurrPageEditable;
            }
        }
        addafter("Purchaser Code")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;

                trigger OnValidate()
                var
                    L_UserSetup: Record "User Setup";
                begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Edit Master Data", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit')

                end;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        G_EnableMinOrderValue: Boolean;
        L_CurrPageEditable: Boolean;
        L_EditableQUAApproved: Boolean;

    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";
    begin
        Clear(G_EnableMinOrderValue);
        if Rec."PO Approval required" = Rec."PO Approval required"::Yes then
            G_EnableMinOrderValue := true
        else
            G_EnableMinOrderValue := false;


        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            L_EditableQUAApproved := true;
        end else begin
            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Master Data" = true then
                    L_CurrPageEditable := true
                else
                    L_CurrPageEditable := false;
            end else
                L_CurrPageEditable := false;


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
    end;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";

    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            L_EditableQUAApproved := true;
        end else begin
            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Master Data" = true then
                    L_CurrPageEditable := true
                else
                    L_CurrPageEditable := false;
            end else
                L_CurrPageEditable := false;


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
    end;
}