query 85007 TOSQuery
{



    elements
    {
        dataitem(Sales_Shipment_Line; "Sales Shipment Line")

        {
            DataItemTableFilter = "Order No." = filter(<> '');

            column(Order_No_; "Order No.")
            {

            }
            column(Order_Line_No_; "Order Line No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }

        }
    }
    trigger OnBeforeOpen()
    var
        myInt: Integer;
    begin
        CurrQuery.SetRange(CurrQuery.Posting_Date, WorkDate());
    end;

}