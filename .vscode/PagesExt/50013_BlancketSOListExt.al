pageextension 50013 BSOList extends "Blanket Sales Orders"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("O&rder")
        {

            group("Import/Export SO")
            {
                Caption = 'Import/Export SO';
                //Image = Import;
                //ShowAs = Standard;

                action("Export Blanket Sales Order Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    PromotedCategory = Process;
                    Promoted = true;
                    Caption = 'Export Blanket Sales Order Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Import Sales Order";
                    begin
                        OpningStock.SampleSOTemplate();

                    end;
                }
                action("Upload Blanket Sales Order")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Import;

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
    }

    var
        myInt: Integer;
}