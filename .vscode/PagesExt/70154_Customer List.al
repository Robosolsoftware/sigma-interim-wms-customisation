pageextension 70154 "SC Customer List" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("KNAPP Customer"; Rec."KNAPP Customer")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("QAU Approved"; Rec."QAU Approved")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Reports)
        {
            action("Update Customer Number")
            {
                ApplicationArea = All;
                Image = Action;
                trigger OnAction()
                var
                    L_Customer: Record Customer;
                    M_Customer: Record Customer;
                begin
                    L_Customer.Reset();
                    //CurrPage.SetSelectionFilter(L_Customer);
                    L_Customer.SetFilter("Concerto Customer No.", '<>%1', '');
                    if L_Customer.FindSet() then begin
                        repeat
                            M_Customer.Reset();
                            M_Customer.SetRange("No.", L_Customer."No.");
                            if M_Customer.FindFirst() then begin
                                M_Customer.Rename(L_Customer."Concerto Customer No.");
                                M_Customer.Modify();
                            end;
                        until L_Customer.Next() = 0;
                    end;

                end;
            }
        }
    }

    var
        myInt: Integer;
}