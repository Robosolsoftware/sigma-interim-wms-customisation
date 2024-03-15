pageextension 70112 PurchaseCardExt extends "Purchase Order"
{
    layout
    {
        modify("Location Code")
        {
            Editable = G_EditLocation;
        }

        addlast(General)
        {
            field("PO Approval required"; Rec."PO Approval required")
            {
                ApplicationArea = All;
                Editable = false;
            }
            // field("PO Approval Value"; Rec."PO Approval Value")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created At';
            }
            field(SystemCreatedBy; G_Functions.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified At';
            }
            field(SystemModifiedBy; G_Functions.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified By';
            }
        }


        addfirst(factboxes)
        {
            part("Lot-Number-by-Item"; "Lot-Number-by-Item")
            {
                SubPageLink = "Item No." = field("No.");
                ApplicationArea = all;
                Provider = PurchLines;
            }
            part(ItemAttributecustomFactbox; ItemAttributecustomFactbox)
            {
                SubPageLink = "Item No." = field("No.");
                ApplicationArea = all;
                Provider = PurchLines;
                Caption = 'Item Attribute';
            }

            // part(ItemAttributesFactbox; "Item Attributes Factbox")
            // {
            //     ApplicationArea = all;
            //     Provider = PurchLines;
            // }
        }
    }

    actions
    {
        // modify(Release)
        // {
        //     trigger OnBeforeAction()
        //     var
        //         myInt: Integer;
        //         PLine: Record "Purchase Line";
        //         Bin: Record Bin;
        //     begin
        //         if Rec."Min Order Value" > 0 then begin
        //             Rec.CalcFields(Amount);
        //             if Rec.Amount < Rec."Min Order Value" then
        //                 Error('Total order amount is less than Min Order Value');
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
        //                 Error('Total order amount is less than Min Order Value');
        //         end;
        //     end;
        // }
    }

    var
        G_Functions: Codeunit "SC Events & Subscriber";
        G_EditLocation: Boolean;


    trigger OnAfterGetRecord()
    var
        L_PurchaseLine: Record "Purchase Line";
    begin
        Clear(G_EditLocation);
        L_PurchaseLine.Reset();
        L_PurchaseLine.SetRange("Document No.", Rec."No.");
        L_PurchaseLine.SetRange("Document Type", Rec."Document Type");
        if not L_PurchaseLine.IsEmpty then
            G_EditLocation := false
        else
            G_EditLocation := true;
    end;




}
