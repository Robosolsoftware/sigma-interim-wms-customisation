pageextension 85049 UserSetupEst1 extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {
            field("Edit Vendor Bank Accounts"; Rec."Edit Vendor Bank Accounts")
            {
                ApplicationArea = All;
            }
            field("Edit Customer Bank Accounts"; Rec."Edit Customer Bank Accounts")
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
                //ToolTip = 'Master Data consists of Customers, Items, Vendors, Shipment Agent, Shipping Agent Service Code';
                ToolTip = 'Edit Master Data QAU Approved/Warehouse Class Code/Item Attribute';
            }
            field("Edit Unit/RRP Price on Item"; Rec."Edit Unit/RRP Price on Item")
            {
                ApplicationArea = All;
            }
            field("SO Override Min Order Value"; Rec."SO Override Min Order Value")
            {
                ApplicationArea = All;
            }
            field("Sales Blocked"; Rec."Sales Blocked")
            {
                ApplicationArea = All;
            }
            field("Purchase Blocked"; Rec."Purchase Blocked")
            {
                ApplicationArea = All;
            }
            field("Ops Sales and Purchase Blocked"; Rec."Ops Sales and Purchase Blocked")
            {
                ApplicationArea = All;
            }
            field("Export Customer Release"; Rec."Export Customer Release")
            {
                ApplicationArea = All;
            }
            field("Credit Limit Release"; Rec."Credit Limit Release")
            {
                ApplicationArea = All;
            }
            field("SO/MOV/Quota/ZeroPrice Release"; Rec."SO/MOV/Quota/ZeroPrice Release")
            {
                ApplicationArea = All;
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