pageextension 85094 "SC Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = All;
            }
            field("Bureau Number"; Rec."Bureau Number")
            {
                ApplicationArea = All;
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