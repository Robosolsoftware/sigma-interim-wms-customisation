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
            group("Adjustment Upload")
            {
                Caption = 'Adjustment Upload';
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
                        OpningStock: XmlPort "Opning Stock_To Use";
                    begin
                        OpningStock.SampleTemplate();

                    end;
                }
                action("Import Adjst. Excel")
                {
                    ApplicationArea = All;
                    Image = Journal;
                    //PromotedCategory = Process;
                    //Promoted = true;
                    Caption = 'Import Adjst. Excel';

                    trigger OnAction()
                    var
                        OpningStock: XmlPort "Opning Stock_To Use";
                    begin
                        OpningStock.Run();
                    end;
                }

            }

        }
        addbefore(Category_Category5)
        {
            group(Category_Category77)
            {
                Caption = 'Adjustment Upload';
                //ShowAs = SplitButton;

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