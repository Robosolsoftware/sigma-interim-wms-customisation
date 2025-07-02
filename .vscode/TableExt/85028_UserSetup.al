tableextension 85028 "SC User Setup" extends "User Setup"
{
    fields
    {
        field(85003; "Edit Vendor Bank Accounts"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Edit Master Data"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "Allow to change unit price"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'SO Override MSP';
        }
        field(85006; "Edit Master Data QAU Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'QAU Approval';
        }
        field(85007; "Edit Unit/RRP Price on Item"; Boolean)
        {

        }
        field(85008; "SO Override Min Order Value"; Boolean)
        {

        }
        field(85009; "Sales Blocked"; Boolean)
        {

        }
        field(85010; "Purchase Blocked"; Boolean)
        {

        }
        field(85011; "Ops Sales and Purchase Blocked"; Boolean)
        {

        }
        field(85012; "Edit Customer Bank Accounts"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85013; "Export Customer Release"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Export Customer SO Release';
        }
        field(85014; "Credit Limit Release"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Credit Limit SO Release';
        }
        field(85015; "SO/MOV/Quota/ZeroPrice Release"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'SO/MOV/Quota/ZeroPrice SO Release';
        }
        field(85016; "Procurement Team Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85017; "BDT Team Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85018; "Finance Team Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85019; "Transport Team Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85020; "Finance(AR)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85022; "SO Release Specialist (Export)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85023; "SO Release spec. (NonExport)"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'SO Release Specialist (Non Export)';
        }
        field(85024; "Edit Credit/Overdue"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Edit Customer Credit Check/Overdue Check';
        }
        field(85025; "Edit Shipping Agent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Edit Shipping Agent Code/Service';
        }
        field(85026; "Variant Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85027; "Order Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",RX,Hospital,Web,Wholesale,Tender,"Special/DropShipment",Export;
        }
        field(85028; "Job Run"; Boolean)
        {
            ToolTip = 'Job run once foreground permission';
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}