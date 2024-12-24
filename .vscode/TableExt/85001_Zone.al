tableextension 85001 "Zone Ext." extends Zone
{
    fields
    {
        field(85000; "Replenishment Priority"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                L_Zones: Record Zone;
            begin
                if Rec."Replenishment Priority" > 0 then begin
                    L_Zones.Reset();
                    L_Zones.SetRange("Replenishment Priority", Rec."Replenishment Priority");
                    if L_Zones.FindFirst() then
                        Error(StrSubstNo('Zone %1 already has this priority assigned to it', L_Zones.Code));
                end;
            end;
        }
    }
}