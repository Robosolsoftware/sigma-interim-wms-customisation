tableextension 85046 TransferHeaderExt extends "Transfer Header"
{
    fields
    {
        field(85000; "Time of Shipment"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(85001; "Time of Receipt"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Vehicle Reg No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "Pallet ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Shipped By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "Receipted By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85006; "Requested By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85007; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85008; "Seal No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85009; "Sheet Name"; Text[100])
        {

        }
        field(85010; "Import Date"; Date)
        {

        }
        // field(85011; "Transfer-To Zone Code"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = Zone.Code where("Location Code" = field("Transfer-to Code"));
        // }
    }

    var
        myInt: Integer;
}