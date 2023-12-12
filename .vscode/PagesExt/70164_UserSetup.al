pageextension 70164 UserSetupEst1 extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {
            field("Edit Vendor Bank Accounts"; Rec."Edit Vendor Bank Accounts")
            {
                ApplicationArea = All;
            }
            field("Min Sell Price"; Rec."Min Sell Price")
            {
                ApplicationArea = All;
            }
            field("Edit Master Data"; Rec."Edit Master Data")
            {
                ApplicationArea = All;
                ToolTip = 'Master Data consists of Customers, Items, Vendors, Shipment Agent, Shipping Agent Service Code';
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