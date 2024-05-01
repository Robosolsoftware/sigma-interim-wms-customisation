tableextension 70163 "SC Posted Invt. Pick Header" extends "Posted Invt. Pick Header"
{
    fields
    {
        // Add changes to table fields here
        field(70162; "Work Description"; Text[2042])
        {
            Caption = 'Work Description';
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