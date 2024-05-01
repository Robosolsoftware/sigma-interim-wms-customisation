reportextension 50000 "SC Carry Out Action Msg. - Req" extends "Carry Out Action Msg. - Req."
{
    dataset
    {
        // Add changes to dataitems and columns here
    }

    requestpage
    {
        // Add changes to the requestpage here
        layout
        {
            addbefore(PrintOrders)
            {
                field(G_CreateCombinePO; G_CreateCombinePO)
                {
                    ApplicationArea = All;
                    Caption = 'Create Combine PO';
                }
            }
        }


        trigger OnOpenPage()
        begin
            G_CreateCombinePO := true;
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            L_RequisationWorkSheetCustomization: Codeunit "Requisation WorkSheet Cust.";
        begin
            if CloseAction = CloseAction::OK then begin
                L_RequisationWorkSheetCustomization.IsCombinePO(G_CreateCombinePO);
            end;
        end;
    }

    var
        G_CreateCombinePO: Boolean;
}