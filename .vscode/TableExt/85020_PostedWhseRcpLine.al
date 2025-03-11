tableextension 85020 POWHSERcpLineRBE extends "Posted Whse. Receipt Line"
{
    fields
    {
        field(85000; "Pack Size"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85001; Brand; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
        }
        field(85003; "Return Invoice Line No."; Integer) //Rehan++
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Return Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "Item Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(85006; "Transportation No."; Code[20])
        {

        }
        field(85008; "Receipt Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transportation Receipt Status';
        }
    }

    var
        myInt: Integer;
}