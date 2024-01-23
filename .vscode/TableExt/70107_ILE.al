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
        field(70141; "Custom Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(70142; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
        }
    }
}