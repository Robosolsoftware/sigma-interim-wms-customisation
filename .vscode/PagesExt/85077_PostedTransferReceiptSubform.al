pageextension 85077 PostedTransferReceiptSubExt extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Orignial Transfer Order Qty"; Rec."Orignial Transfer Order Qty")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pack Size"; rec."Pack Size")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Brand; rec.Brand)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Warehouse Class Code"; Rec."Warehouse Class Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                L_Item: Record Item;
            begin
                L_Item.Reset();
                L_Item.SetRange("No.", rec."Item No.");
                if L_Item.FindFirst() then begin
                    rec."Pack Size" := L_Item."Pack Size";
                    rec.Brand := L_Item.Brand;
                    rec.Modify(true);
                end;
            end;
        }
        // modify(Quantity)
        // {
        //     trigger OnAfterValidate()


        //     var
        //         LotNosByBinCode: Query "LotNumber WarehouseEntry New";
        //         transferorderheader: Record "Transfer Header";
        //         qty: Decimal;
        //     begin

        //         Clear(qty);
        //         transferorderheader.Reset();
        //         transferorderheader.SetRange("No.", rec."Document No.");
        //         if transferorderheader.FindFirst() then begin
        //             Clear(LotNosByBinCode);
        //             LotNosByBinCode.SETRANGE(Item_No, Rec."Item No.");
        //             IF REC."Transfer-from Bin Code" <> '' THEN
        //                 LotNosByBinCode.SetRange(Bin_Code, rec."Transfer-from Bin Code");
        //             IF REC."Transfer-from Code" <> '' THEN
        //                 LotNosByBinCode.SetRange(Location_Code, transferorderheader."Transfer-from Code");

        //             LotNosByBinCode.Open();
        //             while LotNosByBinCode.Read() do begin
        //                 qty += LotNosByBinCode.Sum_Quantity;
        //             END;


        //             if qty < rec.Quantity then begin
        //                 Error('The available inventory is lower than the entered quantity at this location.');
        //             end;
        //         end;
        //     end;

        // }

    }




    var
        myInt: Integer;
}
