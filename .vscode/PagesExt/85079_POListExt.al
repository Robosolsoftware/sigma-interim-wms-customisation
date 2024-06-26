pageextension 85079 POListExt extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created At';
            }
            field(SystemCreatedBy; G_MiscellaneousCharges.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created By';
            }
        }
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
        addafter(Print)
        {
            action("Create Warehouse Receipt")
            {
                ApplicationArea = All;
                Image = Create;
                Caption = 'Create Bulk Warehouse Receipt';

                trigger OnAction()
                begin
                    Report.Run(85001, true, false);
                end;
            }
        }
        addlast(Category_Process)
        {
            group(CreateWarehouseReceipt)
            {
                Caption = 'Create Bulk Warehouse Receipt';
                actionref("Create Bulk Warehouse Receipt"; "Create Warehouse Receipt")
                {

                }
            }
        }
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
    }

    var
        myInt: Integer;
        PartiallyReceived: Boolean;
        G_MiscellaneousCharges: Codeunit "Miscellaneous Charges";

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