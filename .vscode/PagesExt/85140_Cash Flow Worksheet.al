pageextension 85140 "SC Cash Flow Worksheet" extends "Cash Flow Worksheet"
{
    layout
    {
        // Add changes to page layout here
        addafter("Source No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Cashflow Date (2)"; Rec."Cashflow Date (2)")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor Group"; Rec."Vendor Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        test: Report "Suggest Worksheet Lines";
}