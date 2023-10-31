pageextension 70144 "SC Sales Quotes" extends "Sales Quotes"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Upload Sales Quote")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Insert;

                trigger OnAction()
                var
                    ImportSO: codeunit "Import Sales Quote";
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