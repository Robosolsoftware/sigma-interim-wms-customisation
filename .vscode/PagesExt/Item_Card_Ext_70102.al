pageextension 70102 "Item Card Extend" extends "Item Card"
{
    layout
    {

        addlast(Item)
        {
            field("Min Sell Price"; Rec."Min Sell Price")
            {
                ApplicationArea = All;
            }
        }

        addafter("Reverse Charge Applies")
        {

            field("Unit List Price"; Rec."Unit List Price")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {

            field("Pack Size"; rec."Pack Size")
            {
                ApplicationArea = all;
            }
            field(Brand; rec.Brand)
            {
                ApplicationArea = all;
            }
        }

        addafter(Item)
        {
            group("Item Details")
            {

                field("Pallet Quantity"; Rec."Pallet Quantity")
                {
                    ApplicationArea = all;
                }
            }

        }

        addfirst(factboxes)
        {

            part("Lot-Number-by-Item"; "Lot-Number-by-Item")
            {
                SubPageLink = "Item No." = field("No.");
                ApplicationArea = all;
            }

        }
        addafter(Inventory)
        {
            field("Net Inventory"; Rec."Net Inventory")
            {
                ApplicationArea = all;
            }
        }
    }


    actions
    {

    }





    var
        myInt: Integer;

}