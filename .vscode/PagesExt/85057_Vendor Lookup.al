pageextension 85057 "SC Vendor Lookup" extends "Vendor Lookup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Address)
        {
            field("QAU Approved"; Rec."QAU Approved")
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