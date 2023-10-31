tableextension 70128 BinExt extends Bin
{
    fields
    {
        field(70285; "Exclude from Fact box"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}