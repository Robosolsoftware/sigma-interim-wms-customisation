report 85001 "Create Warehouse Receipt"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            //DataItemTableView = where(Status = const(Released));
            trigger OnAfterGetRecord()
            var
                GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
            begin
                GetSourceDocInbound.CreateFromPurchOrderHideDialog("Purchase Header");
            end;

            trigger OnPreDataItem()
            begin
                "Purchase Header".SetRange(Status, G_Status);
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(G_Status; G_Status)
                    {
                        ApplicationArea = All;
                        Caption = 'Status';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            G_Status := G_Status::Released;
        end;
    }

    var
        myInt: Integer;
        G_Status: Enum "Purchase Document Status";

}


