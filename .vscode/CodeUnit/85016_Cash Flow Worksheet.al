codeunit 85016 "Cash Flow Worksheet"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Worksheet Lines", 'OnInsertCFLineForVendorLedgEntryOnBeforeInsertTempCFWorksheetLine', '', false, false)]
    local procedure OnInsertCFLineForVendorLedgEntryOnBeforeInsertTempCFWorksheetLine(var CashFlowWorksheetLine: Record "Cash Flow Worksheet Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        CashFlowWorksheetLine."Posting Date" := VendorLedgerEntry."Posting Date";
        CashFlowWorksheetLine."Vendor Name" := VendorLedgerEntry."Vendor Name";
    end;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Worksheet Lines", 'OnInsertCFLineForPurchaseLineOnBeforeInsertTempCFWorksheetLine', '', false, false)]
    local procedure OnInsertCFLineForPurchaseLineOnBeforeInsertTempCFWorksheetLine(var CashFlowWorksheetLine: Record "Cash Flow Worksheet Line"; PurchaseLine: Record "Purchase Line")
    var
        L_PurchaseHeader: Record "Purchase Header";
        L_Vendor: Record Vendor;
        L_PaymentTerms: Record "Payment Terms";
    begin
        if PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order then begin
            L_PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            CashFlowWorksheetLine."Payment Terms Code" := L_PurchaseHeader."Payment Terms Code";
            CashFlowWorksheetLine."Document Date" := L_PurchaseHeader."Document Date";
            CashFlowWorksheetLine."Posting Date" := L_PurchaseHeader."Posting Date";
            CashFlowWorksheetLine."Vendor Name" := L_PurchaseHeader."Buy-from Vendor Name";
            CashFlowWorksheetLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";
            L_PaymentTerms.Reset();
            L_PaymentTerms.SetRange("Code", L_PurchaseHeader."Payment Terms Code");
            if L_PaymentTerms.FindFirst() then begin
                if PurchaseLine."Expected Receipt Date" <> 0D then
                    CashFlowWorksheetLine."Cashflow Date (2)" := CalcDate(L_PaymentTerms."Due Date Calculation", PurchaseLine."Expected Receipt Date");
            end;
            L_Vendor.Reset();
            if L_Vendor.Get(L_PurchaseHeader."Buy-from Vendor No.") then
                CashFlowWorksheetLine."Vendor Group" := L_Vendor."Vendor Group";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cash Flow Wksh. -Register Line", 'OnAfterCreateForecastEntry', '', false, false)]
    local procedure OnAfterCreateForecastEntry(CashFlowWorksheetLine: Record "Cash Flow Worksheet Line"; var CashFlowForecastEntry: Record "Cash Flow Forecast Entry")
    begin
        CashFlowForecastEntry."Posting Date" := CashFlowWorksheetLine."Posting Date";
        CashFlowForecastEntry."Vendor Name" := CashFlowWorksheetLine."Vendor Name";
        CashFlowForecastEntry."Vendor Group" := CashFlowWorksheetLine."Vendor Group";
        CashFlowForecastEntry."Payment Terms Code" := CashFlowWorksheetLine."Payment Terms Code";
        CashFlowForecastEntry."Expected Receipt Date" := CashFlowWorksheetLine."Expected Receipt Date";
        CashFlowForecastEntry."Cashflow Date (2)" := CashFlowWorksheetLine."Cashflow Date (2)";
    end;
}