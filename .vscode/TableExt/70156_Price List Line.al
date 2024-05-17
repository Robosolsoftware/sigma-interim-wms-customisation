tableextension 70156 "SC Price List Line" extends "Price List Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                Rec.TestField("Variant Code", '');
            end;
        }

        field(70156; "Special Price Daily"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Price List Header"."Special Price Daily" where(Code = field("Price List Code")));
        }

        field(70157; Strength; Code[35])
        {
            Description = 'Strength for which this price is being set. If a Tariff Product Code is selected Strength will come automatically. In case of Product Code the strength will come only if it has a fixed strength on the Item Card';
            Editable = false;
        }
        field(71001; "Strength UOM"; Code[10])
        {
            Description = 'Based on tariff code or Product card';
            //TableRelation = "Strength Master".Code;
            Editable = false;
        }
        field(70158; "Base Volume"; Decimal)
        {
            Description = 'Base Volume for which this price is being set. If a Tariff Product Code is selected Base Volume will come automatically. In case of Product Code the Volume will come only if it has a fixed Volume/pack size on the Item Card';
        }
        // field(71003; "Volume UOM"; Code[10])
        // {
        //     Description = 'From tariff code or Product card';
        // }

        field(70159; "Cost Unit Thereafter"; Decimal)
        {
            Description = 'Cost per additional volume to the base volume';
        }
        field(70160; "Special Product"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70161; Rebate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70162; "No. 2"; Code[20])
        {
            DataClassification = ToBeClassified;
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