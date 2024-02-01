pageextension 70153 "SC Vendor List" extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("PO Approval required"; Rec."PO Approval required")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Concerto Vendor No."; Rec."Concerto Vendor No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Ven&dor")
        {
            action("Update Vendor Number")
            {
                ApplicationArea = All;
                Image = Action;
                trigger OnAction()
                var
                    L_Vendor: Record Vendor;
                    M_Vendor: Record Vendor;
                begin
                    L_Vendor.Reset();
                    //CurrPage.SetSelectionFilter(L_Vendor);
                    L_Vendor.SetFilter("Concerto Vendor No.", '<>%1', '');
                    if L_Vendor.FindSet() then begin
                        repeat
                            M_Vendor.Reset();
                            M_Vendor.SetRange("No.", L_Vendor."No.");
                            if M_Vendor.FindFirst() then begin
                                M_Vendor.Rename(L_Vendor."Concerto Vendor No.");
                                M_Vendor.Modify();
                            end;
                        until L_Vendor.Next() = 0;
                    end;

                end;
            }
        }
    }

    var
        myInt: Integer;
}