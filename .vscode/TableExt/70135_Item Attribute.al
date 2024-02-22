tableextension 70135 "SC Item Attribute" extends "Item Attribute"
{
    fields
    {
        // Add changes to table fields here
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                RenameUsedAttributeQst: Label 'This item attribute has been assigned to Sales Order Warning Management OR Shipping Agent Restrict Item Setup.\\Are you sure you want to rename it?';
            begin
                if HasBeenUsedInSetup() then begin
                    if not Confirm(RenameUsedAttributeQst) then
                        Error('');
                    UpdateAttributeNameOnSalesOrderWarningManagementSetup(xRec, Name);
                end;
            end;
        }
    }

    var
        myInt: Integer;

    trigger OnDelete()
    var
        DeleteUsedAttributeQst: Label 'This item attribute has been assigned to Sales Order Warning Management OR Shipping Agent Restrict Item Setup.\\Are you sure you want to delete it?';
    begin
        if HasBeenUsedInSetup() then begin
            if not Confirm(DeleteUsedAttributeQst) then
                Error('');
            DeleteValuesAndTranslations();
        end;

    end;


    procedure HasBeenUsedInSetup(): Boolean
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        SalesOrderWarningManagementSetup.Reset();
        if ID <> 0 then
            SalesOrderWarningManagementSetup.SetRange("Attribute ID", ID)
        else
            SalesOrderWarningManagementSetup.SetRange("Attribute Name", Name);
        if SalesOrderWarningManagementSetup.FindFirst() then
            exit(true);

        ShippingAgentRestrictItem.Reset();
        if ID <> 0 then
            ShippingAgentRestrictItem.SetRange("Attribute ID", ID)
        else
            ShippingAgentRestrictItem.SetRange("Attribute Name", Name);
        if ShippingAgentRestrictItem.FindFirst() then
            exit(true);

        exit(false);
    end;

    local procedure DeleteValuesAndTranslations()
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        SalesOrderWarningManagementSetup.Reset();
        if ID <> 0 then
            SalesOrderWarningManagementSetup.SetRange("Attribute ID", ID)
        else
            SalesOrderWarningManagementSetup.SetRange("Attribute Name", Name);
        if SalesOrderWarningManagementSetup.FindSet() then
            SalesOrderWarningManagementSetup.DeleteAll();

        ShippingAgentRestrictItem.Reset();
        if ID <> 0 then
            ShippingAgentRestrictItem.SetRange("Attribute ID", ID)
        else
            ShippingAgentRestrictItem.SetRange("Attribute Name", Name);
        if ShippingAgentRestrictItem.FindSet() then
            ShippingAgentRestrictItem.DeleteAll();
    end;

    Local procedure UpdateAttributeNameOnSalesOrderWarningManagementSetup(ItemAttribute: Record "Item Attribute"; NameToCheck: Text[250])
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        SalesOrderWarningManagementSetup.Reset();
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", ItemAttribute.ID);
        if SalesOrderWarningManagementSetup.FindSet() then begin
            repeat
                SalesOrderWarningManagementSetup."Attribute Name" := NameToCheck;
                SalesOrderWarningManagementSetup.Modify();
            until SalesOrderWarningManagementSetup.Next() = 0;
        end;

        ShippingAgentRestrictItem.Reset();
        ShippingAgentRestrictItem.SetRange("Attribute ID", ItemAttribute.ID);
        if ShippingAgentRestrictItem.FindSet() then begin
            repeat
                ShippingAgentRestrictItem."Attribute Name" := NameToCheck;
                ShippingAgentRestrictItem.Modify();
            until ShippingAgentRestrictItem.Next() = 0;
        end;
    end;
}