pageextension 85074 TransferOrderSubformExt extends "Transfer Order Subform"
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
            field("Transfer-from Bin Blocked"; Rec."Transfer-from Bin Blocked")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Transfer-from Bin Code" <> '' then
                    Rec.Validate("Transfer-from Bin Code", '');
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                transferorderheader: Record "Transfer Header";
                qty: Decimal;
                BinContent: Record "Bin Content";
                bin: Record Bin;

            begin
                Clear(qty);
                if Rec.Quantity > 0 then begin
                    transferorderheader.Reset();
                    transferorderheader.SetRange("No.", rec."Document No.");
                    if transferorderheader.FindFirst() then begin
                        BinContent.Reset();
                        BinContent.SETRANGE("Item No.", Rec."Item No.");
                        if Rec."Transfer-from Bin Code" <> '' then
                            BinContent.SetRange("Bin Code", rec."Transfer-from Bin Code");
                        BinContent.SetRange("Location Code", transferorderheader."Transfer-from Code");
                        if Rec."Variant Code" <> '' then
                            BinContent.SetRange("Variant Code", Rec."Variant Code");
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
        modify("Transfer-from Bin Code")
        {

            trigger OnLookup(var Text: Text): Boolean
            var
                Page_BinContentsList: Page "Bin Contents List";
                Table_BinContent: Record "Bin Content";
                transferorderheader: Record "Transfer Header";
                qty: Decimal;
                BinContent: Record "Bin Content";
                bin: Record Bin;
            begin
                Clear(Page_BinContentsList);
                Table_BinContent.Reset();
                Table_BinContent.SetRange("Item No.", Rec."Item No.");
                Table_BinContent.SetRange("Location Code", Rec."Transfer-from Code");
                if Rec."Variant Code" <> '' then
                    Table_BinContent.SetRange("Variant Code", Rec."Variant Code");
                Table_BinContent.SetFilter(Quantity, '>%1', 0);
                Page_BinContentsList.LookupMode(true);
                Page_BinContentsList.SetTableView(Table_BinContent);
                if Page_BinContentsList.RunModal() = Action::LookupOK then begin
                    Page_BinContentsList.GetRecord(Table_BinContent);
                    Rec.Validate("Transfer-from Bin Code", Table_BinContent."Bin Code");


                    //New Code++
                    Clear(qty);
                    if (Rec.Quantity > 0) AND (Rec."Transfer-from Bin Code" <> '') then begin
                        transferorderheader.Reset();
                        transferorderheader.SetRange("No.", rec."Document No.");
                        if transferorderheader.FindFirst() then begin
                            BinContent.Reset();
                            BinContent.SETRANGE("Item No.", Rec."Item No.");
                            if Rec."Transfer-from Bin Code" <> '' then
                                BinContent.SetRange("Bin Code", rec."Transfer-from Bin Code");
                            BinContent.SetRange("Location Code", transferorderheader."Transfer-from Code");
                            if Rec."Variant Code" <> '' then
                                BinContent.SetRange("Variant Code", Rec."Variant Code");
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

            end;

            trigger OnAfterValidate()
            var
                transferorderheader: Record "Transfer Header";
                qty: Decimal;
                BinContent: Record "Bin Content";
                bin: Record Bin;
            begin
                Clear(qty);
                if (Rec.Quantity > 0) AND (Rec."Transfer-from Bin Code" <> '') then begin
                    transferorderheader.Reset();
                    transferorderheader.SetRange("No.", rec."Document No.");
                    if transferorderheader.FindFirst() then begin
                        BinContent.Reset();
                        BinContent.SETRANGE("Item No.", Rec."Item No.");
                        BinContent.SetRange("Bin Code", rec."Transfer-from Bin Code");
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
        }

    }


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
