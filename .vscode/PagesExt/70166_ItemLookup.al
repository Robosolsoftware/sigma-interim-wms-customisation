pageextension 70166 ItemLookup extends "Item Lookup"
{
    layout
    {
        modify("Unit Price")
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