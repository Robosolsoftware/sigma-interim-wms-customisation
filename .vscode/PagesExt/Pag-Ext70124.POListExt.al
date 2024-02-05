pageextension 70124 POListExt extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        // modify(Release)
        // {
        //     trigger OnBeforeAction()
        //     var
        //         myInt: Integer;
        //     begin
        //         if Rec."Min Order Value" > 0 then begin
        //             Rec.CalcFields(Amount);
        //             if Rec.Amount < Rec."Min Order Value" then
        //                 Error('Min Order Value is less than Total order amount');
        //         end;

        //     end;
        // }
        // modify(SendApprovalRequest)
        // {
        //     trigger OnBeforeAction()
        //     var
        //         myInt: Integer;
        //     begin
        //         if Rec."Min Order Value" > 0 then begin
        //             Rec.CalcFields(Amount);
        //             if Rec.Amount < Rec."Min Order Value" then
        //                 Error('Min Order Value is less than Total order amount');
        //         end;
        //     end;
        // }
        addafter("P&osting")
        {
            /*group("PO upload")
            {
                Caption = 'PO upload';
                Image = Import;
                action("Export PO Template")
                {
                    ApplicationArea = All;
                    Image = Journal;
                    //PromotedCategory = Process;
                    //Promoted = true;
                    Caption = 'Export PO Template';
                    trigger OnAction()
                    var
                        //UploadPO: XmlPort "Download Purchase Order";
                        UploadPO: XmlPort "Upload Purchase Order";
                    begin
                        UploadPO.SampleTemplate();
                        //UploadPO.Run();
                    end;
                }
                action("Import PO")
                {
                    ApplicationArea = All;
                    Image = Journal;
                    //PromotedCategory = Process;
                    //Promoted = true;
                    Caption = 'Import PO';
                    trigger OnAction()
                    var
                        UploadPO: XmlPort "Upload Purchase Order";
                    begin
                        UploadPO.Run();
                    end;
                }
            }*/
            group("Import/Export PO")
            {
                Caption = 'Import/Export Purchase Order';
                action("Export Purchase Order Template")
                {
                    ApplicationArea = All;
                    Image = Export;
                    Caption = 'Export Purchase Order Template';

                    trigger OnAction()
                    var
                        OpningStock: Codeunit "Export & Import Purchase Order";
                    begin
                        OpningStock.SamplePOTemplate();

                    end;
                }
                action("Import Purchase Order")
                {
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportSO: codeunit "Export & Import Purchase Order";
                    begin
                        ImportSO.Run();
                        Message('Completed..');
                    end;
                }

            }
        }
        addbefore(Category_Process)
        {

            // group(Category_Category77)
            // {
            //     Caption = 'PO upload';
            //     //ShowAs = SplitButton;

            //     actionref(ExportPOTemplate; "Export PO Template")
            //     {
            //     }
            //     actionref(Excel_Upload1; "Import PO")
            //     {
            //     }

            // }

            group(Category_Category77)
            {
                Caption = 'Import/Export Purchase Order';
                //ShowAs = SplitButton;

                actionref(ExportPOTemplate; "Export Purchase Order Template")
                {
                }
                actionref(Excel_Upload1; "Import Purchase Order")
                {
                }

            }
        }

    }

    var
        myInt: Integer;
}