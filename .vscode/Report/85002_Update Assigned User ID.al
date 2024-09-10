report 85002 "Update Assigned User ID"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Update Assigned User ID';
    ProcessingOnly = true;


    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {

            trigger OnAfterGetRecord()
            begin
                if G_User <> '' then begin
                    "Warehouse Activity Header".Validate("Assigned User ID", G_User);
                    "Warehouse Activity Header"."Assignment Date" := Today;
                    "Warehouse Activity Header"."Assignment Time" := Time;
                    "Warehouse Activity Header".Modify();

                end;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(G_User; G_User)
                    {
                        ApplicationArea = All;
                        Caption = 'Select - User';
                        ShowMandatory = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Page_WarehouseEmployees: Page "Warehouse Employees";
                            Table_WarehouseEmployees: Record "Warehouse Employee";
                        begin
                            Clear(G_User);
                            Clear(Page_WarehouseEmployees);
                            Table_WarehouseEmployees.Reset();
                            Table_WarehouseEmployees.SetRange("Location Code", G_LocationCode);
                            Page_WarehouseEmployees.LookupMode(true);
                            if Table_WarehouseEmployees.FindSet() then begin
                                Page_WarehouseEmployees.SetTableView(Table_WarehouseEmployees);
                                if Page_WarehouseEmployees.RunModal() = Action::LookupOK then begin
                                    Page_WarehouseEmployees.GetRecord(Table_WarehouseEmployees);
                                    G_User := Table_WarehouseEmployees."User Id";
                                end;
                            end;
                        end;

                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = CloseAction::OK then
                if G_User = '' then
                    Error('Please Select User');

        end;
    }



    trigger OnPostReport()
    begin
        Message('Completed..');
    end;

    var
        myInt: Integer;
        G_User: Code[20];
        G_LocationCode: Code[10];


    procedure GetLocationFilter(_LocationCode: Code[20])
    begin
        Clear(G_LocationCode);
        G_LocationCode := _LocationCode;
    end;
}