codeunit 85005 "Auto Update Credit/Overdue"
{
    SingleInstance = true;

    var
        L_CalledFromCustomer: Boolean;

    trigger OnRun()
    var
        L_Customer: Record Customer;
        L_BilltoCustomer: Record Customer;
        L_SalesHeader: Record "Sales Header";
        CheckCreditLimit: codeunit "Cust-Check Cr. Limit";
        L_CheckCreditLimit: Page "Check Credit Limit";
    begin
        Clear(L_CalledFromCustomer);
        L_Customer.Reset();
        if L_Customer.FindSet() then begin
            repeat
                L_CalledFromCustomer := true;
                if L_Customer."Bill-to Customer No." <> '' then begin
                    L_BilltoCustomer.Reset();
                    L_BilltoCustomer.SetRange("No.", L_Customer."Bill-to Customer No.");
                    if L_BilltoCustomer.FindFirst() then begin
                        L_CheckCreditLimit.ShowWarning(L_BilltoCustomer."No.", 0, 0, true);
                    end;
                end else begin
                    L_CheckCreditLimit.ShowWarning(L_Customer."No.", 0, 0, true);
                end;
            until L_Customer.Next() = 0;

        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Check Credit Limit", OnShowWarningOnBeforeExitValue, '', false, false)]
    local procedure OnShowWarningOnBeforeExitValue(ExitValue: Integer; var Customer: Record Customer)
    begin
        if L_CalledFromCustomer = true then begin
            if ExitValue = 1 then begin
                Customer."Credit limit Exceeded" := true;
                Customer.Modify();
            end else begin
                Customer."Credit limit Exceeded" := false;
                Customer.Modify();
            end;

            if ExitValue = 2 then begin
                Customer."Overdue Balance" := true;
                Customer.Modify();
            end else begin
                Customer."Overdue Balance" := false;
                Customer.Modify();
            end;

            if ExitValue = 3 then begin
                Customer."Credit limit Exceeded" := true;
                Customer."Overdue Balance" := true;
                Customer.Modify();
            end;
        end;
        //CLear Variable++++
        Clear(L_CalledFromCustomer);
    end;


    // Update Credit Limit Warning on customer
    [EventSubscriber(ObjectType::Page, Page::"Check Credit Limit", OnShowWarningOnAfterCalcCreditLimitLCYExitValue, '', false, false)]
    local procedure OnShowWarningOnAfterCalcCreditLimitLCYExitValue(var CustCreditAmountLCY: Decimal; var Customer: Record Customer)
    var
        L_SalesAndReceivablesSetup: Record "Sales & Receivables Setup";
        TotalCreditlimitBasedOnPercentage: Decimal;
    begin
        if L_CalledFromCustomer = true then begin
            L_SalesAndReceivablesSetup.Get();

            if L_SalesAndReceivablesSetup."Credit Limit Ratio" > 0 then begin
                Clear(TotalCreditlimitBasedOnPercentage);
                TotalCreditlimitBasedOnPercentage := Customer."Credit Limit (LCY)" * L_SalesAndReceivablesSetup."Credit Limit Ratio" / 100;
            end else begin
                TotalCreditlimitBasedOnPercentage := Customer."Credit Limit (LCY)";
            end;

            if TotalCreditlimitBasedOnPercentage <= CustCreditAmountLCY then
                Customer."Credit Limit Warning" := true
            else
                Customer."Credit Limit Warning" := false;
            Customer.Modify();
        end;
    end;

}
