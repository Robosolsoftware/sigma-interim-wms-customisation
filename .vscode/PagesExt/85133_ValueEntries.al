pageextension 85133 ValueEntriesEXT extends "Value Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Navigate")
        {
            action(Delete)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                trigger OnAction()
                var
                    VE: Record "Value Entry";
                    CreateVE: Codeunit CreateValueEntry;
                begin
                    VE.Copy(Rec);
                    CreateVE.DeleteVE(VE);

                end;

            }
        }
    }

    var
        myInt: Integer;
}