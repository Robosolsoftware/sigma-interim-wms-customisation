pageextension 85107 "SC Customer Bank Account List" extends "Customer Bank Account List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(Active; Rec.Active)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("DD Mandate Generated"; Rec."DD Mandate Generated")
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