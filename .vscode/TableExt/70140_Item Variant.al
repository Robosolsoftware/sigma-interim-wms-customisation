tableextension 70140 "SC Item Variant" extends "Item Variant"
{
    fields
    {
        // Add changes to table fields here
        field(70140; Priority; Integer)
        {
            DataClassification = ToBeClassified;
            //GHST Customization++
            trigger OnValidate()
            var
                L_ItemVariant: Record "Item Variant";
            begin
                if Rec.Priority <> 0 then
                    if TotalAvailableQty(Rec) <= 0 then
                        Error('Total Available Quantity should be greater than 0');


                if Rec.Priority > 0 then begin
                    L_ItemVariant.Reset();
                    L_ItemVariant.SetRange("Item No.", Rec."Item No.");
                    //L_ItemVariant.SetRange(Code, Rec.Code);
                    L_ItemVariant.SetRange(Priority, Rec.Priority);
                    if L_ItemVariant.FindFirst() then
                        Error('Priority %1 is already defined', Rec.Priority);
                end;

            end;
        }
        field(70141; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD(Code)));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            //GHST Customization++
        }
        field(70142; "Total Requested Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("No." = field("Item No."), "Variant Code" = field(Code), "Outstanding Quantity" = filter(> 0)));
            DecimalPlaces = 0 : 5;
            //GHST Customization++
        }
        field(70143; Quantity; Decimal)
        {
            //This is temp field and updating at the time of Assign variant code on Sales order++
            //Dont Use this field any other purpose++
        }


    }

    var
        myInt: Integer;

    local procedure TotalAvailableQty(_Rec: Record "Item Variant"): Decimal
    begin
        _Rec.CalcFields(Inventory, "Total Requested Quantity");
        if _Rec.Inventory > 0 then
            exit(_Rec.Inventory - _Rec."Total Requested Quantity")
        else
            exit(0);
    end;


}