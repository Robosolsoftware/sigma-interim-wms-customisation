pageextension 85142 "SC Price List Line Review" extends "Price List Line Review"
{
    layout
    {
        // Add changes to page layout here
        modify("Unit Price")
        {
            Visible = true;
        }
        moveafter(Description; "Unit Price")
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}