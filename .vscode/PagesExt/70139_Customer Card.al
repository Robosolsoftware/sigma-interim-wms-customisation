pageextension 70139 "SC Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("No.")
        {
            field("Concerto Customer No."; Rec."Concerto Customer No.")
            {
                ApplicationArea = all;
                Editable = L_CurrPageEditable;
            }
        }
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





        modify("Customer Price Group")
        {
            Caption = 'Customer Price Group 1';
        }
        addafter("Customer Price Group")
        {
            field("Customer Price Group 2"; Rec."Customer Price Group 2")
            {
                ApplicationArea = All;
            }
            field("Customer Price Group 3"; Rec."Customer Price Group 3")
            {
                ApplicationArea = All;
            }
            field("Customer Price Group 4"; Rec."Customer Price Group 4")
            {
                ApplicationArea = All;
            }
            field("Customer Price Group 5"; Rec."Customer Price Group 5")
            {
                ApplicationArea = All;
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
            field(Funded; Rec.Funded)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
        }
        addafter(Statistics)
        {
            group("KNAPP Details")
            {
                Editable = L_CurrPageEditable;
                field("KNAPP Customer"; Rec."KNAPP Customer")
                {
                    ApplicationArea = All;

                }
                field("KNAPP Special Check"; Rec."KNAPP Special Check")
                {
                    ApplicationArea = All;

                }
                field("KNAPP Final Check"; Rec."KNAPP Final Check")
                {
                    ApplicationArea = All;

                }
                field("KNAPP Inventory Station"; Rec."KNAPP Inventory Station")
                {
                    ApplicationArea = All;

                }
                field("KNAPP Repack"; Rec."KNAPP Repack")
                {
                    ApplicationArea = All;

                }
                field("KNAPP Lid"; Rec."KNAPP Lid")
                {
                    ApplicationArea = All;

                }
            }
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
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        L_CurrPageEditable: Boolean;
        L_EditableQUAApproved: Boolean;

    trigger OnAfterGetRecord()
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