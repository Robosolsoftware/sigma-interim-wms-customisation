tableextension 50003 ItemReferenceExt extends "Item Reference"
{
    fields
    {

        modify("Reference No.")
        {
            trigger OnAfterValidate()
            var
                L_ItemReference: Record "Item Reference";
            begin
                if Rec."Reference No." <> '' then begin
                    L_ItemReference.Reset();
                    L_ItemReference.SetRange("Reference Type", L_ItemReference."Reference Type"::"PIP Code");
                    L_ItemReference.SetRange("Reference No.", Rec."Reference No.");
                    L_ItemReference.SetFilter("Item No.", '<>%1', Rec."Item No.");
                    if not L_ItemReference.IsEmpty() then
                        Error('PIP Code: %1 Already exist', Rec."Reference No.");

                end;
            end;
        }
        field(50004; Length; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; Width; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; Height; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Cubage; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; Weight; Decimal)
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