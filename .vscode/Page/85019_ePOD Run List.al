page 85019 "ePOD Run List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ePOD Runs";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Run ID"; Rec."Run ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Agent Code"; Rec."Agent Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Agent Service Code"; Rec."Agent Service Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Depot ID"; Rec."Depot ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    // actions
    // {
    //     area(Navigation)
    //     {
    //         action("Create Consolidated Job")
    //         {
    //             ApplicationArea = All;
    //             Image = Create;

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //         action("Consolidated Job")
    //         {
    //             ApplicationArea = All;
    //             Image = Navigate;
    //             RunObject = page "ePOD Job List";
    //             RunPageLink = "ePOD RunID" = field("Run ID");
    //         }
    //     }
    // }
}