pageextension 70139 "SC Customer Card" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
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
            field("Send By"; Rec."Send By")
            {
                ApplicationArea = All;
            }
        }
        addafter(Statistics)
        {
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
}