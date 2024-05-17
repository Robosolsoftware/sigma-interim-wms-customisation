tableextension 70137 "SC Price List Header" extends "Price List Header"
{
    fields
    {
        // Add changes to table fields here
        field(70137; "Special Price Daily"; Boolean)
        {
            Caption = 'Daily Promotions';
            trigger OnValidate()
            var
                L_PriceListHeader: Record "Price List Header";
            begin
                if Rec."Special Price Daily" = true then begin
                    L_PriceListHeader.Reset();
                    L_PriceListHeader.SetFilter(Code, '<>%1', Rec.Code);
                    L_PriceListHeader.SetRange("Special Price Daily", true);
                    if L_PriceListHeader.FindFirst() then
                        Error('Multiple Sales Price Not Allowed');
                end;
            end;
        }
        field(70138; "Drug Special"; Boolean)
        {
            DataClassification = ToBeClassified;
            //OptionMembers = " ","Drug Tariff";


        }
    }

    var
        myInt: Integer;
}