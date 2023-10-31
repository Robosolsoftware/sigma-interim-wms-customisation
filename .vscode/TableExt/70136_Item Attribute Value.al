tableextension 70136 "SC Item Attribute Value" extends "Item Attribute Value"
{
    fields
    {
        // Add changes to table fields here
        modify(Value)
        {
            trigger OnAfterValidate()
            var
                RenameUsedAttributeValueQst: Label 'This item attribute has been assigned to Sales Order Warning Management Setup.\\Are you sure you want to rename it?';
            begin
                if HasBeenUsedInSetup() then
                    if not Confirm(RenameUsedAttributeValueQst) then
                        Error('');

                UpdateAttributeValueNameOnSalesOrderWarningManagementSetup(xRec, Value)

            end;
        }
    }

    var
        myInt: Integer;


    trigger OnDelete()
    var
        DeleteUsedAttributeValueQst: Label 'This item attribute has been assigned to Sales Order Warning Management Setup.\\Are you sure you want to delete it?';
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
    begin
        if HasBeenUsedInSetup() then
            if not Confirm(DeleteUsedAttributeValueQst) then
                Error('');
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", "Attribute ID");
        SalesOrderWarningManagementSetup.SetRange("Attribute value ID", ID);
        SalesOrderWarningManagementSetup.DeleteAll();
    end;


    procedure HasBeenUsedInSetup(): Boolean
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
        AttributeHasBeenUsed: Boolean;
    begin
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", "Attribute ID");
        SalesOrderWarningManagementSetup.SetRange("Attribute value ID", ID);
        AttributeHasBeenUsed := not SalesOrderWarningManagementSetup.IsEmpty();
        exit(AttributeHasBeenUsed);
    end;


    Local procedure UpdateAttributeValueNameOnSalesOrderWarningManagementSetup(ItemAttributeValue: Record "Item Attribute Value"; NameToCheck: Text[250])
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
    begin
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", ItemAttributeValue."Attribute ID");
        SalesOrderWarningManagementSetup.SetRange("Attribute value ID", ItemAttributeValue.ID);
        if SalesOrderWarningManagementSetup.FindSet() then begin
            repeat
                SalesOrderWarningManagementSetup."Attribute Value" := NameToCheck;
                SalesOrderWarningManagementSetup.Modify();
            until SalesOrderWarningManagementSetup.Next() = 0;
        end;
    end;
}

