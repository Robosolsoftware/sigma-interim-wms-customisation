pageextension 85138 PAGBinContentsExt extends "Bin Contents"
{
    layout
    {
        addafter("Cross-Dock Bin")
        {

            field("Exclude from free Qty."; Rec."Exclude from free Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exclude from free Qty. Calculation field.', Comment = '%';
                Editable = false;
            }
            field("Daily Priority Exist"; Rec."Daily Priority Exist")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}