table 50000 "Sales Order warning Mng. Setup"
{
    Caption = 'Sales Order warning Management Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(2; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));
        }

        field(4; "Attribute Name"; Text[250])
        {
            Caption = 'Attribute Name';
            NotBlank = true;

            trigger OnValidate()
            var
                ItemAttribute: Record "Item Attribute";
            begin
                FindItemAttributeCaseInsensitive(ItemAttribute);
                CheckIfBlocked(ItemAttribute);
                AdjustAttributeName(ItemAttribute);
                ValidateChangedAttribute(ItemAttribute);
            end;
        }

        field(5; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
        }
        field(6; "Attribute Value"; Text[250])
        {
            Caption = 'Value';
            trigger OnValidate()
            var
                ItemAttributeValue: Record "Item Attribute Value";
                ItemAttribute: Record "Item Attribute";
                DecimalValue: Decimal;
                IntegerValue: Integer;
                DateValue: Date;
            begin
                if "Attribute Value" = '' then
                    exit;

                DateValue := 0D;
                DecimalValue := 0;
                IntegerValue := 0;

                ItemAttribute.Get("Attribute ID");
                if FindItemAttributeValueCaseSensitive(ItemAttributeValue) then begin
                    CheckIfValueBlocked(ItemAttributeValue);
                    ValidateChangedAttributeValue(ItemAttributeValue)
                end;
            end;
        }
        field(7; "Attribute value ID"; Integer)
        {
            Caption = 'Attribute value ID';
        }
        field(8; "Warning message"; Text[50])
        {
            Caption = 'Warning message';
        }
        field(9; "Warning Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Warning,Error;
        }
    }
    keys
    {
        key(PK; "Dimension Code", "Dimension Value", "Attribute ID", "Attribute value ID")
        {
            Clustered = true;
        }
    }
    var
        tes: Record Item;


    local procedure FindItemAttributeCaseInsensitive(var ItemAttribute: Record "Item Attribute")
    var
        AttributeName: Text[250];
        AttributeDoesntExistErr: Label 'The item attribute ''%1'' doesn''t exist.', Comment = '%1 - arbitrary name';
    begin
        ItemAttribute.SetRange(Name, "Attribute Name");
        if ItemAttribute.FindFirst() then
            exit;

        AttributeName := LowerCase("Attribute Name");
        ItemAttribute.SetRange(Name);
        if ItemAttribute.FindSet() then
            repeat
                if LowerCase(ItemAttribute.Name) = AttributeName then
                    exit;
            until ItemAttribute.Next() = 0;

        Error(AttributeDoesntExistErr, "Attribute Name");
    end;

    local procedure CheckIfBlocked(var ItemAttribute: Record "Item Attribute")
    var
        AttributeBlockedErr: Label 'The item attribute ''%1'' is blocked.', Comment = '%1 - arbitrary name';
    begin
        if ItemAttribute.Blocked then
            Error(AttributeBlockedErr, ItemAttribute.Name);
    end;

    local procedure AdjustAttributeName(var ItemAttribute: Record "Item Attribute")
    begin
        if "Attribute Name" <> ItemAttribute.Name then
            "Attribute Name" := ItemAttribute.Name;
    end;

    local procedure ValidateChangedAttribute(var ItemAttribute: Record "Item Attribute")
    begin
        if "Attribute ID" <> ItemAttribute.ID then begin
            Validate("Attribute ID", ItemAttribute.ID);
            Validate("Attribute Value", '');
        end;
    end;

    local procedure ValidateChangedAttributeValue(var ItemAttributeValue: Record "Item Attribute Value")
    begin
        if "Attribute value ID" <> ItemAttributeValue.ID then begin
            Validate("Attribute value ID", ItemAttributeValue.ID);
        end;
    end;

    local procedure FindItemAttributeValueCaseSensitive(var ItemAttributeValue: Record "Item Attribute Value"): Boolean
    begin
        ItemAttributeValue.SetRange("Attribute ID", "Attribute ID");
        ItemAttributeValue.SetRange(Value, "Attribute Value");
        exit(ItemAttributeValue.FindFirst());
    end;

    local procedure CheckIfValueBlocked(ItemAttributeValue: Record "Item Attribute Value")
    var
        AttributeValueBlockedErr: Label 'The item attribute value ''%1'' is blocked.', Comment = '%1 - arbitrary name';
    begin
        if ItemAttributeValue.Blocked then
            Error(AttributeValueBlockedErr, ItemAttributeValue.Value);
    end;


}
