codeunit 85007 "Credit & OverDue Check on SO"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_OrderNo: Code[20];
        G_DocumentType: Enum "Sales Document Type";
        G_CalledFrom: Option " ",Header,Line;
        G_SalesHeadr: Record "Sales Header";
        G_BillToCustomer: Code[20];
        G_Bulkdelete: Boolean;

    //Step1:- Store Order No and Document Type in Global Variable+++[From Header]
    [EventSubscriber(ObjectType::Page, Page::"Check Credit Limit", OnBeforeSalesHeaderShowWarning, '', false, false)]
    local procedure OnBeforeSalesHeaderShowWarning(var SalesHeader: Record "Sales Header")
    begin
        Clear(G_OrderNo);
        Clear(G_DocumentType);
        Clear(G_CalledFrom);
        Clear(G_BillToCustomer);
        G_OrderNo := SalesHeader."No.";
        G_DocumentType := SalesHeader."Document Type";
        G_BillToCustomer := SalesHeader."Bill-to Customer No.";
        G_CalledFrom := G_CalledFrom::Header;
    end;

    //Step2:- Store Order No and Document Type in Global Variable+++[From Line]
    [EventSubscriber(ObjectType::Page, Page::"Check Credit Limit", OnBeforeSalesLineShowWarning, '', false, false)]
    local procedure OnBeforeSalesLineShowWarning(var SalesLine: Record "Sales Line")
    begin
        Clear(G_OrderNo);
        Clear(G_DocumentType);
        Clear(G_CalledFrom);
        Clear(G_BillToCustomer);
        G_OrderNo := SalesLine."Document No.";
        G_DocumentType := SalesLine."Document Type";
        G_BillToCustomer := SalesLine."Bill-to Customer No.";
        G_CalledFrom := G_CalledFrom::Line;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeleteEvent(var Rec: Record "Sales Line")
    var
        L_SalesHeader: Record "Sales Header";
        CheckCreditLimit: codeunit "Cust-Check Cr. Limit";
    begin
        L_SalesHeader.Reset();
        L_SalesHeader.SetRange("No.", Rec."Document No.");
        L_SalesHeader.SetRange("Document Type", Rec."Document Type");
        if L_SalesHeader.FindFirst() then begin
            CheckCreditLimit.SalesLineCheck(Rec);
        end;
    end;

    // procedure callfromsalesInvoiceCreditmemo_Fordeleterequest(_Bulkdelete: Boolean)
    // var
    // begin
    //     Clear(G_Bulkdelete);
    //     G_Bulkdelete := _Bulkdelete;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust-Check Cr. Limit", 'OnBeforeSalesLineCheck', '', false, false)]

    // local procedure OnBeforeSalesLineCheck(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    // var
    //     SalesHeader: Record "Sales Header";
    // begin

    //     if G_Bulkdelete = true then begin
    //         SalesHeader.Reset();
    //         SalesHeader.SetRange("No.", SalesLine."Document No.");
    //         SalesHeader.SetRange("Document Type", SalesLine."Document Type");
    //         if SalesHeader.FindFirst() then begin
    //             if (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) or (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") then
    //                 IsHandled := true;
    //         end;

    //     end;
    //     Clear(G_Bulkdelete);
    // end;



    //Step3:- Check & Update Creadit & OverDue field on SO++
    [EventSubscriber(ObjectType::Page, Page::"Check Credit Limit", OnShowWarningOnBeforeExitValue, '', false, false)]
    local procedure OnShowWarningOnBeforeExitValue(ExitValue: Integer)
    var
        //L_SalesHeader: Record "Sales Header";
        L_Customer: Record Customer;
    begin
        // case G_CalledFrom of
        //     G_CalledFrom::Header:
        //         begin
        //             L_SalesHeader.Reset();
        //             L_SalesHeader.SetRange("No.", G_OrderNo);
        //             L_SalesHeader.SetRange("Document Type", G_DocumentType);
        //             if L_SalesHeader.FindFirst() then begin
        //                 if L_SalesHeader."IRP Order" = false then begin
        //                     if ExitValue = 1 then begin
        //                         L_SalesHeader."Credit limit Exceeded" := true
        //                     end else
        //                         L_SalesHeader."Credit limit Exceeded" := false;

        //                     if ExitValue = 2 then begin
        //                         L_SalesHeader."Overdue Balance" := true
        //                     end else
        //                         L_SalesHeader."Overdue Balance" := false;

        //                     if ExitValue = 3 then begin
        //                         L_SalesHeader."Credit limit Exceeded" := true;
        //                         L_SalesHeader."Overdue Balance" := true;
        //                     end;

        //                     //+++++++
        //                     if ExitValue <> 0 then begin
        //                         if (L_SalesHeader."Exempt from Overdue check" = false) AND (L_SalesHeader.Hospital = false) then begin
        //                             L_SalesHeader."Credit Limit Approval" := true;
        //                             L_SalesHeader.Modify();
        //                         end else begin
        //                             if (L_SalesHeader."Exempt from Overdue check" = true) AND (L_SalesHeader.Hospital = true) then begin
        //                                 L_SalesHeader."Credit Limit Approval" := false;
        //                                 L_SalesHeader.Modify();
        //                             end else begin
        //                                 if (L_SalesHeader."Exempt from Overdue check" = true) AND (L_SalesHeader.Hospital = false) then begin
        //                                     if (ExitValue = 1) OR (ExitValue = 3) then begin
        //                                         L_SalesHeader."Credit Limit Approval" := true;
        //                                         L_SalesHeader.Modify();
        //                                     end else begin
        //                                         L_SalesHeader."Credit Limit Approval" := false;
        //                                         L_SalesHeader.Modify();
        //                                     end;
        //                                 end else begin
        //                                     if (L_SalesHeader."Exempt from Overdue check" = false) AND (L_SalesHeader.Hospital = true) then begin
        //                                         if (ExitValue = 2) OR (ExitValue = 3) then begin
        //                                             L_SalesHeader."Credit Limit Approval" := true;
        //                                             L_SalesHeader.Modify();
        //                                         end else begin
        //                                             L_SalesHeader."Credit Limit Approval" := false;
        //                                             L_SalesHeader.Modify();
        //                                         end;
        //                                     end;
        //                                 end;
        //                             end;
        //                         end;
        //                     end else begin
        //                         L_SalesHeader."Credit Limit Approval" := false;
        //                         L_SalesHeader.Modify();
        //                     end;
        //                 end;
        //             end;
        //         end;
        //     G_CalledFrom::Line:
        //         begin
        //             L_SalesHeader.Reset();
        //             L_SalesHeader.SetRange("No.", G_OrderNo);
        //             L_SalesHeader.SetRange("Document Type", G_DocumentType);
        //             if L_SalesHeader.FindFirst() then begin
        //                 if L_SalesHeader."IRP Order" = false then begin
        //                     if ExitValue = 1 then begin
        //                         L_SalesHeader."Credit limit Exceeded" := true
        //                     end else
        //                         L_SalesHeader."Credit limit Exceeded" := false;
        //                     // if ExitValue = 2 then begin
        //                     //     L_SalesHeader."Overdue Balance" := true;
        //                     // end;
        //                     // if ExitValue = 3 then begin
        //                     //     L_SalesHeader."Credit limit Exceeded" := true;
        //                     //     L_SalesHeader."Overdue Balance" := true;
        //                     // end;

        //                     //+++++++
        //                     if (L_SalesHeader."Exempt from Overdue check" = false) AND (L_SalesHeader.Hospital = false) then begin
        //                         if (L_SalesHeader."Overdue Balance" = true) OR (L_SalesHeader."Credit limit Exceeded" = true) then begin
        //                             L_SalesHeader."Credit Limit Approval" := true;
        //                             L_SalesHeader.Modify();
        //                         end else begin
        //                             L_SalesHeader."Credit Limit Approval" := false;
        //                             L_SalesHeader.Modify();
        //                         end;
        //                     end else begin
        //                         if (L_SalesHeader."Exempt from Overdue check" = true) AND (L_SalesHeader.Hospital = true) then begin
        //                             L_SalesHeader."Credit Limit Approval" := false;
        //                             L_SalesHeader.Modify();
        //                         end else begin
        //                             if (L_SalesHeader."Exempt from Overdue check" = true) AND (L_SalesHeader.Hospital = false) then begin
        //                                 if L_SalesHeader."Credit limit Exceeded" = true then begin
        //                                     L_SalesHeader."Credit Limit Approval" := true;
        //                                     L_SalesHeader.Modify();
        //                                 end else begin
        //                                     L_SalesHeader."Credit Limit Approval" := false;
        //                                     L_SalesHeader.Modify();
        //                                 end;
        //                             end else begin
        //                                 if (L_SalesHeader."Exempt from Overdue check" = false) AND (L_SalesHeader.Hospital = true) then begin
        //                                     if L_SalesHeader."Overdue Balance" = true then begin
        //                                         L_SalesHeader."Credit Limit Approval" := true;
        //                                         L_SalesHeader.Modify();
        //                                     end else begin
        //                                         L_SalesHeader."Credit Limit Approval" := false;
        //                                         L_SalesHeader.Modify();
        //                                     end;
        //                                 end;
        //                             end;
        //                         end;
        //                     end;
        //                 end;
        //             end;
        //         end;
        // end;
        // //CLear Variable When It called from Header++++
        // Clear(G_OrderNo);
        // Clear(G_DocumentType);
        // Clear(G_CalledFrom);


        case G_CalledFrom of
            G_CalledFrom::Header:
                begin
                    G_SalesHeadr.Reset();
                    G_SalesHeadr.SetRange("No.", G_OrderNo);
                    G_SalesHeadr.SetRange("Document Type", G_DocumentType);
                    if G_SalesHeadr.FindFirst() then begin
                        if G_SalesHeadr."IRP Order" = false then begin
                            if ExitValue = 1 then begin
                                G_SalesHeadr."Credit limit Exceeded" := true
                            end else
                                G_SalesHeadr."Credit limit Exceeded" := false;

                            if ExitValue = 2 then begin
                                G_SalesHeadr."Overdue Balance" := true
                            end else
                                G_SalesHeadr."Overdue Balance" := false;

                            if ExitValue = 3 then begin
                                G_SalesHeadr."Credit limit Exceeded" := true;
                                G_SalesHeadr."Overdue Balance" := true;
                            end;

                            //+++++++
                            if ExitValue <> 0 then begin
                                L_Customer.Reset();
                                L_Customer.SetRange("No.", G_BillToCustomer);
                                if L_Customer.FindFirst() then begin
                                    if (L_Customer."Exempt from Overdue check" = false) AND (L_Customer.Hospital = false) then begin
                                        G_SalesHeadr."Credit Limit Approval" := true;
                                        // G_SalesHeadr.Modify();
                                    end else begin
                                        if (L_Customer."Exempt from Overdue check" = true) AND (L_Customer.Hospital = true) then begin
                                            G_SalesHeadr."Credit Limit Approval" := false;
                                            // G_SalesHeadr.Modify();
                                        end else begin
                                            if (L_Customer."Exempt from Overdue check" = true) AND (L_Customer.Hospital = false) then begin
                                                if (ExitValue = 1) OR (ExitValue = 3) then begin
                                                    G_SalesHeadr."Credit Limit Approval" := true;
                                                    // G_SalesHeadr.Modify();
                                                end else begin
                                                    G_SalesHeadr."Credit Limit Approval" := false;
                                                    // G_SalesHeadr.Modify();
                                                end;
                                            end else begin
                                                if (L_Customer."Exempt from Overdue check" = false) AND (L_Customer.Hospital = true) then begin
                                                    if (ExitValue = 2) OR (ExitValue = 3) then begin
                                                        G_SalesHeadr."Credit Limit Approval" := true;
                                                        // G_SalesHeadr.Modify();
                                                    end else begin
                                                        G_SalesHeadr."Credit Limit Approval" := false;
                                                        // G_SalesHeadr.Modify();
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end else
                                    G_SalesHeadr."Credit Limit Approval" := false;
                            end else begin
                                G_SalesHeadr."Credit Limit Approval" := false;
                                // G_SalesHeadr.Modify();
                            end;
                        end;
                    end;
                end;
            G_CalledFrom::Line:
                begin
                    G_SalesHeadr.Reset();
                    G_SalesHeadr.SetRange("No.", G_OrderNo);
                    G_SalesHeadr.SetRange("Document Type", G_DocumentType);
                    if G_SalesHeadr.FindFirst() then begin
                        if G_SalesHeadr."IRP Order" = false then begin
                            if ExitValue = 1 then begin
                                G_SalesHeadr."Credit limit Exceeded" := true
                            end else
                                G_SalesHeadr."Credit limit Exceeded" := false;
                            // if ExitValue = 2 then begin
                            //     G_SalesHeadr."Overdue Balance" := true;
                            // end;
                            // if ExitValue = 3 then begin
                            //     G_SalesHeadr."Credit limit Exceeded" := true;
                            //     G_SalesHeadr."Overdue Balance" := true;
                            // end;

                            //+++++++
                            L_Customer.Reset();
                            L_Customer.SetRange("No.", G_BillToCustomer);
                            if L_Customer.FindFirst() then begin
                                if (L_Customer."Exempt from Overdue check" = false) AND (L_Customer.Hospital = false) then begin
                                    if (G_SalesHeadr."Overdue Balance" = true) OR (G_SalesHeadr."Credit limit Exceeded" = true) then begin
                                        G_SalesHeadr."Credit Limit Approval" := true;
                                        G_SalesHeadr.Modify();
                                    end else begin
                                        G_SalesHeadr."Credit Limit Approval" := false;
                                        G_SalesHeadr.Modify();
                                    end;
                                end else begin
                                    if (L_Customer."Exempt from Overdue check" = true) AND (L_Customer.Hospital = true) then begin
                                        G_SalesHeadr."Credit Limit Approval" := false;
                                        G_SalesHeadr.Modify();
                                    end else begin
                                        if (L_Customer."Exempt from Overdue check" = true) AND (L_Customer.Hospital = false) then begin
                                            if G_SalesHeadr."Credit limit Exceeded" = true then begin
                                                G_SalesHeadr."Credit Limit Approval" := true;
                                                G_SalesHeadr.Modify();
                                            end else begin
                                                G_SalesHeadr."Credit Limit Approval" := false;
                                                G_SalesHeadr.Modify();
                                            end;
                                        end else begin
                                            if (L_Customer."Exempt from Overdue check" = false) AND (L_Customer.Hospital = true) then begin
                                                if G_SalesHeadr."Overdue Balance" = true then begin
                                                    G_SalesHeadr."Credit Limit Approval" := true;
                                                    G_SalesHeadr.Modify();
                                                end else begin
                                                    G_SalesHeadr."Credit Limit Approval" := false;
                                                    G_SalesHeadr.Modify();
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    //CLear Variable When It called from Line++++
                    Clear(G_OrderNo);
                    Clear(G_DocumentType);
                    Clear(G_CalledFrom);
                    Clear(G_SalesHeadr);
                    Clear(G_BillToCustomer);
                end;
        end;
    end;

    //Step4 This code only for header and it called when we select customer number
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification, '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(var SalesHeader: Record "Sales Header")
    begin
        if G_SalesHeadr."No." <> '' then begin
            SalesHeader."Overdue Balance" := G_SalesHeadr."Overdue Balance";
            SalesHeader."Credit limit Exceeded" := G_SalesHeadr."Credit limit Exceeded";
            SalesHeader."Credit Limit Approval" := G_SalesHeadr."Credit Limit Approval";
        end;

        //CLear Variable When It called from Header++++
        Clear(G_OrderNo);
        Clear(G_DocumentType);
        Clear(G_CalledFrom);
        Clear(G_SalesHeadr);
        Clear(G_BillToCustomer);
    end;


    //FIN-28[08/01/2025]+++++
    [EventSubscriber(ObjectType::Page, PAGE::"Check Credit Limit", OnCalcOverdueBalanceLCYAfterSetFilter, '', false, false)]
    local procedure OnCalcOverdueBalanceLCYAfterSetFilter(var Customer: Record Customer)
    var
        L_SalesAndRecvSetup: Record "Sales & Receivables Setup";
    begin
        L_SalesAndRecvSetup.Get();
        L_SalesAndRecvSetup.TestField("Due Date Buffer");
        Customer.SetRange("Date Filter");
        Customer.SetFilter("Date Filter", '..%1', CalcDate(Format(L_SalesAndRecvSetup."Due Date Buffer"), WorkDate()));
    end;

}