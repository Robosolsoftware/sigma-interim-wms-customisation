tableextension 85027 LocationExt extends Location
{
    fields
    {
        field(85000; Deliveryadd; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(85001; "Skip for Lot FB"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85002; Deliveryadd2; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "GLN Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85004; "Saleable Location"; Boolean)
        {
            trigger OnValidate()
            var
                L_Location: Record Location;
            begin
                if Rec."Saleable Location" = true then begin
                    L_Location.Reset();
                    L_Location.SetFilter(Code, '<>%1', Rec.Code);
                    L_Location.SetRange("Saleable Location", true);
                    if L_Location.FindFirst() then
                        Error('Saleable Location should not be more than one');
                end;
            end;
        }
        field(85005; "Sales Return Location"; Boolean)
        {
            trigger OnValidate()
            var
                L_Location: Record Location;
            begin
                L_Location.Reset();
                L_Location.SetFilter(Code, '<>%1', Rec.Code);
                L_Location.SetRange("Sales Return Location", true);
                if L_Location.FindFirst() then
                    Error('Sales Return Location Should not be more than one');
            end;
        }
        field(85006; "Knapp Location"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                L_Location: Record Location;
            begin
                if Rec."Knapp Location" = true then begin
                    L_Location.Reset();
                    L_Location.SetFilter(Code, '<>%1', Rec.Code);
                    L_Location.SetRange("Knapp Location", true);
                    if L_Location.FindFirst() then
                        Error('Knapp Location Should not be more than one');
                end;
            end;
        }
    }
}