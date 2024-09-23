codeunit 85022 "Post Direct Debit"
{
    trigger OnRun()
    begin
        GenBatch.Reset();
        GenBatch.SetRange("Direct Debit Batch", true);
        if GenBatch.FindSet() then
            repeat
                GenJourLine.Reset();
                GenJourLine.SetRange("Journal Batch Name", GenBatch.Name);
                GenJourLine.SetRange("Journal Template Name", GenBatch."Journal Template Name");
                If GenJourLine.FindSet() then
                    repeat
                        GenJnlPostLine.RunWithCheck(GenJourLine);
                    until GenJourLine.Next() = 0;
            until GenBatch.next = 0;
        GenBatch2.Reset();
        GenBatch2.SetRange("Direct Debit Batch", true);
        if GenBatch2.FindSet() then
            repeat
                GenJourLine2.Reset();
                GenJourLine2.SetRange("Journal Batch Name", GenBatch2.Name);
                GenJourLine2.SetRange("Journal Template Name", GenBatch2."Journal Template Name");
                If GenJourLine2.FindSet() then
                    repeat
                        GenJourLine2.DeleteAll();
                    until GenJourLine2.Next() = 0;
            until GenBatch2.next = 0;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Post Inventory Cost to G/L", 'OnPreReportOnAfterSetDocNo', '', false, false)]
    local procedure OnPreReportOnAfterSetDocNo(var DocNo: Code[20]; Post: Boolean)
    begin
    end;

    var
        myInt: Integer;
        GenBatch: Record "Gen. Journal Batch";
        GenBatch2: Record "Gen. Journal Batch";
        GenJourLine: Record "Gen. Journal Line";
        GenJourLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        InvTCostToGL: Report 1002;
}
