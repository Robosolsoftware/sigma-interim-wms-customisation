pageextension 85013 BSOList extends "Blanket Sales Orders"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("O&rder")
        {

            group("Import/Export Blanket Sales Order")
            {
                Caption = 'Import/Export Blanket Sales Order';
                action("Export Blanket Sales Order Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Blanket Sales Order Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Export & Import Blanket SO";
                    begin
                        OpningStock.SampleBlanketSOTemplate();

                    end;
                }
                action("Import Blanket Sales Order")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportSO: codeunit "Export & Import Blanket SO";
                    begin
                        ImportSO.Run();
                        Message('Completed..');
                    end;
                }

            }
        }
        addbefore(Category_Category6)
        {
            group(Category_Category77)
            {
                Caption = 'Import/Export Blanket Sales Order';
                actionref(ExportBlanketSalesOrderTemplate; "Export Blanket Sales Order Template")
                {
                }
                actionref(ImportBlanketSalesOrder; "Import Blanket Sales Order")
                {
                }

            }
        }
    }

    var
        myInt: Integer;
}