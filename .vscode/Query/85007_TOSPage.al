query 85007 TOSPage
{

    elements
    {
        dataitem(Sales_Shipment_Line; "Sales Shipment Line")

        {

            column(Order_No_; "Order No.")
            {

            }
            column(Order_Line_No_; "Order Line No.")
            {

            }

            column(Quantity; Quantity)
            {
                Method = Sum;
            }

        }
    }

}