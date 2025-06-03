pageextension 85083 PostedTransfershipment extends 5744
{
    layout
    {
        addafter(Quantity)
        {
            field("Orignial Transfer Order Qty"; Rec."Orignial Transfer Order Qty")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pack Size"; rec."Pack Size")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Brand; rec.Brand)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Warehouse Class Code"; Rec."Warehouse Class Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}
