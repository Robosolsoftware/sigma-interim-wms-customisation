pageextension 85056 "SC Posted SalesInvoice Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Line Discount %")
        {
            field("Unable to Pick"; Rec."Unable to Pick")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("MLD %"; Rec."MLD %")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Line Discount %")
        {
            field("Original Line Discount"; Rec."Original Line Discount")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Original Line Discount %';
            }
        }
        addafter("Unit Price")
        {
            field(RRP; Rec.RRP)
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
}

pageextension 85126 "Ext Posted Sales Inv Card" extends "Posted Sales Invoice"
{
    layout
    {
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
    }
}