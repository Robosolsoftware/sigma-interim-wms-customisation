pageextension 85096 "SC Sales Order Archives" extends "Sales Order Archives"
{
    layout
    {
        // Add changes to page layout here
        addafter("Archived By")
        {
            field("Sales Order Created By"; Rec."Sales Order Created By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Web Order"; Rec."Web Order")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(Processing)
        {
            action("Bulk Delete")
            {
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                var
                    L_SalesHeaderArchive: Record "Sales Header Archive";
                begin
                    L_SalesHeaderArchive.Reset();
                    CurrPage.SetSelectionFilter(L_SalesHeaderArchive);
                    if L_SalesHeaderArchive.FindSet() then
                        repeat
                            L_SalesHeaderArchive.DeleteAll(true);
                        until L_SalesHeaderArchive.Next() = 0;
                    Message('Completed..');
                end;
            }
        }
    }

    var
        myInt: Integer;
}