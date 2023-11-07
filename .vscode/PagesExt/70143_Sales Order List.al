pageextension 70143 "SC Sales Order List" extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Create &Warehouse Shipment")
        {

            group("Import/Export SO")
            {
                Caption = 'Import/Export SO';
                //Image = Import;
                //ShowAs = Standard;

                action("Export Sales Order Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    PromotedCategory = Process;
                    Promoted = true;
                    Caption = 'Export Sales Order Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Import Sales Order";
                    begin
                        OpningStock.SampleSOTemplate();

                    end;
                }
                action("Upload Sales Order")
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
        // Add changes to page actions here

    }

    var
        myInt: Integer;
}