tableextension 85069 "SC Dimension Value" extends "Dimension Value"
{
    fields
    {
        // Add changes to table fields here
        field(85056; "SO Approval Required"; Boolean)
        {

            trigger OnValidate()
            var
                L_DefaultDimension: Record "Default Dimension";
            begin
                L_DefaultDimension.Reset();
                L_DefaultDimension.SetRange("Table ID", 18);
                L_DefaultDimension.SetRange("Dimension Code", Rec."Dimension Code");
                L_DefaultDimension.SetRange("Dimension Value Code", Rec.Code);
                if L_DefaultDimension.FindSet() then begin
                    L_DefaultDimension.ModifyAll("SO Approval Required", Rec."SO Approval Required");
                end;
            end;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}