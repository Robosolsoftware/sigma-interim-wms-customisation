pageextension 85028 "SC Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Location Code")
        {
            field("Type of Account"; Rec."Type of Account")
            {
                ApplicationArea = All;
            }
        }
        #Region SBB-36+++
        addafter(Statistics)
        {
            group("Transport Team")
            {
                Editable = G_TransportTeam;
                field("Weekend Shipping Agent Code"; Rec."Weekend Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Weekend Ship. Agnt. Serv. Code"; Rec."Weekend Ship. Agnt. Serv. Code")
                {
                    ApplicationArea = All;
                }
                field("Drop Number"; Rec."Drop Number")
                {
                    ApplicationArea = All;
                }
                field("Weekend Drop Number"; Rec."Weekend Drop Number")
                {
                    ApplicationArea = All;
                }
            }
            group(Finance)
            {
                Editable = G_FinanceTeam;
                field("Send By"; Rec."Send By")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                group("Address And Contact")
                {
                    ShowCaption = true;
                    Caption = 'Address & Contact';
                }
            }
        }
        //Finance Team++
        moveafter(Type; "Credit Limit (LCY)")
        moveafter("Address And Contact"; "Address & Contact")
        moveafter("Address & Contact"; Invoicing)


        //Transport Team++
        movefirst("Transport Team"; "Shipping Agent Code")
        moveafter("Shipping Agent Code"; "Shipping Agent Service Code")
        #EndRegion SBB-36+++



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
            ShowMandatory = true;
        }
        modify("Search Name")
        {
            Editable = L_CurrPageEditable;
        }
        modify("IC Partner Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Balance (LCY)")
        {
            Editable = L_CurrPageEditable;
        }
        modify(BalanceAsVendor)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Balance Due (LCY)")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Privacy Blocked")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Salesperson Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Responsibility Center")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Service Zone Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Document Sending Profile")
        {
            Editable = L_CurrPageEditable;
        }
        modify(TotalSales2)
        {
            Editable = L_CurrPageEditable;
        }
        modify("CustSalesLCY - CustProfit - AdjmtCostLCY")
        {
            Editable = L_CurrPageEditable;
        }
        modify(AdjCustProfit)
        {
            Editable = L_CurrPageEditable;
        }
        modify(AdjProfitPct)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Last Date Modified")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Disable Search by Name")
        {
            Editable = L_CurrPageEditable;
        }
        modify(Priority)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Address)
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
        modify("Payment Terms Code")
        {
            ShowMandatory = true;
        }
        modify("Location Code")
        {
            ShowMandatory = true;
        }




        //Group++
        modify(Shipping)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Statistics)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Intrastat)
        {
            Editable = L_CurrPageEditable;
        }
        //Editable Condition++
        addlast(Payments)
        {
            field("Default Bank"; Rec."Default Bank")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("Last Statement Date"; Rec."Last Statement Date")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                //Editable = L_CurrPageEditable;
                Editable = L_EditableStatus;
                trigger OnValidate()
                var
                    L_UserSetup: Record "User Setup";
                    L_Dimension: Record "Default Dimension";
                begin
                    L_Dimension.Reset();
                    L_Dimension.SetRange("No.", Rec."No.");
                    L_Dimension.SetRange("Table ID", 18);
                    if NOT L_Dimension.FindFirst() then
                        Error('Dimesion must have a value. It should not be empty');


                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Edit Master Data", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit');

                    CurrPage.Update();
                end;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = L_EditableQUAApproved;
            }
            field("SO Approval Required"; Rec."SO Approval Required")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("Magazine Mailout"; Rec."Magazine Mailout")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field(Bluechip; Rec.Bluechip)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
                Caption = 'Bluechain';
            }
            field(Hospital; Rec.Hospital)
            {
                Caption = 'Exempt from Credit check / Overdue check';
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
                //Editable = L_CreditCheckEditable;
            }
            field("Credit limit Exceeded"; Rec."Credit limit Exceeded")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            field("Overdue Balance"; Rec."Overdue Balance")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }

        }
        addafter(Statistics)
        {
            group("Print on Despatch")
            {
                Editable = L_CurrPageEditable;
                field("Delivery Note"; Rec."Delivery Note")
                {
                    ApplicationArea = All;
                }
                field("Collection Note"; Rec."Collection Note")
                {
                    ApplicationArea = All;
                }
                field(Invoice; Rec.Invoice)
                {
                    ApplicationArea = All;
                }
                field("Packing list"; Rec."Packing list")
                {
                    ApplicationArea = All;
                }
                field("Export Checklist"; Rec."Export Checklist")
                {
                    ApplicationArea = All;
                }
                field("Data Logger Sheet"; Rec."Data Logger Sheet")
                {
                    ApplicationArea = All;
                }
                field(Labels; Rec.Labels)
                {
                    ApplicationArea = All;
                }
                field("Extra Documents"; Rec."Extra Documents")
                {
                    ApplicationArea = All;
                }
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
        L_CurrPageEditable: Boolean;
        L_EditableQUAApproved: Boolean;
        L_EditableStatus: Boolean;
        USEditable: Boolean;
        G_FinanceTeam: Boolean;
        G_TransportTeam: Boolean;
        test: Codeunit 8800;
        L_CreditCheckEditable: Boolean;


    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";
        usersetup: Record "User Setup";

    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        Clear(L_EditableStatus);
        Clear(G_FinanceTeam);
        Clear(G_TransportTeam);
        Clear(L_CreditCheckEditable);

        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Finance Team Permission" = true then
                G_FinanceTeam := true
            else
                G_FinanceTeam := false;
        end else
            G_FinanceTeam := false;

        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Transport Team Permission" = true then
                G_TransportTeam := true
            else
                G_TransportTeam := false;
        end else
            G_TransportTeam := false;


        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            L_CreditCheckEditable := true;
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
        usersetup.SetRange("Edit Customer Bank Accounts", true);
        if usersetup.FindFirst() then begin
            USEditable := true;
        end else
            USEditable := false;

        usersetup.Reset();
        usersetup.SetRange("User ID", UserId);
        usersetup.SetRange("Edit Credit/Overdue", true);
        if usersetup.FindFirst() then begin
            L_CreditCheckEditable := true;
        end else
            L_CreditCheckEditable := false;
    end;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";
    begin

        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        Clear(L_EditableStatus);
        Clear(G_FinanceTeam);
        Clear(G_TransportTeam);

        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Finance Team Permission" = true then
                G_FinanceTeam := true
            else
                G_FinanceTeam := false;
        end else
            G_FinanceTeam := false;

        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Transport Team Permission" = true then
                G_TransportTeam := true
            else
                G_TransportTeam := false;
        end else
            G_TransportTeam := false;



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
}