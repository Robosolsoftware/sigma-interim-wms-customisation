query 85001 PostedTransferReceiptsPowerBI
{

    elements
    {
        dataitem(Transfer_Receipt_Header; "Transfer Receipt Header")
        {
            column("PostedTransferReceiptNo"; "No.")
            {
            }
            column(TransferOrderNo; "Transfer Order No.")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            dataitem(Transfer_Receipt_Line; "Transfer Receipt Line")
            {
                DataItemLink = "Document No." = Transfer_Receipt_Header."No.";
                SqlJoinType = InnerJoin;
                column(ItemNo; "Item No.")
                {
                }
                column(ItemDescription; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Orignial_Transfer_Order_Qty; "Orignial Transfer Order Qty")
                {

                }
                dataitem(User; User)
                {
                    DataItemLink = "User Security ID" = Transfer_Receipt_Header.SystemCreatedBy;
                    SqlJoinType = InnerJoin;
                    column(SystemCreatedBy; "Full Name")
                    {
                    }
                }

            }
        }

    }
}