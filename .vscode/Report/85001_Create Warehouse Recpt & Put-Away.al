report 85001 "Create Whs. Recpt & Put-Away"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Create Warehouse Receipt & Invt. Put-Away';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            //DataItemTableView = where(Status = const(Released));
            trigger OnAfterGetRecord()
            var
                GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                L_Location: Record Location;
                PartiallyReceived: Boolean;
                L_PurchaseLine: Record "Purchase Line";
            begin
                //code to manage partial receive
                Clear(PartiallyReceived);
                L_PurchaseLine.Reset();
                L_PurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
                L_PurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                L_PurchaseLine.SetRange(Type, L_PurchaseLine.Type::Item);
                if L_PurchaseLine.FindSet() then begin
                    L_PurchaseLine.CalcSums("Quantity Received", Quantity);
                    if (L_PurchaseLine."Quantity Received" > 0) AND (L_PurchaseLine."Quantity Received" < L_PurchaseLine.Quantity) then begin
                        PartiallyReceived := true;
                        CurrReport.Skip();
                    end;
                end;
                // --
                if L_Location.Get("Purchase Header"."Location Code") then begin
                    if L_Location."Require Receive" = true then begin
                        "Create Whs. Recpt & Put-Away".SkiErrorMessage(true);
                        GetSourceDocInbound.CreateFromPurchOrderHideDialog("Purchase Header");
                    end else begin
                        if L_Location."Require Put-away" = true then begin
                            Custom_CreateInvtPutAwayPick("Purchase Header");
                        end;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                "Purchase Header".SetRange(Status, G_Status);
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(G_Status; G_Status)
                    {
                        ApplicationArea = All;
                        Caption = 'Status';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            G_Status := G_Status::Released;
        end;
    }


    procedure Custom_CreateInvtPutAwayPick(RecPurchHdrP: Record "Purchase Header")
    var
        WhseRequest: Record "Warehouse Request";
        PUTRE: Report "Create Invt Put-away/Pick/Mvmt";
    begin
        Clear(PUTRE);
        WhseRequest.Reset();
        WhseRequest.SetCurrentKey("Source Document", "Source No.");
        case RecPurchHdrP."Document Type" of
            RecPurchHdrP."Document Type"::Order:
                WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Purchase Order");
            RecPurchHdrP."Document Type"::"Return Order":
                WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Purchase Return Order");
        end;
        WhseRequest.SetRange("Source No.", RecPurchHdrP."No.");
        PUTRE.InitializeRequest(true, false, false, false, false);
        PUTRE.SetTableView(WhseRequest);
        PUTRE.UseRequestPage(false);
        PUTRE.SuppressMessages(true);
        PUTRE.Run();
        //PUTRE.SuppressMessages(false);
        //REPORT.RunModal(REPORT::"Create Invt Put-away/Pick/Mvmt", false, false, WhseRequest);
    end;


    var
        myInt: Integer;
        G_Status: Enum "Purchase Document Status";
        "Create Whs. Recpt & Put-Away": Codeunit "Create Whs. Recpt & Put-Away";

}


