page 85003 "Custom Variant List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Custom Variant";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        L_PurchaseLine: Record "Purchase Line";
        WarehouseRecLine: Record "Purchase Line";
        L_PurchaseHeader: Record "Purchase Header";
        te: page "Purchase Order";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        if CloseAction = CloseAction::OK then begin
            if Confirm(StrSubstNo('Do you want to proceed with selected variant %1?', Rec.Code), false) then begin
                case G_SourceDocument of
                    G_SourceDocument::"Purchase Order":
                        begin
                            L_PurchaseHeader.Reset();
                            L_PurchaseHeader.SetRange("No.", G_SourceDocumentNo);
                            if L_PurchaseHeader.FindFirst() then
                                if L_PurchaseHeader.Status = L_PurchaseHeader.Status::Released then begin
                                    ReleasePurchDoc.PerformManualReopen(L_PurchaseHeader);
                                    WarehouseRecLine.Reset();
                                    WarehouseRecLine.SetRange("Document No.", G_SourceDocumentNo);
                                    if WarehouseRecLine.FindFirst() then begin
                                        WarehouseRecLine.Validate("Variant Code", Rec.Code);
                                        WarehouseRecLine.Modify();
                                    end;
                                    ReleasePurchDoc.PerformManualRelease(L_PurchaseHeader);
                                end else begin
                                    WarehouseRecLine.Reset();
                                    WarehouseRecLine.SetRange("Document No.", G_SourceDocumentNo);
                                    if WarehouseRecLine.FindFirst() then begin
                                        WarehouseRecLine.Validate("Variant Code", Rec.Code);
                                        WarehouseRecLine.Modify();
                                    end;
                                end;

                        end;
                end;
            end;
        end;
    end;

    var
        G_SourceDocument: Enum "Warehouse Activity Source Document";
        G_SourceDocumentNo: Code[20];

    procedure GetOrderDetails(_SourceDocument: Enum "Warehouse Activity Source Document"; _SourceDocumentNo: Code[20])
    begin
        Clear(G_SourceDocument);
        Clear(G_SourceDocumentNo);
        G_SourceDocument := _SourceDocument;
        G_SourceDocumentNo := _SourceDocumentNo;
    end;
}