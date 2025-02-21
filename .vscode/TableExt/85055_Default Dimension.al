tableextension 85055 "SC Default Dimension" extends "Default Dimension"
{
    fields
    {
        // Add changes to table fields here
        modify("Dimension Value Code")
        {
            trigger OnAfterValidate()
            var
                L_DimensionValue: Record "Dimension Value";
            begin
                if Rec."Dimension Value Code" <> '' then begin
                    L_DimensionValue.Reset();
                    L_DimensionValue.SetRange("Dimension Code", Rec."Dimension Code");
                    L_DimensionValue.SetRange(Code, Rec."Dimension Value Code");
                    if L_DimensionValue.FindFirst() then begin
                        Rec.Validate("SO Approval Required", L_DimensionValue."SO Approval Required");
                    end;
                end;
            end;
        }

        field(85055; "Dimension Value Name 2"; Text[100])
        {
            FieldClass = FlowField;
            Caption = 'Dimension Value Name';
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Dimension Value Code")));
        }
        field(85056; "SO Approval Required"; Boolean)
        {
            Editable = false;
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