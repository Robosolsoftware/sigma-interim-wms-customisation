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
        Temp_ExcelBuf.AddColumn('Total Allocated on SO', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Total Free', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Physical', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Allocated on SO', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
        Temp_ExcelBuf.AddColumn('Free', FALSE, '', TRUE, FALSE, TRUE, '@', Temp_ExcelBuf."Cell Type"::Text);
    end;
}