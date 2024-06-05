pageextension 85080 TransferOrdListRBE extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
        modify(Control1900383207)
        { Visible = true; }
        addafter("Direct Transfer")
        {
            field("System CreatedAt"; rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                caption = 'Created At';

            }
            field("System CreatedBy"; GetUserName(rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Caption = 'Created By';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("P&osting")
        {
            group("Import/Export TO")
            {
                Caption = 'Import/Export Transfer Order';
                action("Export Transfer Order Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Transfer Order Template';

                    trigger OnAction()
                    var
                        ExportImportTransferOrder: Codeunit "Export & Import Transfer Order";
                    begin
                        ExportImportTransferOrder.SamplePOTemplate();
                    end;
                }
                action("Import Transfer Order")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ExportImportTransferOrder: Codeunit "Export & Import Transfer Order";
                    begin
                        ExportImportTransferOrder.Run();
                        Message('Completed..');
                    end;
                }

            }
        }
        addbefore(Category_Process)
        {

            group(Category_Category77)
            {
                Caption = 'Import/Export Transfer Order';

                actionref(ExportTOTemplate; "Export Transfer Order Template")
                {
                }
                actionref(Excel_Upload1; "Import Transfer Order")
                {
                }

            }
        }
    }

    var
        myInt: Integer;

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