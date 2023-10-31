pageextension 50001 "Item Reclassification Journal" extends "Item Reclass. Journal"
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
            group("Reclassification Upload")
            {
                Caption = 'Reclassification Upload';
                Image = Import;
                action("Export Excel Template")
                {
                    ApplicationArea = All;
                    Image = Journal;
                    //PromotedCategory = Process;
                    //Promoted = true;
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
                    Image = Journal;
                    //PromotedCategory = Process;
                    //Promoted = true;
                    Caption = 'Import Reclass. Excel';

                    trigger OnAction()
                    var
                        ItemReclassJ: XmlPort "Item Reclassification";
                    begin
                        ItemReclassJ.Run();
                    end;
                }

            }


        }
        addbefore(Category_Category4)
        {
            group(Category_Category77)
            {
                Caption = 'Reclass Upload';
                //ShowAs = SplitButton;

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