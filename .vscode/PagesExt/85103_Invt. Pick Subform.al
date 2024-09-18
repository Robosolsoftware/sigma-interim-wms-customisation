pageextension 85103 "SC Invt. Pick Subform" extends "Invt. Pick Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Unable to Pick"; Rec."Unable to Pick")
            {
                ApplicationArea = All;
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
        te: page "Vendor Ledger Entries";
}