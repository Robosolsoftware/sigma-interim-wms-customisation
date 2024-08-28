pageextension 85039 "SC Vendor Card" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        //Editable Condition++
        modify("No.")
        {
            Editable = L_CurrPageEditable;
            ShowMandatory = true;
        }
        modify(Name)
        {
            Editable = L_CurrPageEditable;
            ShowMandatory = true;
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

        //Mark Mandatory

        modify(Address)
        {
            ShowMandatory = true;
        }
        modify("Address 2")
        {
            ShowMandatory = true;
        }
        modify("Post Code")
        {
            ShowMandatory = true;
        }
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
        modify("Vendor Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Payment Terms Code")
        {
            ShowMandatory = true;
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
        modify("Pay-to Vendor No.")
        {
            Visible = true;
            ShowMandatory = true;
        }
        modify("E-Mail")
        {
            ShowMandatory = true;
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
            field("Vendor Group"; Rec."Vendor Group")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }

        }
        addafter("Purchaser Code")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                //Editable = L_CurrPageEditable;
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

                    if Rec.Status = Rec.Status::Released then begin
                        rec.TestField("No.");
                        rec.TestField("Phone No.");
                        rec.TestField(Address);
                        rec.TestField("Address 2");
                        rec.TestField("Post Code");
                        rec.TestField("Vendor Posting Group");
                        rec.TestField("Payment Terms Code");
                        rec.TestField("Pay-to Vendor No.");
                        rec.TestField("E-Mail");
                    end;

                end;
            }

        }
    }

    actions
    {
        modify("Bank Accounts")
        {
            Visible = USEditable;
        }
    }

    var
        myInt: Integer;
        G_EnableMinOrderValue: Boolean;
        L_CurrPageEditable: Boolean;
        L_EditableQUAApproved: Boolean;
        L_EditableStatus: Boolean;
        USEditable: Boolean;

    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";

    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        Clear(L_EditableStatus);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            //L_EditableQUAApproved := true;
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
        usersetup: Record "User Setup";
    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        Clear(L_EditableStatus);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            //L_EditableQUAApproved := true;
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

        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data QAU Approved" = true then
                L_EditableQUAApproved := true
            else
                L_EditableQUAApproved := false;
        end else
            L_EditableQUAApproved := false;

        usersetup.Reset();
        usersetup.SetRange("User ID", UserId);
        usersetup.SetRange("Edit Vendor Bank Accounts", true);
        if usersetup.FindFirst() then begin
            USEditable := true;
        end else
            USEditable := false;

    end;
}