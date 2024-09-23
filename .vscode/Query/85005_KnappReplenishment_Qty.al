query 85005 "Item Ledger Enteries-Qty Knapp"
{


    elements
    {
        dataitem(DataItemName; "Item Ledger Entry")
        {
            DataItemTableFilter = "Location Code" = filter('KNAPP');

            column(Item_No_; "Item No.")
            {

            }
            column(Variant_Code; "Variant Code")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
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