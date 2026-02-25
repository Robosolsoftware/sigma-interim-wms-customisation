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
        field(85001; "Daily Priority Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("Item No."), Code = field("Variant Code"), Priority = filter(> 0)));
        }
        field(85002; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
        }
        field(85003; "Priority From Variant"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Variant".Priority where("Item No." = field("Item No."), Code = field("Variant Code")));
            Editable = false;
        }
        field(85004; "Qty For Pick Sorting"; Decimal)
        {
            //Sum of Qty. on Pick Sorting Bin for same Item No. and Variant Code in the same Location
        }
    }
}