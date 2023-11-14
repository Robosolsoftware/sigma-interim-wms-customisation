pageextension 70112 PurchaseCardExt extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = false;
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
        }
    }

    actions
    {
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                PLine: Record "Purchase Line";
                Bin: Record Bin;
            begin
                Rec.CalcFields(Amount);
                if Rec.Amount > Rec."Min Order Value" then
                    Error('Min Order Value should be less than total order amount');

                // PLine.Reset();
                // PLine.SetRange("Document Type", Rec."Document Type");
                // PLine.SetRange("Document No.", Rec."No.");
                // PLine.SetRange(Type, PLine.Type::Item);
                // if PLine.FindSet() then
                //     repeat
                //         Bin.Reset();
                //         Bin.SetRange("Warehouse Class Code", PLine."Warehouse Class Code");
                //         if Bin.FindFirst() then begin
                //             if Bin."Location Code" <> Rec."Location Code" then
                //                 Error('Warehouse class Code: %1 missmatch for Location: %2', PLine."Warehouse Class Code", Rec."Location Code");
                //         end else
                //             Error('Warehouse class Code: %1 missmatch for Location: %2', PLine."Warehouse Class Code", Rec."Location Code");

                //     until PLine.Next() = 0

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
    }




}
