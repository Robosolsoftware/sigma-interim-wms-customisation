page 85016 SipperPalletList
{
    PageType = List;
    Caption = 'Shipper/Pallet Data List';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Shipper/Pallet Data";

    layout
    {
        area(Content)
        {
            repeater(Group)
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
                field("Variant Mandatory"; Rec."Variant Mandatory")
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
            action(SyncItemsAndVariants)
            {
                Caption = 'Sync Item Variants';
                Image = Refresh;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SyncHandler: Codeunit "ItemVariantSyncHandler";
                begin
                    SyncHandler.Sync();
                    Message('Item Variant Sync completed.');
                end;
            }
        }
    }

    var
        myInt: Integer;
}