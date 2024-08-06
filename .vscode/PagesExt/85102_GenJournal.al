pageextension 85102 GenJournal extends "General Journal"
{

    layout
    {

    }

    actions
    {
        addfirst(processing)
        {
            action("Journal Upload")
            {
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                begin
                    Xmlport.Run(85004);
                end;
            }
        }
    }
}
