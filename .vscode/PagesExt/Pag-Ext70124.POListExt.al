pageextension 70124 POListExt extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.CalcFields(Amount);
                if Rec.Amount > Rec."Min Order Value" then
                    Error('Min Order Value should be less than total order amount');

            end;
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.CalcFields(Amount);
                if Rec.Amount > Rec."Min Order Value" then
                    Error('Min Order Value should be less than total order amount');

            end;
        }
        addafter("P&osting")
        {
            group("PO upload")
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
            }
        }
        addbefore(Category_Process)
        {

            group(Category_Category77)
            {
                Caption = 'PO upload';
                //ShowAs = SplitButton;

                actionref(ExportPOTemplate; "Export PO Template")
                {
                }
                actionref(Excel_Upload1; "Import PO")
                {
                }

            }
        }

    }

    var
        myInt: Integer;
}