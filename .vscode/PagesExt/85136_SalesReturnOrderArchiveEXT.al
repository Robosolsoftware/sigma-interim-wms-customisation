pageextension 85136 SalesReturnOrderArchiveEXT extends "Sales Return List Archive"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Archived By"; Rec."Archived By")
            {
                ApplicationArea = all;
            }
            field("Date Archived"; Rec."Date Archived")
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