page 85028 "Shop Group"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Shop Group";

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