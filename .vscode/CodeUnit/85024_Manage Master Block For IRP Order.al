codeunit 85024 "Manage Master Block"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_SkipBlockedValidationForInvoice: Boolean;
        G_SkipBlockedValidationForShipment: Boolean;


    #Region Creation of orders+++
    //At the time Selecting customer Number on sales order++
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if SalesHeader."IRP Order" = true then
                IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateBillToCustomerNoOnBeforeCheckBlockedCustOnDocs', '', false, false)]
    local procedure OnValidateBillToCustomerNoOnBeforeCheckBlockedCustOnDocs(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if SalesHeader."IRP Order" = true then
                IsHandled := true;
        end;
    end;


    //At the time of selecting Item on sales Line++
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCopyFromItem', '', false, false)]
    local procedure OnBeforeCopyFromItem(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; Item: Record Item)
    var
        L_SalesHeader: Record "Sales Header";
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then begin
            L_SalesHeader.Reset();
            L_SalesHeader.SetRange("Document Type", SalesLine."Document Type");
            L_SalesHeader.SetRange("No.", SalesLine."Document No.");
            if L_SalesHeader.FindFirst() then begin
                if L_SalesHeader."IRP Order" = true then begin
                    IsHandled := true;


                    //Managed Default Code+++
                    if Item.Type = Item.Type::Inventory then begin
                        Item.TestField("Inventory Posting Group");
                        SalesLine."Posting Group" := Item."Inventory Posting Group";
                    end;
                end;
            end;
        end;
    end;
    #EndRegion Creation of orders+++


    #Region Posting Sales Shipment+++
    //Post Sales Shipment even custometr is Blocked++++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckCustBlockage', '', false, false)]
    local procedure OnBeforeCheckCustBlockage(SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        Clear(G_SkipBlockedValidationForShipment);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            IsHandled := true;
        end;

    end;

    //Post Sales Shipment even Item is Blocked++++
    //Step1++    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeItemJnlPostLine', '', false, false)]
    local procedure OnBeforeItemJnlPostLine(SalesHeader: Record "Sales Header")
    begin
        Clear(G_SkipBlockedValidationForShipment);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            G_SkipBlockedValidationForShipment := true;
    end;

    //Step2:- Ignore Default code to check Item & Variant Blocked+++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeCheckItemAndItemVariant', '', false, false)]
    local procedure OnBeforeCheckItemAndItemVariant(var IsHandled: Boolean)
    begin
        if G_SkipBlockedValidationForShipment = true then
            IsHandled := true;
    end;

    //Step3:- Ignore Default code to check Item Blocked+++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeCheckIfItemIsBlocked', '', false, false)]
    local procedure OnBeforeCheckIfItemIsBlocked(var IsHandled: Boolean; var ItemJournalLine: Record "Item Journal Line")
    begin
        if G_SkipBlockedValidationForShipment = true then
            IsHandled := true;

        if ItemJournalLine."Variant Code" = '' then
            Clear(G_SkipBlockedValidationForShipment);
    end;

    //Step4:- Ignore Default code to check Item & Variant Blocked message+++
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnBeforeDisplayErrorIfItemVariantIsBlocked', '', false, false)]
    local procedure OnBeforeDisplayErrorIfItemVariantIsBlocked(var IsHandled: Boolean)
    begin
        if G_SkipBlockedValidationForShipment = true then
            IsHandled := true;

        Clear(G_SkipBlockedValidationForShipment);
    end;
    #EndRegion Posting Sales Shipment+++


    #Region Posting Sales Invoice+++
    //Step1:- 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostInvoice', '', false, false)]
    local procedure OnBeforePostInvoice(var SalesHeader: Record "Sales Header")
    begin
        Clear(G_SkipBlockedValidationForInvoice);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            G_SkipBlockedValidationForInvoice := true;
    end;

    //Step2:- Skip Customer Blocked Checks++
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeCheckBlockedCust', '', false, false)]
    local procedure OnBeforeCheckBlockedCust(var IsHandled: Boolean; DocType: Option)
    begin
        if G_SkipBlockedValidationForInvoice = true then
            IsHandled := true;
    end;


    //Clear Global Variable++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc()
    begin
        Clear(G_SkipBlockedValidationForInvoice);
        Clear(G_SkipBlockedValidationForShipment);
    end;
    #EndRegion Posting Sales Invoice+++
}