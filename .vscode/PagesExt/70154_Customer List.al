pageextension 70154 "SC Customer List" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = false;
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