query 70106 "Without LotNumber Whs Entry"
{

    elements
    {
        dataitem("QueryElement1000000000"; "Warehouse Entry")
        {
            //DataItemTableFilter = "Lot No." = FILTER(<> '');
            column(Item_No; "Item No.")
            {
            }
            column(Variant_Code; "Variant Code")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Zone_Code; "Zone Code")
            {
            }
            column(Bin_Code; "Bin Code")
            {
            }
            // column(Lot_No; "Lot No.")
            // {
            // }

            column(Sum_Quantity; "Qty. (Base)")
            {
                Method = Sum;
            }
        }

    }
}

