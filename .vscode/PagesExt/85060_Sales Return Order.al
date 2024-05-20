pageextension 85060 "SC Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field(Rejection; Rec.Rejection)
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