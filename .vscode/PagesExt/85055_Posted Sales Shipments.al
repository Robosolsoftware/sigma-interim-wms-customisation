pageextension 85055 "SC Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Location Code")
        {
            field("Inv. Pick No."; Rec."Inv. Pick No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter("Update Document")
        {
            action("Post Item Reclassification")
            {
                ApplicationArea = All;
                Image = PostingEntries;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Post Item Reclassification");
                end;
            }
        }
    }
}