pageextension 70160 "SC Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        // Add changes to page layout here
        modify(Code)
        {
            Editable = G_Editable;
        }
        modify(Name)
        {
            Editable = G_Editable;

        }
        modify("Internet Address")
        {
            Editable = G_Editable;

        }
        modify("Account No.")
        {
            Editable = G_Editable;

        }
        modify("Coupled to Dataverse")
        {
            Editable = G_Editable;

        }
        modify("Coupled to CRM")
        {
            Editable = G_Editable;

        }
        addafter(Name)
        {
            field("Restrict CD & Fridge"; Rec."Restrict CD & Fridge")
            {
                ApplicationArea = All;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    L_UserSetup: Record "User Setup";
                begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Edit Master Data", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to edit')

                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        G_Editable: Boolean;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";
    begin
        G_Editable := true;
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        L_UserSetup.SetRange("Edit Master Data", true);
        if not L_UserSetup.FindFirst() then begin
            if Rec.Status <> Rec.Status::Open then
                G_Editable := false;
        end;
    end;

    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";
    begin
        G_Editable := true;
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        L_UserSetup.SetRange("Edit Master Data", true);
        if not L_UserSetup.FindFirst() then begin
            if Rec.Status <> Rec.Status::Open then
                G_Editable := false;
        end;
    end;
}