table 85007 "TOS Page Temp Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Order Line No."; Integer) { }
        field(2; "Order No."; Code[20]) { }
        field(3; "Sell-to Customer No."; Code[20]) { }
        field(4; "No."; Code[20]) { }
        field(5; Description; Text[100]) { }
        field(6; "Location Code"; Code[20]) { }
        field(7; Quantity; Decimal) { }

    }

    keys
    {
        key(PK; "Order No.", "Order Line No.") { Clustered = true; }
    }

}
