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
        }
        field(85006; "Edit Master Data QAU Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
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