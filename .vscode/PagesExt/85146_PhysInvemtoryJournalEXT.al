pageextension 85146 PhysicalInventoryJournalExt extends "Phys. Inventory Journal"
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
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}