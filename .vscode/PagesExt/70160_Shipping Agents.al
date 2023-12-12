pageextension 70160 "SC Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Restrict CD & Fridge"; Rec."Restrict CD & Fridge")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}