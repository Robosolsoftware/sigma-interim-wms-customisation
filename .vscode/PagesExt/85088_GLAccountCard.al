pageextension 85088 "G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Cost Centre Account"; Rec."Cost Centre Account")
            {
                ApplicationArea = all;

            }
        }
    }
}
