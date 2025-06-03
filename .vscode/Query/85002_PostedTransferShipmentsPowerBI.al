query 85002 "PostedTransferShipmentsPowerBI"
{

    elements
    {
        dataitem(Transfer_Shipment_Header; "Transfer Shipment Header")
        {
            column("PostedTransferShipmentNo"; "No.")
            {
            }
            column(TransferOrderNo; "Transfer Order No.")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            dataitem(Transfer_Shipment_Line; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = Transfer_Shipment_Header."No.";
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
                    DataItemLink = "User Security ID" = Transfer_Shipment_Header.SystemCreatedBy;
                    SqlJoinType = InnerJoin;
                    column(SystemCreatedBy; "Full Name")
                    {
                    }
                }

            }
        }

    }
}