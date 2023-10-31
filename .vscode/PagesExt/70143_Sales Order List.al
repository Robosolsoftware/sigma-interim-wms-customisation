pageextension 70143 "SC Sales Order List" extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
            action("Upload Sales Order")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Insert;

                trigger OnAction()
                var
                    ImportSO: codeunit "Import Sales Order";
                begin
                    ImportSO.Run();
                    Message('Completed..');
                end;
            }
        }
    }

    var
        myInt: Integer;
}