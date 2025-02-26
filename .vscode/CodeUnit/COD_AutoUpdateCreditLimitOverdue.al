codeunit 85005 "Auto Update Credit/Overdue"
{
    trigger OnRun()
    var
        L_Customer: Record Customer;
        L_BilltoCustomer: Record Customer;
        L_SalesHeader: Record "Sales Header" temporary;
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
                            L_Customer."Credit limit Exceeded" := true;
                    end;
                end else begin
                    L_Customer.CalcFields("Balance (LCY)");
                    if L_Customer."Balance (LCY)" > L_Customer."Credit Limit (LCY)" then
                        L_Customer."Credit limit Exceeded" := true;
                end;
                L_SalesHeader.DeleteAll();
                L_SalesHeader.Init();
                L_SalesHeader.Validate("Document Type", L_SalesHeader."Document Type"::Order);
                L_SalesHeader.Validate("No.", 'Temp');
                L_SalesHeader.Validate("Sell-to Customer No.", L_Customer."No.");
                L_SalesHeader.Insert(true);
                if CheckCreditLimit.SalesHeaderCheck(L_SalesHeader) = true then
                    L_Customer."Overdue Balance" := true;

                L_Customer.Modify();
            until L_Customer.Next() = 0;
        end;
    end;
}
