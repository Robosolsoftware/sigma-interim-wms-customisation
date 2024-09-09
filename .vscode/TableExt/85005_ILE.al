tableextension 85005 ILE extends "Item Ledger Entry"
{
    fields
    {
        field(85000; "Your ref Temp"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Del Adress Temp"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
        }
        field(85004; "Daily Priority Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("Item No."), Code = field("Variant Code"), Priority = filter(> 0)));
        }
        field(85005; "Alternate Vendor Address"; Code[20])
        {

        }

    }


    var


}