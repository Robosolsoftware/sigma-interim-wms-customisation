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

            trigger OnValidate()
            begin
                if Rec.Status = Rec.Status::Released then begin
                    rec.TestField("No.");
                    rec.TestField("Phone No.");
                    rec.TestField(Address);
                    rec.TestField("Address 2");
                    rec.TestField("Post Code");
                    rec.TestField("Vendor Posting Group");
                    rec.TestField("Payment Terms Code");
                    rec.TestField("Pay-to Vendor No.");
                    rec.TestField("E-Mail");
                end;
            end;
        }
        field(85146; "QAU Approved"; Boolean)
        {

        }
        field(85147; "Vendor Group"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Week 1","Week 2","Week 3","Week 4","Weekly";
        }
        // field(85140; "PO Approval Value"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 0 : 5;
        // }
        field(85148; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Stock,"Non-Stock";
        }
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