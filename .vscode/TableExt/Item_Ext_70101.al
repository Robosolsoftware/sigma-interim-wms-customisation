tableextension 70101 "Item_Extension" extends Item
{
    fields
    {
        modify("Item Category Code")
        {
            Caption = 'Sub-Child Category';
        }

        // modify("Unit List Price")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         "Unit Net Price" := "Unit List Price" + "Unit Duty Amount" - "Unit Retro Amount";
        //     end;
        // }
        // modify("Unit Price")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         CalculatePORDisc();
        //     end;
        // }
        // field(80090; "Size"; Text[30])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(80091; "Pack"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //         L_UnitOfMeasure: Record "Item Unit of Measure";
        //     begin
        //         L_UnitOfMeasure.Reset();
        //         L_UnitOfMeasure.SetRange(Code, Rec."Base Unit of Measure");
        //         L_UnitOfMeasure.SetRange("Item No.", Rec."No.");
        //         if L_UnitOfMeasure.FindFirst() then begin
        //             L_UnitOfMeasure.Pack := Rec.Pack;
        //             L_UnitOfMeasure.Modify(true);
        //         end;
        //         CalculatePORDisc();
        //     end;
        // }

        // field(80092; "Layer Quantity"; Decimal)
        // {
        //     DataClassification = ToBeClassified;

        // }
        field(80093; "Pallet Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        // field(80094; "Base UOM Type"; Option)
        // {
        //     OptionMembers = "","Single","Case";
        // }
        // field(80095; "Unit Barcode"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //     begin
        //         If "Unit Barcode" <> '' then
        //             CreateItemReference(CurrFieldNo, Rec, "Unit Barcode");
        //     end;
        // }
        // field(80096; "Outer Barcode"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //     begin
        //         If "Outer Barcode" <> '' then
        //             CreateItemReference(CurrFieldNo, Rec, "Outer Barcode");
        //     end;
        // }
        // field(80097; "POR Pack"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //         L_ItemUoM: Record "Item Unit of Measure";

        //     begin
        //         CalculatePORDisc();
        //     end;

        // }

        // field(80098; "POR Price"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //         L_ItemUoM: Record "Item Unit of Measure";
        //     begin
        //         CalculatePORDisc();

        //     end;
        // }
        // field(80099; "POR Discount %"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        // }

        // field(80101; "Unit Duty Amount"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     begin
        //         "Unit Net Price" := "Unit List Price" + "Unit Duty Amount" - "Unit Retro Amount";
        //     end;
        // }
        // field(80102; "Unit Retro Amount"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     begin
        //         "Unit Net Price" := "Unit List Price" + "Unit Duty Amount" - "Unit Retro Amount";
        //     end;
        // }
        // field(80103; "Unit Net Price"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(80104; "Margin%"; Decimal)//Pranali 08022022
        // {
        //     Caption = 'Minimum Margin %';
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 0 : 0;

        // }
        // field(80105; "Dangerous Goods UN Code"; Code[100])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(80106; "Meursing Code"; Code[100])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(80107; "Inner Barcode"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //     begin
        //         If "Inner Barcode" <> '' then
        //             CreateItemReference(CurrFieldNo, Rec, "Inner Barcode");
        //     end;
        // }
        field(80108; "Pack Size"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(80109; Brand; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(80110; "Net Inventory"; Decimal)
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
        }
        field(70101; "Min Sell Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70102; "Variant Exist"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Variant" where("Item No." = field("No.")));
        }
        field(70103; "Child Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Item Category Code")));
        }
        field(70104; "Parent Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Child Category")));
        }
        field(70105; RRP; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(70106; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Released;
        }
        field(70107; Storage; Code[20])
        {
            TableRelation = "Temperature Range";
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Parent Category")
        {
        }
    }
    var
        myInt: Integer;

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
}