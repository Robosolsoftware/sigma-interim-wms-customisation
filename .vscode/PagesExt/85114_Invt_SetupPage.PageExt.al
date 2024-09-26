pageextension 85114 Invt_SetupPage extends "Inventory Setup"
{
    layout
    {
        addafter("Package Nos.")
        {
            field("Post Cost to G/L No. Series"; Rec."Post Cost to G/L No. Series")
            {
                ApplicationArea = All;
            }
            field("Knapp Replenishment No. Series"; Rec."Knapp Replenishment No. Series")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Inventory Periods")
        {
            action("Run job")
            {
                ApplicationArea = All;
                RunObject = codeunit "Post Inv. Cost to G/L-Job";
            }
        }
    }
}
