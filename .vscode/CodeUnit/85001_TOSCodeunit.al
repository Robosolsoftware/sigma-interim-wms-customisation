codeunit 85001 "TOS Query Loader"
{
    procedure LoadQueryData(var TempTable: Record "TOS Page Temp Table" temporary)
    var
        TOSQuery: Query TOSQuery;
        TempRec: Record "TOS Page Temp Table";
    begin
        TOSQuery.Open();

        while TOSQuery.Read() do begin
            TempRec.Init();
            TempRec."Order No." := TOSQuery.Order_No_;
            TempRec."Order Line No." := TOSQuery.Order_Line_No_;
            TempRec.Quantity := TOSQuery.Quantity;
            TempRec."Posting Date" := TOSQuery.Posting_Date;
            TempTable := TempRec;
            TempTable.Insert();
        end;

        TOSQuery.Close();
    end;
}
