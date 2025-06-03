tableextension 85031 BinExt extends Bin
{
    fields
    {
        field(85000; "Exclude from Fact box"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85001; "Exclude from free Qty."; Boolean)
        {
            Caption = 'Exclude from free Qty. Calculation';
            DataClassification = ToBeClassified; //Prathamesh++ SBB-291
        }
        modify(Code)
        {
            trigger OnAfterValidate()
            var
                L_Location: Record Location;
            begin
                if Rec.Code <> '' then begin
                    if L_Location.Get(Rec."Location Code") then begin
                        if L_Location."Zone Mandatory" = true then begin
                            Rec.TestField("Zone Code");
                        end;
                    end;
                end;
            end;
        }
    }

    var
        myInt: Integer;
}