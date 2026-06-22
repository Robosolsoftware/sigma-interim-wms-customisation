table 85009 "Item Configuration"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }


    var
        myInt: Integer;

}