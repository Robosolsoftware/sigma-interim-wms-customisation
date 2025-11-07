pageextension 85144 ItemJournalEXT extends "Item Journal"
{
    layout
    {
        modify("Reason Code")
        {
            trigger OnBeforeValidate()
            var
                ReasonCode: Record "Reason Code";
            begin
                ReasonCode.Reset();
                ReasonCode.SetRange(Code, Rec."Reason Code");
                if ReasonCode.FindFirst() then begin
                    if ReasonCode.Blocked = true then begin
                        Error('This Reason Code is Blocked');
                    end;
                end;

            end;
            // trigger OnLookup(var Text: Text): Boolean
            // var
            //     ReasonCodeRec: Record "Reason Code";
            //     ReasonCodePage: Page "Reason Codes";
            //     P: Page "Sales Order";
            // begin
            //     ReasonCodeRec.SetRange(Blocked, false);
            //     ReasonCodePage.LookupMode(true);
            //     ReasonCodePage.SetTableView(ReasonCodeRec);

            //     if ReasonCodePage.RunModal() = Action::LookupOK then begin
            //         ReasonCodePage.GetRecord(ReasonCodeRec);
            //         Rec.Validate("Reason Code", ReasonCodeRec.Code);
            //         Rec.Modify(true);
            //         CurrPage.Update();
            //     end;

            //     exit(true);

            //     if Page.RunModal(Page::"Reason Codes", ReasonCodeRec) = Action::LookupOK then begin
            //         Rec.Validate("Reason Code", ReasonCodeRec.Code);
            //         CurrPage.Update();
            //     end;
            //     exit(true);
            // end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}