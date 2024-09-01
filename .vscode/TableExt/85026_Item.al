tableextension 85026 "Item_Extension" extends Item
{
    fields
    {
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                No_CheckSpecialChars("No.");
            end;
        }
        // modify(Description)
        // {
        //     trigger OnBeforeValidate()
        //     begin
        //         Description_CheckSpecialChars(Description);
        //     end;
        // }


        modify(Inventory)
        {
            Caption = 'Total Physical';
        }
        modify("Item Category Code")
        {
            Caption = 'Sub-Child Category';
        }
        field(85000; "Pallet Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(85001; "Pack Size"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85002; Brand; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "Net Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = filter('IP3|IP4|PSP|SH|SS'),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Filter"),
                                                                  "Package No." = FIELD("Package No. Filter")));
            Caption = 'Net Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

            //Not Required++
        }
        field(85101; "Min Sell Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if Rec."Min Sell Price" > 0 then begin
                    //Rec.TestField("Unit Price");
                    if Rec."Unit Price" = 0 then
                        Error('Unit Price should not be blank');

                    if Rec."Min Sell Price" > Rec."Unit Price" then
                        Error('Min Sell Price %1 should be less than Unit Price %2. Item No.: %3.', Rec."Min Sell Price", Rec."Unit Price", Rec."No.");
                end;
            end;
        }
        field(85102; "Variant Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("No.")));
        }
        field(85103; "Child Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Item Category Code")));
        }
        field(85104; "Parent Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Child Category")));
        }
        field(85105; RRP; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(85106; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released;

            trigger OnValidate()
            var
                ItemAttrValueMapp: Record "Item Attribute Value Mapping";
                ItemattributesValues: Record "Item Attribute Value";
                Itemattributevalueblank: Integer;
            begin
                if Rec.Status = Rec.Status::Released then begin
                    rec.TestField("No.");
                    Rec.TestField(Description);
                    Rec.TestField("Item Category Code");
                    Rec.TestField("Unit Price");
                    Rec.TestField(RRP);
                    Rec.TestField("VAT Prod. Posting Group");
                    Rec.TestField(Storage);
                    Rec.TestField("Min Sell Price");//
                    Rec.TestField("Inventory Posting Group");
                    Rec.TestField("Variant Mandatory if Exists");
                    Rec.TestField("Over-Receipt Code");
                    Rec.TestField("Costing Method");
                    Rec.TestField("Base Unit of Measure");
                    Rec.TestField("Item Tracking Code");

                    Clear(Itemattributevalueblank);
                    ItemAttrValueMapp.Reset();
                    ItemAttrValueMapp.SetRange("Table ID", 27);
                    ItemAttrValueMapp.SetRange("No.", Rec."No.");
                    if not ItemAttrValueMapp.FindFirst() then
                        Error('Item Attribute Must Not Be Blank');

                    ItemAttrValueMapp.Reset();
                    ItemAttrValueMapp.SetRange("Table ID", 27);
                    ItemAttrValueMapp.SetRange("No.", Rec."No.");
                    if ItemAttrValueMapp.FindSet() then begin
                        repeat
                            ItemattributesValues.Reset();
                            ItemattributesValues.SetRange("Attribute ID", ItemAttrValueMapp."Item Attribute ID");
                            ItemattributesValues.SetRange(ID, ItemAttrValueMapp."Item Attribute Value ID");
                            if ItemattributesValues.FindSet() then begin
                                if ItemattributesValues.Value = '' then begin
                                    Itemattributevalueblank += 1;
                                end;
                            end;
                        until ItemAttrValueMapp.Next() = 0;
                    end;

                    if Itemattributevalueblank > 0 then begin
                        Error('Value In Item Attributes Must Not Be Blank');
                    end;
                end;
            end;
        }
        field(85107; Storage; Code[20])
        {
            TableRelation = "Temperature Range";
        }
        field(85109; "QAU Approved"; Boolean)
        {

        }
        field(85110; "Saleable Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Saleable Location" = const(true), "Location Code" = field("Location Filter")));
            //Caption = 'Saleable Inventory';
            Caption = 'Physical (Saleable)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            //GHST Customization++
        }
        field(85111; "Top Category"; Boolean)
        {

        }
        field(85112; VMPP; Code[30])
        {

        }
        field(85113; AMPP; Code[30])
        {

        }
        field(85114; "Special Product"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85115; Strength; Code[35])
        {
            DataClassification = ToBeClassified;

        }
        field(85117; "Ops Sales Blocked"; Boolean)
        {
            Caption = 'Ops Sales Blocked';
            DataClassification = CustomerContent;
        }
        field(85118; "Ops Purchase Blocked"; Boolean)
        {
            Caption = 'Ops Purchase Blocked';
            DataClassification = CustomerContent;
        }
        field(85119; "EDI Description"; Text[40])
        {

        }
        field(85120; "EDI Pack size"; Decimal)
        {

        }
        field(85121; Rebatable; Boolean)
        {

        }
        field(85122; "Business Sensitive"; Boolean)
        {

        }
        field(85123; Ari; Boolean)
        {

        }
        field(85124; "Signature required"; Boolean)
        {

        }
        field(85125; "Zero Discount"; Boolean)
        {

        }
        field(85126; "Non Tele Sales"; Boolean)
        {

        }
        field(85127; "TO Discount %"; Decimal)
        {

        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Unit Price" > 0 then
                    if Rec."Unit Price" < Rec."Min Sell Price" then
                        Error('Unit Price %1 should be greater than Min Sell Price %2', Rec."Unit Price", Rec."Min Sell Price");
            end;
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Top Category", "Parent Category", "Search Description")
        {
        }
        addlast(Brick; "Top Category", "Parent Category", "Search Description")
        {

        }
    }
    var
        myInt: Integer;
        SpecialCharsErr: Label 'You can not enter the special characters!';

    // local procedure CalculatePORDisc()
    // begin
    //     // =(POR PRICE/POR PACK - (UNIT PRICE/PACK))/(POR PRICE/POR PACK)*100
    //     if (("POR Pack" > 0) AND (Pack > 0) AND ("POR Price" > 0)) then
    //         "POR Discount %" := ("POR Price" / "POR Pack" - ("Unit Price" / Pack)) / ("POR Price" / "POR Pack") * 100;

    // end;


    // procedure CreateItemReference(P_CurrFieldNo: Integer; P_Item: Record Item; P_Barcode: Code[20])
    // var
    //     L_ItemReference: Record "Item Reference";
    //     UoMCode: Code[50];
    // begin

    //     UoMCode := GetUoMCode(CurrFieldNo);
    //     L_ItemReference.Reset();
    //     L_ItemReference.RESET;
    //     L_ItemReference.SETRANGE("Item No.", P_Item."No.");
    //     L_ItemReference.SETRANGE("Reference Type", L_ItemReference."Reference Type"::"Bar Code");
    //     L_ItemReference.SETRANGE("Unit of Measure", UoMCode);
    //     IF L_ItemReference.FINDFIRST THEN BEGIN
    //         L_ItemReference.Rename(L_ItemReference."Item No.", L_ItemReference."Variant Code", L_ItemReference."Unit of Measure", L_ItemReference."Reference Type", L_ItemReference."Reference Type No.", P_Barcode);
    //     END
    //     else begin
    //         L_ItemReference.INIT;
    //         L_ItemReference.VALIDATE("Item No.", P_Item."No.");
    //         L_ItemReference.VALIDATE("Reference Type", L_ItemReference."Reference Type"::"Bar Code");
    //         L_ItemReference.VALIDATE("Unit of Measure", UoMCode);
    //         L_ItemReference.VALIDATE("Reference No.", P_Barcode);
    //         L_ItemReference.INSERT(TRUE);
    //     end;
    // end;

    // local procedure GetUoMCode(currFieldNo: Integer): Code[20]
    // var
    //     L_InventorySetup: Record "Inventory Setup";
    // begin
    //     L_InventorySetup.Get();

    //     Case currFieldNo of
    //         80095:
    //             exit(L_InventorySetup."Unit UoM");
    //         80096:
    //             exit(L_InventorySetup."Outer Unit of Measure");
    //         80107:
    //             exit(L_InventorySetup."Inner Unit of Measure");
    //     End;
    // end;


    local procedure No_CheckSpecialChars(Var _Value: Code[100])
    var
        SpecialChars: Label '!|@|#|$|%|&|*|(|)|_|+|=|/|?|)|(';
        Len: Integer;
    begin
        Clear(Len);
        Len := StrLen(DelChr(_Value, '=', DelChr(_Value, '=', SpecialChars)));
        if Len > 0 then
            Error(SpecialCharsErr);
    end;

    local procedure Description_CheckSpecialChars(Var _Value: Text[100])
    var
        SpecialChars: Label '!|@|#|$|%|&|*|(|)|_|+|=|/|?|)|(';
        Len: Integer;
    begin
        Clear(Len);
        Len := StrLen(DelChr(_Value, '=', DelChr(_Value, '=', SpecialChars)));
        if Len > 0 then
            Error(SpecialCharsErr);
    end;
}