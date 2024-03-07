pageextension 70102 "Item Card Extend" extends "Item Card"
{
    layout
    {
        modify(InventoryNonFoundation)
        {
            Caption = 'Total Physical';
            Visible = false;
        }
        addafter("Unit Price")
        {
            field(RRP; Rec.RRP)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
        }
        modify("Item Category Code")
        {
            Caption = 'Sub-Child Category';
            Editable = L_CurrPageEditable;
        }

        addbefore("Item Category Code")
        {
            field("Parent Category"; Rec."Parent Category")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
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
                Editable = L_CurrPageEditable;
                ToolTip = 'If Min Sell is 0, then system will not allow to change the unit price less than 10%';
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = all;
                Editable = L_EditableQUAApproved;
            }
            field("Top Category"; Rec."Top Category")
            {
                ApplicationArea = all;
                Editable = L_CurrPageEditable;
            }
        }

        addafter("Reverse Charge Applies")
        {

            field("Unit List Price"; Rec."Unit List Price")
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
        }
        addafter(Description)
        {

            field("Pack Size"; rec."Pack Size")
            {
                ApplicationArea = all;
                Editable = L_CurrPageEditable;
            }
            field(Brand; rec.Brand)
            {
                ApplicationArea = all;
                Editable = L_CurrPageEditable;
            }
            field(Storage; Rec.Storage)
            {
                ApplicationArea = All;
                Editable = L_CurrPageEditable;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                //Editable = L_CurrPageEditable;
                Editable = L_EditableStatus;

                trigger OnValidate()
                var
                    L_UserSetup: Record "User Setup";
                begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Edit Master Data", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit');

                    CurrPage.Update();
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
        // addafter(Inventory)
        // {
        //     field("Net Inventory"; Rec."Net Inventory")
        //     {
        //         ApplicationArea = all;
        //         //Editable = L_CurrPageEditable;
        //         Editable = false;
        //         ToolTip = 'Inventory - Sales Order';
        //     }
        //     field("Saleable Inventory"; Rec."Saleable Inventory")
        //     {
        //         ApplicationArea = all;
        //         //Editable = L_CurrPageEditable;
        //         Editable = false;
        //         ToolTip = 'HD House and Sigma House';
        //     }
        // }
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
        modify("No.")
        {
            Editable = L_CurrPageEditable;
        }
        modify(Description)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Description 2")
        {
            Editable = L_CurrPageEditable;
        }
        modify(Blocked)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Type)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Base Unit of Measure")
        {
            Editable = L_CurrPageEditable;
        }
        modify(GTIN)
        {
            Editable = L_CurrPageEditable;
        }
        modify(InventoryGrp)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Costs & Posting")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Prices & Sales")
        {
            Editable = L_CurrPageEditable;
        }
        modify(Replenishment)
        {
            Editable = L_CurrPageEditable;
        }
        modify(Planning)
        {
            Editable = L_CurrPageEditable;
        }
        modify(ItemTracking)
        {
            Editable = L_CurrPageEditable;
        }
        // modify(Warehouse)
        // {
        //     Editable = L_CurrPageEditable;
        // }
        modify(Inventory)
        {
            ToolTip = 'Inventory from all Locations';
            Editable = L_CurrPageEditable;
            Caption = 'Total Physical';
            Visible = false;
        }
        modify("Automatic Ext. Texts")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Common Item No.")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Purchasing Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify(VariantMandatoryDefaultNo)
        {
            Editable = L_CurrPageEditable;
        }
        modify(VariantMandatoryDefaultYes)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Application Wksh. User ID")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Inventory Value Zero")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Manufacturer Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Trans. Ord. Receipt (Qty.)")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Trans. Ord. Shipment (Qty.)")
        {
            Editable = L_CurrPageEditable;
        }
        //Warehouse group++
        modify("Warehouse Class Code")
        {
            Editable = L_EditableQUAApproved;
        }
        modify("Special Equipment Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Put-away Template Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Put-away Unit of Measure Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Phys Invt Counting Period Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Last Phys. Invt. Date")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Last Counting Period Update")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Next Counting Start Date")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Next Counting End Date")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Identifier Code")
        {
            Editable = L_CurrPageEditable;
        }
        modify("Use Cross-Docking")
        {
            Editable = L_CurrPageEditable;
        }
        //Warehouse group--
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
        L_EditableQUAApproved: Boolean;
        L_CurrPageEditable: Boolean;
        L_EditableStatus: Boolean;


    /*trigger OnOpenPage()
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
    end;*/

    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";

    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        Clear(L_EditableStatus);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            //L_EditableQUAApproved := true;
            L_EditableStatus := true;
        end else begin
            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Master Data" = true then begin
                    if Rec.Status = Rec.Status::Open then
                        L_CurrPageEditable := true
                    else
                        L_CurrPageEditable := false;
                end else
                    L_CurrPageEditable := false;
            end else
                L_CurrPageEditable := false;

            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Master Data" = true then
                    L_EditableStatus := true
                else
                    L_EditableStatus := false;
            end else
                L_EditableStatus := false;

        end;
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data QAU Approved" = true then
                L_EditableQUAApproved := true
            else
                L_EditableQUAApproved := false;
        end else
            L_EditableQUAApproved := false;
    end;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";

    begin
        Clear(L_CurrPageEditable);
        Clear(L_EditableQUAApproved);
        Clear(L_EditableStatus);
        if Rec.Status = Rec.Status::Open then begin
            L_CurrPageEditable := true;
            //L_EditableQUAApproved := true;
            L_EditableStatus := true;
        end else begin
            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Master Data" = true then begin
                    if Rec.Status = Rec.Status::Open then
                        L_CurrPageEditable := true
                    else
                        L_CurrPageEditable := false;
                end else
                    L_CurrPageEditable := false;
            end else
                L_CurrPageEditable := false;

            L_UserSetup.Reset();
            L_UserSetup.SetRange("User ID", UserId);
            if L_UserSetup.FindFirst() then begin
                if L_UserSetup."Edit Master Data" = true then
                    L_EditableStatus := true
                else
                    L_EditableStatus := false;
            end else
                L_EditableStatus := false;

        end;

        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data QAU Approved" = true then
                L_EditableQUAApproved := true
            else
                L_EditableQUAApproved := false;
        end else
            L_EditableQUAApproved := false;
    end;

}