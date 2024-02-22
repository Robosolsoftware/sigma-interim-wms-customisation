pageextension 70141 "SC Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        //Add changes to page layout here
        addlast("Invoice Details")
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
                Editable = false;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Created At';
            }
            field(SystemCreatedBy; G_Functions.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified At';
            }
            field(SystemModifiedBy; G_Functions.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified By';
            }
        }
        addafter("Foreign Trade")
        {
            group("Print on Despatch")
            {
                Editable = false;
                field("Delivery Note"; Rec."Delivery Note")
                {
                    ApplicationArea = All;

                }
                field("Collection Note"; Rec."Collection Note")
                {
                    ApplicationArea = All;

                }
                field(Invoice; Rec._Invoice)
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
        G_Functions: Codeunit "SC Events & Subscriber";
}
