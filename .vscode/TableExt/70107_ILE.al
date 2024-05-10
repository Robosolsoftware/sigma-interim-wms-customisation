tableextension 70107 ILE extends "Item Ledger Entry"
{
    fields
    {
        field(80199; "Your ref Temp"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(80299; "Del Adress Temp"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70142; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
        }
        field(70143; "Daily Priority Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("Item No."), Code = field("Variant Code"), Priority = filter(> 0)));
        }
    }
}