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
    }




}
