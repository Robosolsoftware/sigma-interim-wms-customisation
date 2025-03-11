codeunit 85005 "Auto Update Credit/Overdue"
{
    trigger OnRun()
    var
        L_Customer: Record Customer;
        L_BilltoCustomer: Record Customer;
        L_SalesHeader: Record "Sales Header";
        CheckCreditLimit: codeunit "Cust-Check Cr. Limit";
    begin
        L_Customer.Reset();
        if L_Customer.FindSet() then begin
            repeat
                if L_Customer."Bill-to Customer No." <> '' then begin
                    L_BilltoCustomer.Reset();
                    L_BilltoCustomer.SetRange("No.", L_Customer."Bill-to Customer No.");
                    if L_BilltoCustomer.FindFirst() then begin
                        L_BilltoCustomer.CalcFields("Balance (LCY)");
                        if L_BilltoCustomer."Balance (LCY)" > L_BilltoCustomer."Credit Limit (LCY)" then
                            L_Customer."Credit limit Exceeded" := true
                        else
                            L_Customer."Credit limit Exceeded" := false;
                    end;
                end else begin
                    L_Customer.CalcFields("Balance (LCY)");
                    if L_Customer."Balance (LCY)" > L_Customer."Credit Limit (LCY)" then
                        L_Customer."Credit limit Exceeded" := true
                    else
                        L_Customer."Credit limit Exceeded" := false;
                end;

                L_SalesHeader.Reset();
                L_SalesHeader.SetRange("Document Type", L_SalesHeader."Document Type"::Order);
                L_SalesHeader.SetRange("Sell-to Customer No.", L_Customer."No.");
                L_SalesHeader.SetCurrentKey("Shipment Date");
                L_SalesHeader.SetAscending("Shipment Date", false);
                if L_SalesHeader.FindFirst() then begin
                    if CheckCreditLimit.SalesHeaderCheck(L_SalesHeader) = true then
                        L_Customer."Overdue Balance" := true
                    else
                        L_Customer."Overdue Balance" := false;
                end else
                    L_Customer."Overdue Balance" := false;
                L_Customer.Modify();
            until L_Customer.Next() = 0;

        end;
    end;
}
