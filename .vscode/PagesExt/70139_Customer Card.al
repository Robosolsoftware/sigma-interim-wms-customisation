pageextension 70139 "SC Customer Card" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here

        modify("Customer Price Group")
        {
            Caption = 'Customer Price Group 1';
        }
        addafter("No.")
        {
            field("Concerto Customer No."; Rec."Concerto Customer No.")
            {
                ApplicationArea = All;
            }
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
            }
            field("Send By"; Rec."Send By")
            {
                ApplicationArea = All;
            }
        }
        addafter(Statistics)
        {
            group("KNAPP Details")
            {
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
                field("Data logger"; Rec."Data logger")
                {
                    ApplicationArea = All;

                }
                field(Labels; Rec.Labels)
                {
                    ApplicationArea = All;

                }
                field("Custom Documents"; Rec."Custom Documents")
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

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";
    begin
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        L_UserSetup.SetRange("Edit Master Data", true);
        if not L_UserSetup.FindFirst() then begin
            if Rec.Status <> Rec.Status::Open then
                CurrPage.Editable(false);
        end;
    end;

}