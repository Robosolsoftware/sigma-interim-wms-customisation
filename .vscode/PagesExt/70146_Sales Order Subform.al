pageextension 70146 "SC Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                L_Customer: Record Customer;
                L_Location: Record Location;
            begin
                if Rec."Location Code" <> '' then begin
                    L_Customer.Reset();
                    L_Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if L_Customer.FindFirst() then begin
                        if L_Customer."KNAPP Customer" <> true then begin
                            L_Location.Reset();
                            L_Location.SetRange(Code, Rec."Location Code");
                            if L_Location.FindFirst() then begin
                                if L_Location."KNAPP Location" = true then
                                    Error('You can not enter KNAPP location');
                            end;
                        end;
                    end;
                end;


            end;
        }
        addafter(Description)
        {
            field("KNAPP Item"; Rec."KNAPP Item")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter(Quantity)
        {
            field("Shipper Qty."; Rec."Shipper Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Outer Qty."; Rec."Outer Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pallet Qty."; Rec."Pallet Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Inventory; Rec.Inventory)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Total Inventory';
            }
            field("Variant Code mandatory"; Rec."Variant Code mandatory")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(Allocated; Rec.Allocated)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Total requested quantity on Sales order';
            }
            field("Free Quantity"; G_FreeQuantity)
            {
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                ToolTip = 'Free Quantity = Inventory - Allocated';
            }
            field("Min Sell Price"; Rec."Min Sell Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Last Price"; Rec."Last Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Parent Category"; Rec."Parent Category")
            {
                ApplicationArea = All;
            }
        }
        // modify("Unit Price")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         UserSetup: Record "User Setup";
        //     begin
        //         UserSetup.Reset();
        //         if UserSetup.Get(UserId) then begin
        //             if UserSetup."Min Sell Price" then begin
        //                 if Rec."Unit Price" < Rec."Min Sell Price" then begin
        //                     Error('Unit price should not be less than Min Sell Price');
        //                 end;
        //                 if Rec."Min Sell Price" = 0 then begin
        //                     DisUnitPrice := xRec."Unit Price" * 0.1;
        //                     if Rec."Unit Price" < xRec."Unit Price" - DisUnitPrice then
        //                         Error('Discount should be only 10% of original Unit Price');
        //                 end;
        //             end;
        //         end;
        //     end;
        // }
    }

    var
        G_FreeQuantity: Decimal;
        DisUnitPrice: Decimal;

    trigger OnAfterGetRecord()
    begin
        Clear(G_FreeQuantity);
        Rec.CalcFields(Inventory, Allocated);
        G_FreeQuantity := Rec.Inventory - Rec.Allocated;
    end;
}