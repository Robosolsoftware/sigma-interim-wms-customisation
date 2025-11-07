pageextension 85143 ReasonCodesExt extends "Reason Codes"
{
    layout
    {
        addafter(Description)
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = all;
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