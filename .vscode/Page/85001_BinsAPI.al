page 85001 "Bins By Location"
{
    PageType = List;
    SourceTable = "Bin";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Bins by Location';
    SourceTableView = sorting("Location Code", Code);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(Code; Rec.Code)
                {
                    Caption = 'Bin Code';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Bin Description';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // You can add custom filters here if needed
    end;
}
