//Dont Use this codeunit for any customization++
codeunit 85006 "Manage Dimension Caption"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_Caption: Text;
        G_DocumentType: Enum "Sales Document Type";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', true, true)]
    local procedure MyOnResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    begin
        if CaptionArea = '85148' then begin
            Clear(G_Caption);
            Caption := GetCaptionItemAttribute(CaptionExpr);
            G_Caption := GetCaptionItemAttribute(CaptionExpr);
            Resolved := true;
        end;
    end;

    local procedure GetCaptionItemAttribute(CaptionExpr: Text): Text
    var
        FieldNo: Integer;
        Fiedrefrence: FieldRef;
        SetupRecordRef: RecordRef;
    begin
        SetupRecordRef.Open(Database::"General Ledger Setup");
        Evaluate(FieldNo, CaptionExpr);
        If SetupRecordRef.FindFirst() then begin
            Fiedrefrence := SetupRecordRef.Field(FieldNo);
            exit(Fiedrefrence.Value);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure SelltoCustomer_OnAfterValidateEvent(var Rec: Record "Sales Header")
    var
        L_DimensionSetEntry: Record "Dimension Set Entry";
    begin
        L_DimensionSetEntry.Reset();
        L_DimensionSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
        L_DimensionSetEntry.SetRange("Dimension Code", GetCaptionItemAttribute('83'));
        if L_DimensionSetEntry.FindFirst() then begin
            L_DimensionSetEntry.CalcFields("Dimension Value Name");
            if Rec."Shortcut Dimension 3 Code" <> L_DimensionSetEntry."Dimension Value Name" then begin
                Rec."Shortcut Dimension 3 Code" := L_DimensionSetEntry."Dimension Value Name";
            end;
        end;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCreateDimOnBeforeUpdateLines', '', false, false)]
    // local procedure OnCreateDimOnBeforeUpdateLines(var SalesHeader: Record "Sales Header")
    // var
    //     L_DimensionSetEntry: Record "Dimension Set Entry";
    // begin
    //     L_DimensionSetEntry.Reset();
    //     L_DimensionSetEntry.SetRange("Dimension Set ID", SalesHeader."Dimension Set ID");
    //     L_DimensionSetEntry.SetRange("Dimension Code", G_Caption);
    //     if L_DimensionSetEntry.FindFirst() then begin
    //         L_DimensionSetEntry.CalcFields("Dimension Value Name");
    //         if SalesHeader."Shortcut Dimension 3 Code" <> L_DimensionSetEntry."Dimension Value Name" then begin
    //             SalesHeader."Shortcut Dimension 3 Code" := L_DimensionSetEntry."Dimension Value Name";
    //             //SalesHeader.Modify();
    //         end;
    //     end;
    // end;


    //Non-Editable Dimesion on SO
    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnBeforeEditDimensionSet2', '', false, false)]
    local procedure OnBeforeEditDimensionSet2(RecVariant: Variant)
    var
        L_SalesHeader: Record "Sales Header";
        RecordRef: RecordRef;
    begin
        L_SalesHeader.Reset();
        RecordRef.GetTable(RecVariant);
        if RecordRef.Number = 36 then begin
            RecordRef.SetTable(L_SalesHeader);
            Clear(G_DocumentType);
            G_DocumentType := L_SalesHeader."Document Type";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnEditDimensionSetOnBeforeEditDimEntries', '', false, false)]
    local procedure OnEditDimensionSetOnBeforeEditDimEntries(var EditDimSetEntries: Page "Edit Dimension Set Entries")
    var
        L_SalesHeader: Record "Sales Header";
    begin
        if G_DocumentType = G_DocumentType::Order then
            EditDimSetEntries.Editable(false);
    end;
}