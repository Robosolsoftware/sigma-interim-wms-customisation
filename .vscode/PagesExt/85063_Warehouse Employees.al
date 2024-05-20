pageextension 85063 "SC Warehouse Employees" extends "Warehouse Employees"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Allow selection on PO"; Rec."Allow selection on PO")
            {
                ApplicationArea = All;
            }
            field("Allow selection on SO"; Rec."Allow selection on SO")
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