tableextension 85057 "SC Warehouse Activity Line" extends "Warehouse Activity Line"
{
    fields
    {
        // Add changes to table fields here
        field(85057; "Unable to Pick"; Text[100])
        {

        }
        field(85032; "Shipment Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Shipment Date" where("Document Type" = const("Order"), "No." = field("Source No.")));
            Editable = false;
        }
        field(85013; "Saleable Location"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Saleable Location" where(Code = field("Location Code")));
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