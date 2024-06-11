//Dont Use this codeunit for any customization++

codeunit 85000 "WHP Based On BIN"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_SourceDocument: Enum "Warehouse Activity Source Document";
        G_SourceType: Integer;
        G_SourceSubType: Option;
        G_SourceNo: Code[20];
        G_SourceLineNo: Integer;
        G_SourceSubLineNo: Integer;
        G_CalledFromWhseWkshLine: Boolean;
        G_TempWhseItemTrackingLine: Record "Whse. Item Tracking Line" temporary;

    //Step1 +++++++++++++++++++++++++++++++++++++++++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnAfterCreateTempLineCheckReservation', '', false, false)]
    local procedure OnAfterCreateTempLineCheckReservation(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer; SourceSubLineNo: Integer)
    begin
        Clear(G_SourceType);
        Clear(G_SourceSubType);
        Clear(G_SourceNo);
        Clear(G_SourceLineNo);
        Clear(G_SourceSubLineNo);
        G_SourceType := SourceType;
        G_SourceSubType := SourceSubType;
        G_SourceNo := SourceNo;
        G_SourceLineNo := SourceLineNo;
        G_SourceSubLineNo := SourceSubLineNo;
    end;
    // +++++++++++++++++++++++++++ AND ++++++++++++++++++++++++

    //With Lot "Lot warehouse" on Item Tracking COde++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeCreateTempItemTrkgLines', '', false, false)]
    local procedure OnBeforeCreateTempItemTrkgLines(WhseShptLine: Record "Warehouse Shipment Line"; Location: Record Location; ItemNo: Code[20]; VariantCode: Code[10]; HasExpiryDate: Boolean; var TotalQtytoPickBase: Decimal; WhseWkshLine: Record "Whse. Worksheet Line")
    begin
        Clear(G_SourceDocument);
        Clear(G_CalledFromWhseWkshLine);
        G_SourceDocument := WhseShptLine."Source Document";
        G_CalledFromWhseWkshLine := not WhseWkshLine.IsEmpty;
    end;

    //
    [EventSubscriber(ObjectType::Report, Report::"Whse.-Shipment - Create Pick", 'OnAfterGetRecordWarehouseShipmentLineOnBeforeCreatePickTempLine', '', false, false)]
    local procedure OnAfterGetRecordWarehouseShipmentLineOnBeforeCreatePickTempLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    begin
        Clear(G_SourceDocument);
        G_SourceDocument := WarehouseShipmentLine."Source Document";
    end;

    //Step1 +++++++++++++++++++++++++++++++++++++++++


    //Step2++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Item Tracking FEFO", 'OnAfterCreateEntrySummaryFEFO', '', false, false)]
    local procedure OnAfterCreateEntrySummaryFEFO(var TempEntrySummary: Record "Entry Summary" temporary)
    var
        L_TransferLine: Record "Transfer Line";
        L_SalesLine: Record "Sales Line";
        L_BinCode: Code[20];
        L_BinContent: Record "Bin Content";
        L_ItemNo: Code[20];
        L_LocationCode: Code[20];
    begin
        Clear(L_BinCode);
        Clear(L_LocationCode);
        Clear(L_ItemNo);
        case G_SourceDocument of
            G_SourceDocument::"Sales Order":
                begin
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SetRange("Document No.", G_SourceNo);
                    // L_SalesLine.SetRange("Line No.", G_SourceLineNo);
                    // if L_SalesLine.FindFirst() then begin
                    //     if L_SalesLine."Bin Code" <> '' then begin
                    //         L_BinCode := L_SalesLine."Bin Code";
                    //         L_ItemNo := L_SalesLine."No.";
                    //         L_LocationCode := L_SalesLine."Location Code";
                    //     end else
                    //         L_SalesLine.TestField("Bin Code");
                    // end;

                    // TempEntrySummary.Reset();
                    // if TempEntrySummary.FindSet() then begin
                    //     repeat
                    //     // L_BinContent.Reset();
                    //     // L_BinContent.SetRange("Item No.",);

                    //     until TempEntrySummary.Next() = 0;
                    // end;

                end;
            G_SourceDocument::"Outbound Transfer":
                begin
                    L_TransferLine.Reset();
                    L_TransferLine.SetRange("Document No.", G_SourceNo);
                    L_TransferLine.SetRange("Line No.", G_SourceLineNo);
                    if L_TransferLine.FindFirst() then begin
                        if L_TransferLine."Transfer-from Bin Code" <> '' then begin
                            L_BinCode := L_TransferLine."Transfer-from Bin Code";
                            L_ItemNo := L_TransferLine."Item No.";
                            L_LocationCode := L_TransferLine."Transfer-from Code";
                        end else
                            L_TransferLine.TestField("Transfer-from Bin Code");

                    end;

                    TempEntrySummary.Reset();
                    if TempEntrySummary.FindSet() then begin
                        repeat
                            L_BinContent.Reset();
                            L_BinContent.SetRange("Item No.", L_ItemNo);
                            L_BinContent.SetRange("Bin Code", L_BinCode);
                            L_BinContent.SetRange("Lot No. Filter", TempEntrySummary."Lot No.");
                            L_BinContent.SetRange("Location Code", L_LocationCode);
                            if L_BinContent.FindFirst() then begin
                                if L_BinContent.CalcQtyAvailToTakeUOM() = 0 then begin
                                    TempEntrySummary.Delete();
                                end;
                            end;
                        until TempEntrySummary.Next() = 0;
                    end;
                end;
        end;
    end;


    //Step2++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeRunFindBWPickBinLoop', '', false, false)]
    local procedure OnBeforeRunFindBWPickBinLoop(var TempWhseItemTrackingLine: Record "Whse. Item Tracking Line" temporary)
    begin
        Clear(G_TempWhseItemTrackingLine);
        G_TempWhseItemTrackingLine.DeleteAll();
        G_TempWhseItemTrackingLine := TempWhseItemTrackingLine;
    end;

    //Step3++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnFindBWPickBinOnBeforeFromBinContentFindSet', '', false, false)]
    local procedure OnFindBWPickBinOnBeforeFromBinContentFindSet(var FromBinContent: Record "Bin Content")
    var
        L_TransferLine: Record "Transfer Line";
        L_SalesLine: Record "Sales Line";
    begin
        case G_SourceDocument of
            G_SourceDocument::"Sales Order":
                begin
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SetRange("Document No.", G_SourceNo);
                    // L_SalesLine.SetRange("Line No.", G_SourceLineNo);
                    // if L_SalesLine.FindFirst() then begin
                    //     if L_SalesLine."Bin Code" <> '' then
                    //         FromBinContent.SetRange("Bin Code", L_SalesLine."Bin Code");
                    //     // else
                    //     //     L_SalesLine.TestField("Bin Code");

                    //     if G_TempWhseItemTrackingLine."Lot No." <> '' then
                    //         FromBinContent.SetFilter("Lot No. Filter", G_TempWhseItemTrackingLine."Lot No.");

                    //     if G_TempWhseItemTrackingLine."Serial No." <> '' then
                    //         FromBinContent.SetFilter("Serial No. Filter", G_TempWhseItemTrackingLine."Serial No.");

                    // end;


                end;
            G_SourceDocument::"Outbound Transfer":
                begin
                    L_TransferLine.Reset();
                    L_TransferLine.SetRange("Document No.", G_SourceNo);
                    L_TransferLine.SetRange("Line No.", G_SourceLineNo);
                    if L_TransferLine.FindFirst() then begin
                        if L_TransferLine."Transfer-from Bin Code" <> '' then
                            FromBinContent.SetRange("Bin Code", L_TransferLine."Transfer-from Bin Code");
                        // else
                        //     L_TransferLine.TestField("Transfer-from Bin Code");

                        if G_TempWhseItemTrackingLine."Lot No." <> '' then
                            FromBinContent.SetFilter("Lot No. Filter", G_TempWhseItemTrackingLine."Lot No.");

                        if G_TempWhseItemTrackingLine."Serial No." <> '' then
                            FromBinContent.SetFilter("Serial No. Filter", G_TempWhseItemTrackingLine."Serial No.");

                    end;
                end;
        end;

    end;





    //Inve Pick Based on Selected Bin code on Transfer Line++

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnCreatePickOrMoveLineOnAfterFindTakeQtyForBinCodeSourceLine', '', false, false)]
    local procedure OnCreatePickOrMoveLineOnAfterFindTakeQtyForBinCodeSourceLine(WarehouseActivityHeader: Record "Warehouse Activity Header"; var RemQtyToPickBase: Decimal; var NewWarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        if (NewWarehouseActivityLine."Source Type" = 5741) AND (NewWarehouseActivityLine."Source Subtype" = 0) AND (NewWarehouseActivityLine."Source Document" = NewWarehouseActivityLine."Source Document"::"Outbound Transfer") then
            RemQtyToPickBase := 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnBeforeReleaseTransferDoc', '', false, false)]
    local procedure OnBeforeReleaseTransferDoc(var TransferHeader: Record "Transfer Header")
    var
        L_TransferLine: Record "Transfer Line";
    begin
        L_TransferLine.Reset();
        L_TransferLine.SetRange("Document No.", TransferHeader."No.");
        L_TransferLine.SetRange("Derived From Line No.", 0);
        L_TransferLine.SetRange("Transfer-from Bin Code", '');
        if L_TransferLine.FindFirst() then
            L_TransferLine.TestField("Transfer-from Bin Code");
    end;
}