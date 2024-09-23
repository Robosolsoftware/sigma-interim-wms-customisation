codeunit 85023 "Post Inv. Cost to G/L-Job"
{
    trigger OnRun()
    begin
        Clear(G_DocNo);
        Clear(G_RepPostCost);
        G_Inventorysetup.get;
        G_DocNo := G_Noseries.GetNextNo(G_Inventorysetup."Post Cost to G/L No. Series", WorkDate(), True);
        G_RepPostCost.InitializeRequest(G_PostMethod::"per Posting Group", G_DocNo, true);
        G_RepPostCost.UseRequestPage(false);
        G_RepPostCost.Run();
    end;

    var
        myInt: Integer;
        G_RepPostCost: Report "Post Inventory Cost to G/L";
        G_PostMethod: Option "per Posting Group","per Entry";
        G_DocNo: code[35];
        G_Noseries: Codeunit "No. Series";
        G_Inventorysetup: Record "Inventory Setup";
}
