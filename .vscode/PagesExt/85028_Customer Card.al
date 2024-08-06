pageextension 85028 "SC Customer Card" extends "Customer Card"
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
        modify("Credit Limit (LCY)")
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


        addafter("Shipping Agent Service Code")
        {
            field("Weekend Shipping Agent Code"; Rec."Weekend Shipping Agent Code")
            {
                ApplicationArea = All;
            }
            field("Weekend Ship. Agnt. Serv. Code"; Rec."Weekend Ship. Agnt. Serv. Code")
            {
                ApplicationArea = All;
            }
        }


        modify("Customer Price Group")
        {
            Caption = 'Customer Price Group 1';
            Editable = L_CustomerPriceEditable;
        }
        addafter("Customer Price Group")
        {
            field("Customer Price Group 2"; Rec."Customer Price Group 2")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 3"; Rec."Customer Price Group 3")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 4"; Rec."Customer Price Group 4")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 5"; Rec."Customer Price Group 5")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 6"; Rec."Customer Price Group 6")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 7"; Rec."Customer Price Group 7")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 8"; Rec."Customer Price Group 8")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 9"; Rec."Customer Price Group 9")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
            field("Customer Price Group 10"; Rec."Customer Price Group 10")
            {
                ApplicationArea = All;
                Editable = L_CustomerPriceEditable;
            }
        }
        addlast(Payments)
        {
            field("Default Bank"; Rec."Default Bank")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
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
                end;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = L_EditableQUAApproved;
            }
            field("Send By"; Rec."Send By")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("SO Approval Required"; Rec."SO Approval Required")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("Magazine Mailout"; Rec."Magazine Mailout")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;

                trigger OnValidate()
                begin
                    if Rec.Type = Rec.Type::Site then
                        L_CustomerPriceEditable := false
                    else
                        L_CustomerPriceEditable := true;
                    CurrPage.Update();
                end;
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("Market Code"; Rec."Market Code")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("Shop Group"; Rec."Shop Group")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field(Bluechip; Rec.Bluechip)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
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
        myInt: Integer;
        L_CurrPageEditable: Boolean;
        L_EditableQUAApproved: Boolean;
        L_EditableStatus: Boolean;
        L_CustomerPriceEditable: Boolean;
        USEditable: Boolean;


    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";
        usersetup: Record "User Setup";
    begin
        if Rec.Type = Rec.Type::Site then
            L_CustomerPriceEditable := false
        else
            L_CustomerPriceEditable := true;


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
        usersetup.SetRange("Edit Customer Bank Accounts", true);
        if usersetup.FindFirst() then begin
            USEditable := true;
        end else
            USEditable := false;

    end;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";

    begin
        if Rec.Type = Rec.Type::Site then
            L_CustomerPriceEditable := false
        else
            L_CustomerPriceEditable := true;


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

}