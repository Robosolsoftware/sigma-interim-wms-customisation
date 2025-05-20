page 85015 ShipperPalletDataCard

{
    PageType = Card;
    Caption = 'Shipper/Pallet Data';
    SourceTable = "Shipper/Pallet Data";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shipper Qty."; Rec."Shipper Qty.")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Pallet Qty."; Rec."Pallet Qty.")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Outer Qty."; Rec."Outer Qty.")
                {
                    ApplicationArea = all;
                    Editable = true;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}