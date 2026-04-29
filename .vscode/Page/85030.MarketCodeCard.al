page 85030 "Market Code"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Market Code";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        myInt: Integer;
}