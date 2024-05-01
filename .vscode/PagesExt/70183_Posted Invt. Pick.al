pageextension 70183 "SC Posted Invt. Pick" extends "Posted Invt. Pick"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = All;
                Editable = false;
                MultiLine = true;
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