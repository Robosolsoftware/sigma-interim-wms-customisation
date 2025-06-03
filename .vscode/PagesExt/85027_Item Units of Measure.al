pageextension 85027 "SC Item Units of Measure" extends "Item Units of Measure"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Outer Qty."; Rec."Outer Qty.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Shipper Qty."; Rec."Shipper Qty.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Pallet Qty."; Rec."Pallet Qty.")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item.Status = L_Item.Status::Released then
                CurrPage.Editable(false);
        end;
    end;

    trigger OnAfterGetRecord()
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item.Status = L_Item.Status::Released then
                CurrPage.Editable(false);
        end;

    end;
}