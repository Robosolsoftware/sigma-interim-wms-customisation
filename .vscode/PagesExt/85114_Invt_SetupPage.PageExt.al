pageextension 85114 Invt_SetupPage extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Package Nos.")
        {
            field("Post Cost to G/L No. Series"; Rec."Post Cost to G/L No. Series")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        // Add changes to page actions here
        addafter("Inventory Periods")
        {
            action("Run job")
            {
                ApplicationArea = All;
                RunObject = codeunit "Post Inv. Cost to G/L-Job";

                trigger OnAction()
                begin
                end;
            }
        }
    }
    var
        myInt: Integer;
}
