tableextension 50003 ItemReferenceExt extends "Item Reference"
{
    fields
    {
        field(50004; Length; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; Width; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; Height; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Cubage; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; Weight; Decimal)
        {
            DataClassification = ToBeClassified;
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