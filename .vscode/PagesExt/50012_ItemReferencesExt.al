pageextension 50012 "SC Item Reference Entries" extends "Item Reference Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Length; Rec.Length)
            {
                ApplicationArea = all;
            }
            field(Width; Rec.Width)
            {
                ApplicationArea = all;
            }
            field(Height; Rec.Height)
            {
                ApplicationArea = all;
            }
            field(Cubage; Rec.Cubage)
            {
                ApplicationArea = all;
            }
            field(Weight; Rec.Weight)
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