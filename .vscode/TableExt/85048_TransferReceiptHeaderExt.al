tableextension 85048 TransferReceiptHeaderExt extends "Transfer Receipt Header"
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
        // field(85011; "Transfer-To Zone Code"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        // }



    }

    var
        myInt: Integer;
}