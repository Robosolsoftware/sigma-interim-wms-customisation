pageextension 85078 LocationExt extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("GLN Number"; Rec."GLN Number")
            {
                ApplicationArea = All;
            }
            field("Saleable Location"; Rec."Saleable Location")
            {
                ApplicationArea = All;
            }
            field("Sales Return Location"; Rec."Sales Return Location")
            {
                ApplicationArea = All;

            }
        }
        addbefore("Home Page")
        {
            field(Deliveryadd; rec.Deliveryadd)
            {
                Caption = 'Delivery Address 1';
                ApplicationArea = all;
            }
            field(Deliveryadd2; rec.Deliveryadd2)
            {
                Caption = 'Delivery Address 2';
                ApplicationArea = all;
            }
            field("Disable for Lot Fact Box"; Rec."Skip for Lot FB")
            {
                ApplicationArea = all;
                Caption = 'Disable for Lot Fact Box';
            }
        }

        modify(General)
        {
            Editable = L_CurrPageEditable;
        }
        modify("Address & Contact")
        {
            Editable = L_CurrPageEditable;

        }
        modify(Warehouse)
        {
            Editable = L_CurrPageEditable;

        }
        modify(Bins)
        {
            Editable = L_CurrPageEditable;

        }
        modify("Bin Policies")
        {
            Editable = L_CurrPageEditable;

        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        L_CurrPageEditable: Boolean;

    trigger OnOpenPage()
    var
        L_UserSetup: Record "User Setup";
    begin
        Clear(L_CurrPageEditable);
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data" = true then begin
                L_CurrPageEditable := true;
            end else
                L_CurrPageEditable := false;
        end else
            L_CurrPageEditable := false;
    end;

    trigger OnAfterGetRecord()
    var
        L_UserSetup: Record "User Setup";
    begin
        Clear(L_CurrPageEditable);
        L_UserSetup.Reset();
        L_UserSetup.SetRange("User ID", UserId);
        if L_UserSetup.FindFirst() then begin
            if L_UserSetup."Edit Master Data" = true then begin
                L_CurrPageEditable := true;
            end else
                L_CurrPageEditable := false;
        end else
            L_CurrPageEditable := false;
    end;
}