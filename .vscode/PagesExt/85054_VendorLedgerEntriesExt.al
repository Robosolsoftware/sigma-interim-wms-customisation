pageextension 85054 VendorLedgerEntriesEXT extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}