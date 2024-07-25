codeunit 85020 "Batch Inventory Pick Post"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_BatchPostRequire: Boolean;

    procedure IsBatchPost(_G_BatchPostRequire: Boolean)
    begin
        Clear(G_BatchPostRequire);
        G_BatchPostRequire := _G_BatchPostRequire;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var HideDialog: Boolean)
    begin
        if G_BatchPostRequire = true then begin
            HideDialog := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterSetInvoiceSourceDoc', '', false, false)]
    local procedure OnAfterSetInvoiceSourceDoc(var InvoiceSourceDocument: Boolean)
    begin
        if G_BatchPostRequire = true then begin
            InvoiceSourceDocument := true;
            Clear(G_BatchPostRequire);
        end;
    end;
}