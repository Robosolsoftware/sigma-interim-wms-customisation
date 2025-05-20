pageextension 85040 "SC Item Variants" extends "Item Variants"
{
    layout
    {
        // Add changes to page layout here
        modify("Item No.")
        {
            Editable = L_CurrFieldEditable;
        }
        modify(Code)
        {
            Editable = L_CurrFieldEditable;
        }
        modify(Description)
        {
            Editable = L_CurrFieldEditable;
        }
        modify("Description 2")
        {
            Editable = L_CurrFieldEditable;
        }
        modify(Blocked)
        {
            Editable = L_CurrFieldEditable;

        }
        modify("Sales Blocked")
        {
            Editable = L_CurrFieldEditable;
        }
        modify("Service Blocked")
        {
            Editable = L_CurrFieldEditable;
        }
        modify("Purchasing Blocked")
        {
            Editable = L_CurrFieldEditable;
        }
        addafter("Purchasing Blocked")
        {
            field("Variant Approval"; Rec."Variant Approval")
            {
                ApplicationArea = All;
                //Visible = false;
                trigger OnValidate()
                var
                    L_UserSetup: Record "User Setup";
                begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Variant Approval", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit');

                    CurrPage.Update();
                end;

            }
            field("Outer Qty."; Rec."Outer Qty.")
            {
                ApplicationArea = All;
            }
            field("Shipper Qty."; Rec."Shipper Qty.")
            {
                ApplicationArea = All;
            }
            field("Pallet Qty."; Rec."Pallet Qty.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        L_CurrpageEdit: Boolean;
        L_CurrFieldEditable: Boolean;


    trigger OnOpenPage()
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item."Variant Mandatory if Exists" = L_Item."Variant Mandatory if Exists"::No then
                CurrPage.Editable(false);


            Clear(L_CurrFieldEditable);
            if L_Item.Status = L_Item.Status::Released then
                L_CurrFieldEditable := false
            else
                L_CurrFieldEditable := true;
        end;
    end;

    trigger OnAfterGetRecord()
    var
        L_Item: Record Item;
    begin
        L_Item.Reset();
        L_Item.SetRange("No.", Rec."Item No.");
        if L_Item.FindFirst() then begin
            if L_Item."Variant Mandatory if Exists" = L_Item."Variant Mandatory if Exists"::No then
                CurrPage.Editable(false);

            Clear(L_CurrFieldEditable);
            if L_Item.Status = L_Item.Status::Released then
                L_CurrFieldEditable := false
            else
                L_CurrFieldEditable := true;
        end;

    end;
}