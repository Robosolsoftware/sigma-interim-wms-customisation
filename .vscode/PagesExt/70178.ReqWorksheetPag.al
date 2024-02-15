pageextension 70178 "Req. Worksheet" extends "Req. Worksheet"
{
    layout
    {
        addafter("Location Code")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order No. field.';
                Editable = false;
            }
        }
        modify("Sell-to Customer No.")
        {
            Visible = true;
        }
        moveafter("Sales Order No."; "Sell-to Customer No.")
        addafter("Sell-to Customer No.")
        {
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter(CarryOutActionMessage)
        {
            action("Create Combine PO")
            {
                ApplicationArea = Planning;
                Caption = 'Create Combine PO';
                Ellipsis = true;
                Image = Purchase;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    RequisitionLine: Record "Requisition Line";
                begin
                    if not Confirm('Do you want to proceed?', false) then
                        Error('');

                    Clear(G_VendorNo);
                    RequisitionLine.Reset();
                    RequisitionLine.SetRange("Accept Action Message", true);
                    RequisitionLine.SetFilter("Vendor No.", '<>%1', '');
                    RequisitionLine.SetRange("Worksheet Template Name", Rec."Worksheet Template Name");
                    RequisitionLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    RequisitionLine.SetFilter("Action Message", '%1|%2|%3', RequisitionLine."Action Message"::New, RequisitionLine."Action Message"::"Change Qty.", RequisitionLine."Action Message"::"Resched. & Chg. Qty.");
                    RequisitionLine.SetCurrentKey("Vendor No.");
                    RequisitionLine.Ascending(true);
                    if RequisitionLine.FindSet() then begin
                        repeat
                            CreateCombinePO(RequisitionLine);
                        until RequisitionLine.Next() = 0;

                        // if GetLastErrorText() = '' then
                        DeleteCancelLinesFromRequistionSheet(RequisitionLine);
                    end;
                    Message('Process Completed Successfully');
                end;
            }
        }
    }

    var
        G_VendorNo: Code[20];
        New_PurchaseHeader: Record "Purchase Header";


    local procedure CreateCombinePO(var RequisitionLine: Record "Requisition Line")
    var
        L_PurchaseHeader: Record "Purchase Header";
        L_PurchaseLine: Record "Purchase Line";
        TotalQuantity: Decimal;
        IsPurchaseLineFound: Boolean;
        PONumber: Code[20];
        SalesLine: Record "Sales Line";
    begin
        if G_VendorNo <> RequisitionLine."Vendor No." then begin
            //Create New PO Header++
            CreateNewPOHeader(RequisitionLine);

            G_VendorNo := RequisitionLine."Vendor No.";
        end;

        //Create Line++
        CreateNewPOLine(RequisitionLine, New_PurchaseHeader);
    end;

    local procedure CreateNewPOHeader(var RequisitionLine: Record "Requisition Line")
    var
        PurchasePaybleSetup: Record "Purchases & Payables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        L_Location: Record Location;
        L_Vendor: Record Vendor;
    begin
        PurchasePaybleSetup.Get();
        Clear(New_PurchaseHeader);
        New_PurchaseHeader.Reset();
        New_PurchaseHeader.Init();
        New_PurchaseHeader.Validate("Document Type", New_PurchaseHeader."Document Type"::Order);
        New_PurchaseHeader.Validate("No.", NoSeriesManagement.GetNextNo(PurchasePaybleSetup."Order Nos.", WorkDate(), true));
        New_PurchaseHeader.Validate("Buy-from Vendor No.", RequisitionLine."Vendor No.");
        New_PurchaseHeader.Validate("Document Date", WorkDate());
        New_PurchaseHeader.Validate("Order Date", WorkDate());
        // New_PurchaseHeader.Validate("Invoice Received Date", WorkDate());
        New_PurchaseHeader.Validate("Posting Date", WorkDate());
        //New_PurchaseHeader.Validate("VAT Reporting Date", WorkDate());

        L_Vendor.Reset();
        if L_Vendor.Get(RequisitionLine."Vendor No.") then begin
            New_PurchaseHeader.Validate("Payment Terms Code", L_Vendor."Payment Terms Code");
            New_PurchaseHeader.Validate("Lead Time Calculation", L_Vendor."Lead Time Calculation");
        end;
        if RequisitionLine."Location Code" <> '' then
            New_PurchaseHeader.Validate("Location Code", RequisitionLine."Location Code");
        New_PurchaseHeader.Insert(true);
    end;


    local procedure CreateNewPOLine(var RequisitionLine: Record "Requisition Line"; var P_PurchaseHeader: Record "Purchase Header")
    var
        L_PurchaseLine: Record "Purchase Line";
        L_ReservationEntry: Record "Reservation Entry";
    begin
        L_PurchaseLine.Reset();
        L_PurchaseLine.SetRange(Type, L_PurchaseLine.Type::Item);
        L_PurchaseLine.SetRange("Document Type", P_PurchaseHeader."Document Type");
        L_PurchaseLine.SetRange("Document No.", P_PurchaseHeader."No.");
        L_PurchaseLine.SetRange("No.", RequisitionLine."No.");
        if not L_PurchaseLine.FindFirst() then begin
            L_PurchaseLine.Init();
            L_PurchaseLine.Validate("Document Type", P_PurchaseHeader."Document Type");
            L_PurchaseLine.Validate("Document No.", P_PurchaseHeader."No.");
            L_PurchaseLine.Validate("Line No.", GetLastLineNo(P_PurchaseHeader));
            L_PurchaseLine.Validate(Type, L_PurchaseLine.Type::Item);
            L_PurchaseLine.Validate("No.", RequisitionLine."No.");
            L_PurchaseLine.Validate(Quantity, RequisitionLine.Quantity);
            L_PurchaseLine.Insert(true);
        end else begin
            L_PurchaseLine.Validate(Quantity, L_PurchaseLine.Quantity + RequisitionLine.Quantity);
            L_PurchaseLine.Modify();
        end;

        //Create Lot Details++
        L_ReservationEntry.Reset();
        L_ReservationEntry.SetRange("Item No.", RequisitionLine."No.");
        if RequisitionLine."Location Code" <> '' then
            L_ReservationEntry.SetRange("Location Code", RequisitionLine."Location Code");
        L_ReservationEntry.SetRange("Source Type", 246);
        L_ReservationEntry.SetRange("Source Subtype", 0);
        L_ReservationEntry.SetRange("Source ID", RequisitionLine."Worksheet Template Name");
        L_ReservationEntry.SetRange("Source Batch Name", RequisitionLine."Journal Batch Name");
        L_ReservationEntry.SetRange("Source Ref. No.", RequisitionLine."Line No.");
        if RequisitionLine."Variant Code" <> '' then
            L_ReservationEntry.SetRange("Variant Code", RequisitionLine."Variant Code");
        if L_ReservationEntry.FindSet() then begin
            repeat
                CreateReservationEntry(RequisitionLine, L_PurchaseLine, L_ReservationEntry);
            until L_ReservationEntry.Next() = 0;
        end;
    end;

    local procedure GetLastLineNo(_PurchaseHeader: Record "Purchase Header"): Integer
    var
        L_PurchaseLine: Record "Purchase Line";
    begin
        L_PurchaseLine.Reset();
        L_PurchaseLine.SetRange("Document Type", _PurchaseHeader."Document Type");
        L_PurchaseLine.SetRange("Document No.", _PurchaseHeader."No.");
        if L_PurchaseLine.FindLast() then begin
            exit(L_PurchaseLine."Line No." + 10000)
        end else
            exit(10000);
    end;

    local procedure CreateReservationEntry(var RequisitionLine: Record "Requisition Line"; var P_PurchaseLine: Record "Purchase Line"; P_ReservationEntry: Record "Reservation Entry")
    var
        Rec_ReservationEntry: Record "Reservation Entry";
        L_ReservationEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        EntryNo: Integer;
        TempReservationEntry1: Record "Reservation Entry";
        CreateReservEntry: Codeunit 99000830;
    begin
        //Find Reservation Entry for CreateReservEntryFor() function+++++++
        TempReservationEntry1.Reset();
        TempReservationEntry1."Source Type" := 39;
        TempReservationEntry1."Source Subtype" := 1;
        TempReservationEntry1."Source ID" := P_PurchaseLine."Document No.";
        TempReservationEntry1."Source Ref. No." := P_PurchaseLine."Line No.";
        TempReservationEntry1."Lot No." := P_ReservationEntry."Lot No.";
        TempReservationEntry1."Expiration Date" := P_ReservationEntry."Expiration Date";
        //Find Reservation Entry for CreateReservEntryFor() function--------  

        CreateReservEntry.CreateReservEntryFor(DATABASE::"Purchase Line", 1, P_PurchaseLine."Document No.", '', 0, P_PurchaseLine."Line No.", P_PurchaseLine."Qty. per Unit of Measure", P_ReservationEntry.Quantity, P_ReservationEntry.Quantity, TempReservationEntry1);
        CreateReservEntry.SetDates(0D, TempReservationEntry1."Expiration Date");
        CreateReservEntry.CreateEntry(P_PurchaseLine."No.", P_PurchaseLine."Variant Code", P_PurchaseLine."Location Code", '', P_PurchaseLine."Expected Receipt Date", 0D, 0, 3);
    end;


    local procedure DeleteCancelLinesFromRequistionSheet(_RequisitionLine: Record "Requisition Line")
    var
        RequisitionLine: Record "Requisition Line";
    begin
        Clear(RequisitionLine);
        RequisitionLine.Reset();
        RequisitionLine.SetRange("Accept Action Message", true);
        RequisitionLine.SetRange("Journal Batch Name", _RequisitionLine."Journal Batch Name");
        RequisitionLine.SetRange("Worksheet Template Name", _RequisitionLine."Worksheet Template Name");
        if RequisitionLine.FindSet() then begin
            RequisitionLine.DeleteAll(true);
        end;
    end;
}