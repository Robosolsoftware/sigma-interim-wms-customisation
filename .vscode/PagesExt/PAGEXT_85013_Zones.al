pageextension 85013 "Zones List Ext" extends Zones
{
    layout
    {
        addlast(Control1)
        {
            field("Replenishment Priority"; Rec."Replenishment Priority")
            {
                ApplicationArea = All;
            }
        }
    }
}