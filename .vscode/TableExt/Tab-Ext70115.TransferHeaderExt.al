tableextension 70115 TransferHeaderExt extends "Transfer Header"
{
    fields
    {
        field(70000; "Time of Shipment"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Time of Receipt"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Vehicle Reg No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70003; "Pallet ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70004; "Shipped By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70005; "Receipted By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70006; "Requested By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70007; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70008; "Seal No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}