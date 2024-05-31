query 85003 "TransferOrderPowerBI"
{

    elements
    {
        dataitem(Transfer_Header; "Transfer Header")
        {
            column("TranferOrderNo"; "No.")
            {
            }
            column(TransferFromCode; "Transfer-from Code")
            {
            }
            column(TransferToCode; "Transfer-to Code")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }

            dataitem(Transfer_Line; "Transfer Line")
            {
                DataItemLink = "Document No." = Transfer_Header."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Derived From Line No." = filter(0);
                column(ItemNo; "Item No.")
                {
                }
                column(ItemDescription; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                dataitem(User; User)
                {
                    DataItemLink = "User Security ID" = Transfer_Header.SystemCreatedBy;
                    SqlJoinType = InnerJoin;
                    column(SystemCreatedBy; "Full Name")
                    {
                    }
                }

            }

        }

    }
}
