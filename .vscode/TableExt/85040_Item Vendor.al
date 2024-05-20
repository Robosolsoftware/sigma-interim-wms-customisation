tableextension 85040 "SC Item Vendor" extends "Item Vendor"
{
    fields
    {
        // Add changes to table fields here

        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                L_ItemVendor: Record "Item Vendor";
            begin
                if Rec."Item No." <> '' then begin
                    L_ItemVendor.Reset();
                    L_ItemVendor.SetRange("Vendor No.", Rec."Vendor No.");
                    L_ItemVendor.SetRange("Item No.", Rec."Item No.");
                    if L_ItemVendor.FindFirst() then
                        Error('The record in table Item Vendor already exists. Identification fields and values: Vendor No.= %1,Item No.= %2', Rec."Vendor No.", Rec."Item No.");
                end;
            end;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}