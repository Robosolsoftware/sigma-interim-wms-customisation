pageextension 70176 "Sales Return Order List" extends "Sales Return Order List"
{
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
}
