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
            field("Allow to change unit price"; Rec."Allow to change unit price")
            {
                ApplicationArea = All;
                ToolTip = 'Selected user can change unit price below Min Sell Price';
            }
            field("Edit Master Data"; Rec."Edit Master Data")
            {
                ApplicationArea = All;
                ToolTip = 'Master Data consists of Customers, Items, Vendors, Shipment Agent, Shipping Agent Service Code';
            }
            field("Edit Master Data QAU Approved"; Rec."Edit Master Data QAU Approved")
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