tableextension 70135 "SC Item Attribute" extends "Item Attribute"
{
    fields
    {
        // Add changes to table fields here
        field(70135; "CD Schedule"; Boolean)
        {

        }
        field(70136; "Fridge"; Boolean)
        {

        }
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                RenameUsedAttributeQst: Label 'This item attribute has been assigned to Sales Order Warning Management Setup.\\Are you sure you want to rename it?';
            begin
                if HasBeenUsedInSetup() then
                    if not Confirm(RenameUsedAttributeQst) then
                        Error('');
                UpdateAttributeNameOnSalesOrderWarningManagementSetup(xRec, Name);
            end;
        }
    }

    var
        myInt: Integer;

    trigger OnDelete()
    var
        DeleteUsedAttributeQst: Label 'This item attribute has been assigned to Sales Order Warning Management Setup.\\Are you sure you want to delete it?';
    begin
        if HasBeenUsedInSetup() then
            if not Confirm(DeleteUsedAttributeQst) then
                Error('');
        DeleteValuesAndTranslations();

    end;


    procedure HasBeenUsedInSetup() AttributeHasBeenUsed: Boolean
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
    begin
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", ID);
        AttributeHasBeenUsed := not SalesOrderWarningManagementSetup.IsEmpty();
    end;

    local procedure DeleteValuesAndTranslations()
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
    begin
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", ID);
        SalesOrderWarningManagementSetup.DeleteAll();

    end;

    Local procedure UpdateAttributeNameOnSalesOrderWarningManagementSetup(ItemAttribute: Record "Item Attribute"; NameToCheck: Text[250])
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
    begin
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", ItemAttribute.ID);
        if SalesOrderWarningManagementSetup.FindSet() then begin
            repeat
                SalesOrderWarningManagementSetup."Attribute Name" := NameToCheck;
                SalesOrderWarningManagementSetup.Modify();
            until SalesOrderWarningManagementSetup.Next() = 0;
        end;
    end;
}