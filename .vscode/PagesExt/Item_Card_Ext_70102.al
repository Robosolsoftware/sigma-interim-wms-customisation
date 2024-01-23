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
            field("KNAPP Item"; Rec."KNAPP Item")
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
            field(Storage; Rec.Storage)
            {
                ApplicationArea = All;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    L_UserSetup: Record "User Setup";
                begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Edit Master Data", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit')

                end;
            }
        }

        // addafter(Item)
        // {
        //     group("Item Details")
        //     {

        //         field("Pallet Quantity"; Rec."Pallet Quantity")
        //         {
        //             ApplicationArea = all;
        //         }
        //     }

        // }

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


    actions
    {
        modify(PrintLabel)
        {
            Visible = false;
        }
    }


    var
        myInt: Integer;
        ItemVarVisible: Boolean;


    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";
    begin
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        L_UserSetup.SetRange("Edit Master Data", true);
        if not L_UserSetup.FindFirst() then begin
            if Rec.Status <> Rec.Status::Open then
                CurrPage.Editable(false);
        end;
    end;

}