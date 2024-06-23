codeunit 85019 "Create Whs. Recpt & Put-Away"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_SkipError: Boolean;


    //1st Skip for BlockedItem++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnBeforeGetSourceDocumentsRun', '', false, false)]
    local procedure OnBeforeGetSourceDocumentsRun(var GetSourceDocuments: Report "Get Source Documents"; var WarehouseRequest: Record "Warehouse Request")
    begin
        if WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Purchase Order" then begin
            if G_SkipError = true then begin
                GetSourceDocuments.SetSkipBlockedItem(true);
            end;
        end;
    end;


    //2end Skip
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforePostReport', '', false, false)]
    local procedure OnBeforePostReport(var HideDialog: Boolean; RequestType: Option; var WhseRequest: Record "Warehouse Request")
    var
        L_RequestType: Option Receive,Ship;
    begin
        if RequestType = L_RequestType::Receive then begin
            if WhseRequest."Source Document" = WhseRequest."Source Document"::"Purchase Order" then begin
                if G_SkipError = true then begin
                    HideDialog := true;
                end;
            end;
        end;
    end;

    procedure SkiErrorMessage(_SkipError: Boolean)
    begin
        Clear(G_SkipError);
        G_SkipError := _SkipError;
    end;

}