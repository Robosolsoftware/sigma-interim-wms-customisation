tableextension 85044 "SC Warehouse Journal Line" extends "Warehouse Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(85000; "Custom Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
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