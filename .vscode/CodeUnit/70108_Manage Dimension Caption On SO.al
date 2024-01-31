//Dont Use this codeunit for any customization++
codeunit 70108 "Manage Dimension Caption"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_Caption: Text;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', true, true)]
    local procedure MyOnResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    begin
        if CaptionArea = '50000' then begin
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

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure OnAfterGetRecordEvent(var Rec: Record "Sales Header")
    var
        L_DimensionSetEntry: Record "Dimension Set Entry";
    begin
        L_DimensionSetEntry.Reset();
        L_DimensionSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
        L_DimensionSetEntry.SetRange("Dimension Code", G_Caption);
        if L_DimensionSetEntry.FindFirst() then begin
            L_DimensionSetEntry.CalcFields("Dimension Value Name");
            if Rec."Shortcut Dimension 3 Code" <> L_DimensionSetEntry."Dimension Value Name" then begin
                Rec."Shortcut Dimension 3 Code" := L_DimensionSetEntry."Dimension Value Name";
                Rec.Modify();
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCreateDimOnBeforeUpdateLines', '', false, false)]
    local procedure OnCreateDimOnBeforeUpdateLines(var SalesHeader: Record "Sales Header")
    var
        L_DimensionSetEntry: Record "Dimension Set Entry";
    begin
        L_DimensionSetEntry.Reset();
        L_DimensionSetEntry.SetRange("Dimension Set ID", SalesHeader."Dimension Set ID");
        L_DimensionSetEntry.SetRange("Dimension Code", G_Caption);
        if L_DimensionSetEntry.FindFirst() then begin
            L_DimensionSetEntry.CalcFields("Dimension Value Name");
            if SalesHeader."Shortcut Dimension 3 Code" <> L_DimensionSetEntry."Dimension Value Name" then begin
                SalesHeader."Shortcut Dimension 3 Code" := L_DimensionSetEntry."Dimension Value Name";
                //SalesHeader.Modify();
            end;
        end;
    end;
}