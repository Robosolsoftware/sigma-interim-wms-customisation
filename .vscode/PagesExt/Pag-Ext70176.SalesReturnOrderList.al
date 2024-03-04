pageextension 70176 "Sales Return Order List" extends "Sales Return Order List"
{

    layout
    {
        addlast(Control1)
        {
            field("System CreatedBy"; GetUserName(rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Caption = 'Created By';
            }
            field("System CreatedAt"; rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                caption = 'Created At';

            }
        }
    }

    actions
    {
        addafter("P&osting")
        {
            group("Import/Export SR")
            {
                Caption = 'Import/Export Sales Return Order';
                action("Export Sales Order Return Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Sales Return Order Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Export Import Sales Return";
                    begin
                        OpningStock.SampleSOTemplate();

                    end;
                }
                action("Import Sales Return Order")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportSO: codeunit "Export Import Sales Return";
                    begin
                        ImportSO.Run();
                        Message('Completed..');
                    end;
                }

            }
        }
    }


    procedure GetUserName(UserSecurityId: Code[50]): Text[100]
    var
        Users: Record User;
    begin
        Users.Reset();
        Users.SetRange("User Security ID", UserSecurityId);
        if Users.FindFirst() then
            exit(Users."Full Name");

    end;
}
