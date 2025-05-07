pageextension 85111 "SC Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        modify("Return Reason Code")
        {
            Visible = true;
        }
        addafter("Return Reason Code")
        {
            field("Reason Code"; GetReasonCode(Rec))
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(CreateManualValueEntry)
            {
                ApplicationArea = All;
                Caption = 'Manually Create Value Entry';
                Image = CreateOrder;
                trigger OnAction()
                var
                    ILE: Record "Item Ledger Entry";
                    ValueEntry: Record "Value Entry";
                    LastEntryNo: Integer;
                    ManualCost: Decimal;
                    vendor: Record Vendor;
                    Item: Record Item;
                    CreateVE: Codeunit CreateValueEntry;
                begin
                    ILE.Copy(Rec);
                    CreateVE.CreatValueEntry(ILE);
                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure GetReasonCode(_ItemLedgerEntry: Record "Item Ledger Entry"): Code[20]
    var
        L_WarehouseEntry: Record "Warehouse Entry";
    begin
        L_WarehouseEntry.Reset();
        L_WarehouseEntry.SetRange("Registering Date", _ItemLedgerEntry."Posting Date");
        L_WarehouseEntry.SetRange("Reference No.", _ItemLedgerEntry."Document No.");
        if L_WarehouseEntry.FindFirst() then
            exit(L_WarehouseEntry."Reason Code");
    end;

}