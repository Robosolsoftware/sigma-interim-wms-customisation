pageextension 70121 "TDU Item Journal" extends "Item Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Reason Code")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("P&osting")
        {
            group("Import/Export Adjustment")
            {
                Caption = 'Import/Export Adjustment';
                action("Export Excel Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Excel Template';

                    trigger OnAction()
                    var
                        OpningStock: XmlPort "Opning Stock_To Use";
                    begin
                        OpningStock.SampleTemplate();
                    end;
                }
                action("Import Adjst. Excel")
                {
                    ApplicationArea = All;
                    Image = Import;
                    Caption = 'Import Adjst. Excel';

                    trigger OnAction()
                    var
                        OpningStock: XmlPort "Opning Stock_To Use";
                    begin
                        OpningStock.Run();
                        Message('Completed..');
                    end;
                }

            }

        }
        addbefore(Category_Category4)
        {
            group(Category_Category77)
            {
                Caption = 'Import/Export Adjustment';
                actionref(ExportExcelTemplate; "Export Excel Template")
                {
                }
                actionref(ImportAdjstExcel; "Import Adjst. Excel")
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