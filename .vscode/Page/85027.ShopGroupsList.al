page 85027 "Shop Group List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Shop Group";
    CardPageId = "Shop Group";
    Caption = 'Shop Groups';

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