tableextension 70121 LocationExt extends Location
{
    fields
    {
        field(70117; Deliveryadd; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70118; "Skip for Lot FB"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70119; Deliveryadd2; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70120; "GLN Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70121; "Saleable Location"; Boolean)
        {

        }

    }

    var
        myInt: Integer;
}