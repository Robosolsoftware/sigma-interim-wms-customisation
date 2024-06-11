pageextension 85037 "SC Sales Price Lists" extends "Sales Price Lists"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Special Price Daily"; Rec."Special Price Daily")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Daily Promotions';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ActionGroupCRM)
        {
            group("Import/Export SPrice")
            {
                Caption = 'Import/Export Sales Price';
                action("Export Sales Price")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Sales Price';

                    trigger OnAction()
                    var
                        ExportImportSalesPrice: Codeunit "Export & Import Sales Price";
                    begin
                        ExportImportSalesPrice.ExportSalesPriceTemplate();
                    end;
                }
                action("Import Sales Price")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ExportImportSalesPrice: Codeunit "Export & Import Sales Price";
                    begin
                        ExportImportSalesPrice.Run();
                        Message('Completed..');
                    end;
                }

            }
        }
        addbefore(Category_Process)
        {

            group(Category_Category77)
            {
                Caption = 'Import/Export Sales Price';

                actionref(ExportSalesPrice; "Export Sales Price")
                {
                }
                actionref(ImportSalesPrice; "Import Sales Price")
                {
                }

            }
        }
    }

    var
        myInt: Integer;
        tes: Page "Sales Price List";
}