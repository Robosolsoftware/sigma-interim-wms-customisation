page 70101 "Temperature Category"
{
    PageType = List;
    SourceTable = "Temperature Range";
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Min. Temperature"; Rec."Min. Temperature")
                {
                    ApplicationArea = All;

                }
                field("Max Temperature"; Rec."Max Temperature")
                {
                    ApplicationArea = All;
                }
                field("Print On Pick Sheet"; Rec."Print On Pick Sheet")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Highlight Line on Pick Sheet"; Rec."Highlight Line on Pick Sheet")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Print On Invoice"; Rec."Print On Invoice")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Print On Shipment"; Rec."Print On Shipment")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Print On Purch. Order"; Rec."Print On Purch. Order")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Print On Sales Order"; Rec."Print On Sales Order")
                {

                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {

        }
    }

    actions
    {
        area(processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                trigger OnAction();
                begin

                end;
            }
        }
    }
}