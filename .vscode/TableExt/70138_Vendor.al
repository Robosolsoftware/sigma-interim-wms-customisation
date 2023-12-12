tableextension 70138 "SC Vendor" extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(70138; "PO Approval required"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
        }
        field(70139; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(70140; "Concerto Vendor No."; Code[50])
        {

        }
        field(70141; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Released;
        }
        // field(70140; "PO Approval Value"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 0 : 5;
        // }
    }

    var
        myInt: Integer;
}