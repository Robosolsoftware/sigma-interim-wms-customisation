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
                ToolTip = 'Master Data consists of Customers, Items, Vendors';
            }
            field("Edit Shipping Agent"; Rec."Edit Shipping Agent")
            {
                ApplicationArea = All;
                ToolTip = 'Edit Shipping Agent & Shipping Agent Service Code';
            }
            field("Edit Master Data QAU Approved"; Rec."Edit Master Data QAU Approved")
            {
                ApplicationArea = All;
                //ToolTip = 'Master Data consists of Customers, Items, Vendors, Shipment Agent, Shipping Agent Service Code';
                ToolTip = 'Edit Master Data QAU Approved/Warehouse Class Code/Item Attribute';
            }
            field("Variant Approval"; Rec."Variant Approval")
            {
                ApplicationArea = all;
                ToolTip = 'Edit Variant Approval in Item Variant';
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
            field("SO Release Specialist (Export)"; Rec."SO Release Specialist (Export)")
            {
                ApplicationArea = All;
            }
            field("SO Release spec. (NonExport)"; Rec."SO Release spec. (NonExport)")
            {
                ApplicationArea = All;
            }
            field("Procurement Team Permission"; Rec."Procurement Team Permission")
            {
                ApplicationArea = All;
                ToolTip = 'The selected user has the ability to edit the fields within the Procurement Team tab on the item card.';
            }
            field("BDT Team Permission"; Rec."BDT Team Permission")
            {
                ApplicationArea = All;
                ToolTip = 'The selected user has the ability to edit the fields within the BDT Team tab on the Customer Card.';
            }
            field("Finance Team Permission"; Rec."Finance Team Permission")
            {
                ApplicationArea = All;
                ToolTip = 'The selected user has the ability to edit the fields within the Finance Team tab on the Vendor & Customer Card.';
            }
            field("Transport Team Permission"; Rec."Transport Team Permission")
            {
                ApplicationArea = All;
                ToolTip = 'The selected user has the ability to edit the fields within the Transport Team tab on the Customer Card.';
            }
            field("Finance(AR)"; Rec."Finance(AR)")
            {
                ApplicationArea = All;
                ToolTip = 'The selected user has the ability to edit the fields within the Finance(AR) Team tab on the Vendor & Customer Card.';
            }
            field("Edit Credit/Overdue"; Rec."Edit Credit/Overdue")
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