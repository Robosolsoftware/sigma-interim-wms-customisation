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

        }

    }

    var
        myInt: Integer;
}