page 85029 "Market Code List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Market Code";
    CardPageId = "Market Code";
    Caption = 'Market Codes';

    layout
    {
        area(Content)
        {
            repeater(Group)
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

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}