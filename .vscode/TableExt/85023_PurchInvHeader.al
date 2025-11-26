tableextension 85023 "Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(70139; "Min Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(70140; "PO Approval required"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
        }
        // field(70141; "PO Approval Value"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 0 : 5;
        // }
        field(70141; "Sheet Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70142; "Import Date"; Date)
        {

        }
        field(85021; "Invoice Type"; Option)
        {
            OptionMembers = " ",Opex,Stock,Capex;
        }
    }
}
