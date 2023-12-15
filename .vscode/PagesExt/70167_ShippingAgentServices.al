pageextension 70167 ShippingAgentServices extends "Shipping Agent Services"
{
    layout
    {
        modify(Code)
        {
            Editable = G_Editable;
        }
        modify(Description)
        {
            Editable = G_Editable;

        }
        modify("Shipping Time")
        {
            Editable = G_Editable;

        }
        modify("Base Calendar Code")
        {
            Editable = G_Editable;

        }
        modify(CustomizedCalendar)
        {
            Editable = G_Editable;

        }
        addlast(Control1)
        {
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