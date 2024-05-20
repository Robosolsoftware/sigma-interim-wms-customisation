pageextension 85001 "Item Reclassification Journal" extends "Item Reclass. Journal"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        addafter("P&osting")
        {
            group("Import/Export Reclassification")
            {
                Caption = 'Import/Export Reclassification';
                action("Export Excel Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Excel Template';

                    trigger OnAction()
                    var
                        ItemReclassJ: XmlPort "Item Reclassification";
                    begin
                        ItemReclassJ.SampleTemplate();
                    end;
                }
                action("Import Reclass. Excel")
                {
                    ApplicationArea = All;
                    Image = Import;
                    Caption = 'Import Reclass. Excel';
                    trigger OnAction()
                    var
                        ItemReclassJ: XmlPort "Item Reclassification";
                    begin
                        ItemReclassJ.Run();
                        Message('Completed..');
                    end;
                }

            }


        }
        addbefore(Category_Category4)
        {
            group(Category_Category77)
            {
                Caption = 'Import/Export Reclassification';

                actionref(ExportExcelTemplate; "Export Excel Template")
                {
                }
                actionref(ImportAdjstExcel; "Import Reclass. Excel")
                {
                }

            }
        }

    }
    // actionref(PO_Upload; "PO upload")
    // {

    // }

    var
        myInt: Integer;
}