pageextension 85096 "SC Sales Order Archives" extends "Sales Order Archives"
{
    layout
    {
        // Add changes to page layout here
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