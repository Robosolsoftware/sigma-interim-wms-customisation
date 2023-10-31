tableextension 70119 TransferReceiptHeaderExt extends "Transfer Receipt Header"
{
    fields
    {
        field(70000; "Time of Shipment"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70001; "Time of Receipt"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70002; "Vehicle Reg No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70003; "Pallet ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70004; "Shipped By"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70005; "Receipted By"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70006; "Requested By"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70007; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70008; "Seal No."; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }



    }

    var
        myInt: Integer;
}