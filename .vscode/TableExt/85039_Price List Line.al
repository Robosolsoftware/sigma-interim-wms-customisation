tableextension 85039 "SC Price List Line" extends "Price List Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Product No.")
        {
            trigger OnAfterValidate()
            var
                L_Item: Record Item;
                L_PriceListHeader: Record "Price List Header";
            begin
                L_Item.Reset();
                L_Item.SetRange("No.", Rec."Product No.");
                if L_Item.FindFirst() then begin
                    if L_Item."Special Product" = true then begin
                        L_PriceListHeader.Reset();
                        L_PriceListHeader.SetRange(Code, Rec."Price List Code");
                        if L_PriceListHeader.FindFirst() then begin
                            if L_PriceListHeader."Drug Special" = false then begin
                                Error(StrSubstNo('Special Product is not allowed for this Contract Code %1.', L_PriceListHeader.Code, Rec));
                            end;
                        end;
                    end;
                end;
            end;
        }
        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                Rec.TestField("Variant Code", '');
            end;
        }

        field(85156; "Special Price Daily"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Price List Header"."Special Price Daily" where(Code = field("Price List Code")));
        }

        field(85157; Strength; Code[35])
        {
            Description = 'Strength for which this price is being set. If a Tariff Product Code is selected Strength will come automatically. In case of Product Code the strength will come only if it has a fixed strength on the Item Card';
            Editable = false;
        }
        field(85000; "Strength UOM"; Code[10])
        {
            Description = 'Based on tariff code or Product card';
            //TableRelation = "Strength Master".Code;
            Editable = false;
        }
        field(85158; "Base Volume"; Decimal)
        {
            Description = 'Base Volume for which this price is being set. If a Tariff Product Code is selected Base Volume will come automatically. In case of Product Code the Volume will come only if it has a fixed Volume/pack size on the Item Card';
        }
        // field(71003; "Volume UOM"; Code[10])
        // {
        //     Description = 'From tariff code or Product card';
        // }

        field(85159; "Cost Unit Thereafter"; Decimal)
        {
            Description = 'Cost per additional volume to the base volume';
        }
        field(85160; "Special Product"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85161; Rebate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(85162; "No. 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85163; "No of Count"; Integer)
        {

        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}