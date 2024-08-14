tableextension 85045 "SI Warehouse Activity Header" extends "Warehouse Activity Header"
{
    fields
    {
        // Add changes to table fields here
        field(85000; "Work Description"; Text[2042])
        {
            Caption = 'Work Description';
        }
        field(85001; "Allowed to Pick"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Activity Line" where("Unable to Pick" = const(''), "No." = field("No."), "Activity Type" = field(Type)));
            //This field used to filter on tasklet pick Screen++
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