tableextension 85031 BinExt extends Bin
{
    fields
    {
        field(85000; "Exclude from Fact box"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}