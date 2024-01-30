pageextension 70166 ItemLookup extends "Item Lookup"
{
    
    layout
    {
        addafter("Base Unit of Measure")
        {
            field("Top Category"; Rec."Top Category")
            {
                ApplicationArea = all;
            }
            field("Parent Category"; Rec."Parent Category")
            {
                ApplicationArea = All;
                Width = 20;
            }
        }
        modify("Unit Price")
        {
            Visible = false;
        }
        modify("Base Unit of Measure")
        {
            Visible = false;
        }
        modify(Description)
        {
            Width = 50;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}