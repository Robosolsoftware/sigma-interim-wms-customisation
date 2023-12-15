pageextension 70150 "SC Vendor Card" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Concerto Vendor No."; Rec."Concerto Vendor No.")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("PO Approval required"; Rec."PO Approval required")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    Clear(G_EnableMinOrderValue);
                    if Rec."PO Approval required" = Rec."PO Approval required"::Yes then
                        G_EnableMinOrderValue := true
                    else
                        G_EnableMinOrderValue := false;
                    CurrPage.Update();
                end;
            }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                //Enabled = G_EnableMinOrderValue;
            }
            // field("PO Approval Value"; Rec."PO Approval Value")
            // {
            //     ApplicationArea = All;
            //     Enabled = G_EnableMinOrderValue;
            // }
        }
        addafter("Purchaser Code")
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
        G_EnableMinOrderValue: Boolean;

    trigger OnAfterGetRecord()
    begin
        Clear(G_EnableMinOrderValue);
        if Rec."PO Approval required" = Rec."PO Approval required"::Yes then
            G_EnableMinOrderValue := true
        else
            G_EnableMinOrderValue := false;
    end;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";
    begin
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        L_UserSetup.SetRange("Edit Master Data", true);
        if not L_UserSetup.FindFirst() then begin
            if Rec.Status <> Rec.Status::Open then
                CurrPage.Editable(false);
        end;
    end;
}