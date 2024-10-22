tableextension 85045 "SI Warehouse Activity Header" extends "Warehouse Activity Header"
{
    fields
    {
        // Add changes to table fields here
        field(85000; "Work Description"; Text[2042])
        {
            Caption = 'Work Description';
        }
        field(85001; "Allowed to Pick"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Activity Line" where("Unable to Pick" = const(''), "No." = field("No."), "Activity Type" = field(Type)));
            //This field used to filter on tasklet pick Screen++
        }
        field(85002; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Shipping Agent Code" where("Document Type" = const(Order), "No." = field("Source No.")));
            Editable = false;
        }
        field(85003; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Shipping Agent Service Code" where("Document Type" = const(Order), "No." = field("Source No.")));
            Editable = false;

        }
        field(85004; "Weekend Shipping Agent Code"; Text[30])
        {
            Caption = 'Weekend Shipping Agent Code';
            TableRelation = "Shipping Agent";
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Weekend Shipping Agent Code" where("Document Type" = const(Order), "No." = field("Source No.")));

        }
        field(85005; "Weekend Ship. Agnt. Serv. Code"; Code[30])
        {
            Caption = 'Weekend Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Weekend Shipping Agent Code"));
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Weekend Ship. Agnt. Serv. Code" where("Document Type" = const(Order), "No." = field("Source No.")));
        }
        field(85006; "Whs. Class Code type"; Code[20])
        {
            Editable = false;
        }
        field(85007; "Contains TOS"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Warehouse Activity Line" where("Activity Type" = field(Type), "No." = field("No."), "Unable to Pick" = filter(<> '')));

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
        tes: Record "Sales Header";
}