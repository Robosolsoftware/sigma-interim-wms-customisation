pageextension 70117 TransferOrderSubformExt extends "Transfer Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
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
        modify(Quantity)
        {
            trigger OnAfterValidate()


            var
                LotNosByBinCode: Query "LotNumber WarehouseEntry New";
                transferorderheader: Record "Transfer Header";
                qty: Decimal;
                BinContent: Record "Bin Content";
                bin: Record Bin;

            begin
                //old code commented++
                // Clear(qty);
                // transferorderheader.Reset();
                // transferorderheader.SetRange("No.", rec."Document No.");
                // if transferorderheader.FindFirst() then begin
                //     Clear(LotNosByBinCode);
                //     LotNosByBinCode.SETRANGE(Item_No, Rec."Item No.");
                //     IF REC."Transfer-from Bin Code" <> '' THEN
                //         LotNosByBinCode.SetRange(Bin_Code, rec."Transfer-from Bin Code");
                //     IF REC."Transfer-from Code" <> '' THEN
                //         LotNosByBinCode.SetRange(Location_Code, transferorderheader."Transfer-from Code");

                //     LotNosByBinCode.Open();
                //     while LotNosByBinCode.Read() do begin
                //         qty += LotNosByBinCode.Sum_Quantity;
                //     END;
                //old code commented--

                Clear(qty);
                if Rec.Quantity > 0 then begin
                    transferorderheader.Reset();
                    transferorderheader.SetRange("No.", rec."Document No.");
                    if transferorderheader.FindFirst() then begin
                        BinContent.Reset();
                        BinContent.SETRANGE("Item No.", Rec."Item No.");
                        IF REC."Transfer-from Bin Code" <> '' THEN
                            BinContent.SetRange("Bin Code", rec."Transfer-from Bin Code");
                        //IF REC."Transfer-from Code" <> '' THEN
                        BinContent.SetRange("Location Code", transferorderheader."Transfer-from Code");


                        if BinContent.FindSet() then begin
                            repeat
                                bin.Reset();
                                bin.SetRange("Location Code", transferorderheader."Transfer-from Code");
                                bin.SetRange(Code, BinContent."Bin Code");
                                bin.SetRange("Exclude from Fact box", false);
                                if bin.FindFirst() then
                                    qty += BinContent.CalcQtyAvailToTakeUOM();
                            until BinContent.Next() = 0
                        end;
                    end;
                    if qty < rec.Quantity then begin
                        Error('The available inventory is lower than the entered quantity at this location.');
                    end;
                end;
            end;
            //end;










        }

    }


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
