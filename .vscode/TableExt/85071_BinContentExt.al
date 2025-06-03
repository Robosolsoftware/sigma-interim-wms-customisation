tableextension 85071 BinContExt extends "Bin Content"
{
    fields
    {
        field(85000; "Exclude from free Qty."; Boolean)
        {
            Caption = 'Exclude from free Qty. Calculation';
            FieldClass = FlowField; //Prathamesh++ SBB-291
            CalcFormula = lookup(Bin."Exclude from free Qty." where(Code = field("Bin Code"), "Location Code" = field("Location Code")));
            Editable = false;
        }
    }
}