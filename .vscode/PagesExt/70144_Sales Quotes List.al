pageextension 70144 "SC Sales Quotes" extends "Sales Quotes"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Quote")
        {

            group("Import/Export Sales Quote")
            {
                Caption = 'Import/Export Sales Quote';
                action("Export Sales Quote Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Sales Quote Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Export & Import Sales Quote";
                    begin
                        OpningStock.SampleSlesQuoteTemplate();

                    end;
                }
                action("Import Sales Quote")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportSO: codeunit "Export & Import Sales Quote";
                    begin
                        ImportSO.Run();
                        Message('Completed..');
                    end;
                }

            }

        }
        addbefore(Category_Category4)
        {
            group(Category_Category77)
            {
                Caption = 'Import/Export Sales Quote';
                actionref(ExportSalesQuoteTemplate; "Export Sales Quote Template")
                {
                }
                actionref(ImportSalesQuote; "Import Sales Quote")
                {
                }

            }
        }
    }

    var
        myInt: Integer;
}