tableextension 85029 "SC Vendor" extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(85138; "PO Approval required"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
        }
        field(85139; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(85140; "Concerto Vendor No."; Code[50])
        {

        }
        field(85141; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released;
        }
        field(85146; "QAU Approved"; Boolean)
        {

        }

        // field(85140; "PO Approval Value"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 0 : 5;
        // }
    }

    fieldgroups
    {
        addlast(DropDown; "QAU Approved", Status)
        {

        }
        addlast(Brick; "QAU Approved", Status)
        {

        }
    }

    var
        myInt: Integer;
}