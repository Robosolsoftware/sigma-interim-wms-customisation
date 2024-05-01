codeunit 70177 "Requisation WorkSheet Cust."
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_CombinePO: Boolean;
        G_PlanningResiliency: Boolean;


    //Step1 :- Check PlanningResiliency++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforeProcessReqLineActions', '', false, false)]
    local procedure OnBeforeProcessReqLineActions(PlanningResiliency: Boolean)
    begin
        G_PlanningResiliency := PlanningResiliency;
    end;

    //Step2 :- Get the filter to check +++
    procedure IsCombinePO(_CombinePO: Boolean)
    begin
        Clear(G_CombinePO);
        G_CombinePO := _CombinePO;
    end;

    //Step3 :- 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforeCheckInsertFinalizePurchaseOrderHeader', '', false, false)]
    local procedure OnBeforeCheckInsertFinalizePurchaseOrderHeader(var CheckInsert: Boolean; var PurchaseHeader: Record "Purchase Header"; RequisitionLine: Record "Requisition Line")
    begin
        if (Not G_PlanningResiliency) AND (G_CombinePO = true) then begin
            CheckInsert := PurchaseHeader."Buy-from Vendor No." <> RequisitionLine."Vendor No.";
        end;
    end;

}