pageextension 70112 PurchaseCardExt extends "Purchase Order"
{
    layout
    {

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
                Caption = 'System Created At';
            }
            field(SystemCreatedBy; G_Functions.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified At';
            }
            field(SystemModifiedBy; G_Functions.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified By';
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
        tes: Page "Item Card";




}
