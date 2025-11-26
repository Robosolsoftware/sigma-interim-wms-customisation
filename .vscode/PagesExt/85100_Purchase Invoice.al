pageextension 85100 "SC Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        modify(General)
        {
            Editable = IsEditablePurchInv;
        }
        modify("Invoice Details")
        {
            Editable = IsEditablePurchInv;
        }
        modify("Shipping and Payment")
        {
            Editable = IsEditablePurchInv;
        }
        modify("Foreign Trade")
        {
            Editable = IsEditablePurchInv;
        }


        addlast(General)
        {
            field("PO Approval required"; Rec."PO Approval required")
            {
                Caption = 'Approval Required';
                ApplicationArea = All;
            }
        }
        addafter("Vendor Order No.")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = All;
            }

        }

        addafter("Attached Documents")
        {
            part(AttachedDocuments; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Purchase Header"),
                              "No." = field("No."),
                              "Document Type" = field("Document Type");
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        IsEditablePurchInv: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Editability1();
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Editability1();
    end;

    procedure Editability1()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);

        if UserSetup."Allow Purch Inv Edit" = true then begin
            IsEditablePurchInv := true;
        end else begin
            IsEditablePurchInv := false;
        end;
    end;
}