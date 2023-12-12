pageextension 70102 "Item Card Extend" extends "Item Card"
{
    layout
    {
        addafter("Unit Price")
        {
            field(RRP; Rec.RRP)
            {
                ApplicationArea = All;
            }
        }
        modify("Item Category Code")
        {
            Caption = 'Sub-Child Category';
        }

        addbefore("Item Category Code")
        {
            field("Parent Category"; Rec."Parent Category")
            {
                ApplicationArea = All;
            }
            field("Child Category"; Rec."Child Category")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

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
        // modify(VariantMandatoryDefaultYes)
        // {
        //     trigger OnAfterValidate()
        //     var
        //         myInt: Integer;
        //     begin
        //         Clear(ItemVarVisible);
        //         if Rec."Variant Mandatory if Exists" = Rec."Variant Mandatory if Exists"::No then
        //             ItemVarVisible := false
        //         else
        //             ItemVarVisible := true;
        //     end;
        // }
    }


    // actions
    // {
    //     modify("Va&riants")
    //     {
    //         Enabled = ItemVarVisible;
    //     }
    // }


    // trigger OnOpenPage()
    // begin
    //     Clear(ItemVarVisible);
    //     if Rec."Variant Mandatory if Exists" = Rec."Variant Mandatory if Exists"::No then
    //         ItemVarVisible := false
    //     else
    //         ItemVarVisible := true;
    // end;

    // trigger OnAfterGetRecord()
    // begin
    //     Clear(ItemVarVisible);
    //     if Rec."Variant Mandatory if Exists" = Rec."Variant Mandatory if Exists"::No then
    //         ItemVarVisible := false
    //     else
    //         ItemVarVisible := true;
    // end;





    var
        myInt: Integer;
        ItemVarVisible: Boolean;

}