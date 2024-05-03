pageextension 70124 POListExt extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Warehouse Receipt Exist"; Rec."Warehouse Receipt Exist")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(PartiallyReceived; PartiallyReceived)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Partially Received';
            }
        }
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
            group("Import/Export PO With No")
            {
                Caption = 'Import/Export Purchase Order With No';
                action("Export PO Template")
                {
                    ApplicationArea = All;
                    Image = Journal;
                    //PromotedCategory = Process;
                    //Promoted = true;
                    Caption = 'Export PO Template With No';
                    trigger OnAction()
                    var
                        UploadPO: XmlPort "Upload Purchase Order";
                    begin
                        UploadPO.SampleTemplate();
                    end;
                }
                action("Import PO")
                {
                    ApplicationArea = All;
                    Image = Journal;
                    //PromotedCategory = Process;
                    //Promoted = true;
                    Caption = 'Import PO With No';
                    trigger OnAction()
                    var
                        UploadPO: XmlPort "Upload Purchase Order";
                    begin
                        UploadPO.Run();
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

            group(Category_Category78)
            {
                Caption = 'Import/Export Purchase Order With No';
                actionref(ExportPOTemplateWithNo; "Export PO Template")
                {

                }
                actionref(ImportPoWithNo; "Import PO")
                {

                }
            }
        }

    }

    var
        myInt: Integer;
        PartiallyReceived: Boolean;

    trigger OnAfterGetRecord()
    var
        L_PurchaseLine: Record "Purchase Line";
    begin
        Clear(PartiallyReceived);
        L_PurchaseLine.Reset();
        L_PurchaseLine.SetRange("Document Type", Rec."Document Type");
        L_PurchaseLine.SetRange("Document No.", Rec."No.");
        L_PurchaseLine.SetRange(Type, L_PurchaseLine.Type::Item);
        if L_PurchaseLine.FindSet() then begin
            L_PurchaseLine.CalcSums("Quantity Received", Quantity);
            if (L_PurchaseLine."Quantity Received" > 0) AND (L_PurchaseLine."Quantity Received" < L_PurchaseLine.Quantity) then begin
                PartiallyReceived := true;
            end;
        end;
    end;
}