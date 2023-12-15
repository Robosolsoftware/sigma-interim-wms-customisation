pageextension 70166 ItemLookup extends "Item Lookup"
{
    layout
    {
        addafter("Base Unit of Measure")
        {
            field("Parent Category"; Rec."Parent Category")
            {
                ApplicationArea = All;
            }
        }
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