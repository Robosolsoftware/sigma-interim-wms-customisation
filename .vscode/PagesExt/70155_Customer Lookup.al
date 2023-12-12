pageextension 70155 "SC Customer Lookup" extends "Customer Lookup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify(Address)
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}