report 50000 "Stock Availability"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Location Filter";
            trigger OnAfterGetRecord()
            begin

            end;
        }
    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }

    // }

    trigger OnPreReport()
    begin
        Temp_ExcelBuf.DeleteAll();
        MakeExcelDataHeader;
    end;

    var
        myInt: Integer;
        Temp_ExcelBuf: Record 370 temporary;

    procedure MakeExcelDataHeader()

    begin
        Temp_ExcelBuf.NewRow;
        Temp_ExcelBuf.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Total Physical', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Aggreagate Code', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Warehouse Class Code', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Location code', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Zone code', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Variant Code', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Bin code', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Lot No.', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Expiry Date', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Inventory', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        //Temp_ExcelBuf.AddColumn('Net Inventory', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
    end;
}