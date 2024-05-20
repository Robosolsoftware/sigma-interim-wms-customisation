tableextension 85034 "SC Item Attribute Value" extends "Item Attribute Value"
{
    fields
    {
        // Add changes to table fields here
        modify(Value)
        {
            trigger OnAfterValidate()
            var
                RenameUsedAttributeValueQst: Label 'This item attribute has been assigned to Sales Order Warning Management OR Shipping Agent Restrict Item Setup.\\Are you sure you want to rename it?';
            begin
                if HasBeenUsedInSetup() then begin
                    if not Confirm(RenameUsedAttributeValueQst) then
                        Error('');

                    UpdateAttributeValueNameOnSalesOrderWarningManagementSetup(xRec, Value)
                end;

            end;
        }
    }

    var
        myInt: Integer;


    trigger OnDelete()
    var
        DeleteUsedAttributeValueQst: Label 'This item attribute has been assigned to Sales Order Warning Management OR Shipping Agent Restrict Item Setup.\\Are you sure you want to delete it?';
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        if HasBeenUsedInSetup() then begin
            if not Confirm(DeleteUsedAttributeValueQst) then
                Error('');

            SalesOrderWarningManagementSetup.Reset();
            SalesOrderWarningManagementSetup.SetRange("Attribute ID", "Attribute ID");
            if ID <> 0 then
                SalesOrderWarningManagementSetup.SetRange("Attribute value ID", ID)
            else
                SalesOrderWarningManagementSetup.SetRange("Attribute Value", Value);
            if SalesOrderWarningManagementSetup.FindSet() then
                SalesOrderWarningManagementSetup.DeleteAll();

            ShippingAgentRestrictItem.Reset();
            ShippingAgentRestrictItem.SetRange("Attribute ID", "Attribute ID");
            if ID <> 0 then
                ShippingAgentRestrictItem.SetRange("Attribute value ID", ID)
            else
                ShippingAgentRestrictItem.SetRange("Attribute Value", Value);
            if ShippingAgentRestrictItem.FindSet() then
                ShippingAgentRestrictItem.DeleteAll();
        end;
    end;


    procedure HasBeenUsedInSetup(): Boolean
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        SalesOrderWarningManagementSetup.Reset();
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", "Attribute ID");
        if ID <> 0 then
            SalesOrderWarningManagementSetup.SetRange("Attribute value ID", ID)
        else
            SalesOrderWarningManagementSetup.SetRange("Attribute Value", Value);
        if SalesOrderWarningManagementSetup.FindFirst() then begin
            exit(true);
        end;

        ShippingAgentRestrictItem.Reset();
        ShippingAgentRestrictItem.SetRange("Attribute ID", "Attribute ID");
        if ID <> 0 then
            ShippingAgentRestrictItem.SetRange("Attribute value ID", ID)
        else
            ShippingAgentRestrictItem.SetRange("Attribute Value", Value);
        if ShippingAgentRestrictItem.FindFirst() then begin
            exit(true);
        end;

        exit(false);
    end;


    Local procedure UpdateAttributeValueNameOnSalesOrderWarningManagementSetup(ItemAttributeValue: Record "Item Attribute Value"; NameToCheck: Text[250])
    var
        SalesOrderWarningManagementSetup: Record "Sales Order warning Mng. Setup";
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
    begin
        SalesOrderWarningManagementSetup.Reset();
        SalesOrderWarningManagementSetup.SetRange("Attribute ID", ItemAttributeValue."Attribute ID");
        SalesOrderWarningManagementSetup.SetRange("Attribute value ID", ItemAttributeValue.ID);
        if SalesOrderWarningManagementSetup.FindSet() then begin
            repeat
                SalesOrderWarningManagementSetup."Attribute Value" := NameToCheck;
                SalesOrderWarningManagementSetup.Modify();
            until SalesOrderWarningManagementSetup.Next() = 0;
        end;

        SalesOrderWarningManagementSetup.Reset();
        ShippingAgentRestrictItem.SetRange("Attribute ID", ItemAttributeValue."Attribute ID");
        ShippingAgentRestrictItem.SetRange("Attribute value ID", ItemAttributeValue.ID);
        if ShippingAgentRestrictItem.FindSet() then begin
            repeat
                ShippingAgentRestrictItem."Attribute Value" := NameToCheck;
                ShippingAgentRestrictItem.Modify();
            until ShippingAgentRestrictItem.Next() = 0;
        end;
    end;
}

