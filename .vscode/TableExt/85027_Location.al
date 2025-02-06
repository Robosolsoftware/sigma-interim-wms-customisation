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
            // trigger OnValidate()
            // var
            //     L_Location: Record Location;
            // begin
            //     if Rec."Saleable Location" = true then begin
            //         L_Location.Reset();
            //         L_Location.SetFilter(Code, '<>%1', Rec.Code);
            //         L_Location.SetRange("Saleable Location", true);
            //         if L_Location.FindFirst() then
            //             Error('Saleable Location should not be more than one');
            //     end;
            // end;
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
        field(85007; "Zone Mandatory"; Boolean)
        {
            AccessByPermission = TableData "Warehouse Source Filter" = R;
            Caption = 'Zone Mandatory';

            trigger OnValidate()
            var
                L_Bin: Record Bin;
            begin
                if Rec."Zone Mandatory" = true then begin
                    L_Bin.Reset();
                    L_Bin.SetRange("Location Code", Rec.Code);
                    L_Bin.SetRange("Zone Code", '');
                    if L_Bin.FindFirst() then begin
                        Error('You cannot make this mandatory because there is a bin (%1) without a zone code. Please delete it or add the zone code before making this mandatory', L_Bin.Code);
                    end;
                end;

                if Rec."Zone Mandatory" = false then begin
                    L_Bin.Reset();
                    L_Bin.SetRange("Location Code", Rec.Code);
                    L_Bin.SetFilter("Zone Code", '<>%1', '');
                    if L_Bin.FindFirst() then begin
                        Error('You cannot make this non-mandatory because there is a bin (%1) with a zone code. Please delete it or remove the zone code before making this non-mandatory', L_Bin.Code);
                    end;
                end;
            end;
        }
    }
}