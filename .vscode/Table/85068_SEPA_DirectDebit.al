tableextension 85068 "Ext Direct Debit" extends "SEPA Direct Debit Mandate"
{
    trigger OnBeforeDelete()
    begin
        Error('You cannot delete the Direct Debit Mandate');
    end;

    trigger OnBeforeInsert()
    begin
        if NOT Confirm('Do you want to add new mandate', false) then
            IsCheck := true;
    end;

    trigger OnAfterInsert()
    begin
        if IsCheck = true then
            Rec.Delete();
    end;

    var
        IsCheck: Boolean;
}