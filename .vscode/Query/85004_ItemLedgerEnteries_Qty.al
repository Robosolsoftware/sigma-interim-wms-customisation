query 85004 "Item Ledger Enteries-Qty"
{


    elements
    {
        dataitem(DataItemName; "Item Ledger Entry")
        {
            column(Item_No_; "Item No.")
            {

            }
            column(Variant_Code; "Variant Code")
            {

            }
            // column(Location_Code; "Location Code")
            // {

            // }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }


        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}