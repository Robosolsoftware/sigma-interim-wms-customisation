pageextension 85029 "SC Sales Order Card" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Ship-to Code")
        {
            Editable = G_EditShipping;
        }
        modify("Shipping Agent Code")
        {
            Editable = G_EditShipping;
        }
        modify("Shipping Agent Service Code")
        {
            Editable = G_EditShipping;
        }
        modify("Location Code")
        {
            Editable = G_EditShipping;

            trigger OnAfterValidate()
            var
                L_WareEmployee: Record "Warehouse Employee";
            begin
                if Rec."Location Code" <> '' then begin
                    L_WareEmployee.Reset();
                    L_WareEmployee.SetRange("User ID", UserId);
                    L_WareEmployee.SetRange("Location Code", Rec."Location Code");
                    L_WareEmployee.SetRange("Allow selection on SO", true);
                    if not L_WareEmployee.FindFirst() then
                        Error('You do not have permission to select location code %1', Rec."Location Code");
                end;

            end;
        }
        addfirst(factboxes)
        {
            part("Item Variants Details"; "Item Variants Details")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Item No." = field("No.");
            }
            part(ItemAttributecustomFactbox; ItemAttributecustomFactbox)
            {
                SubPageLink = "Item No." = field("No.");
                ApplicationArea = all;
                Provider = SalesLines;
                Caption = 'Item Attribute';
            }
        }
        addlast("Invoice Details")
        {
            field("Default Bank"; Rec."Default Bank")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Visible = G_DimensionVisibility;
                Editable = false;
            }
            field("Send By"; Rec."Send By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SO Approval Required"; Rec."SO Approval Required")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created At';
            }
            field(SystemCreatedBy; G_MiscellaneousCharges.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified At';
            }
            field(SystemModifiedBy; G_MiscellaneousCharges.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Modified By';
            }
        }
        addafter(SalesLines)
        {
            part("Promotional Item List"; "Promotional Item List")
            {
                ApplicationArea = All;
                SubPageLink = "Price List Code" = field("Sales Price List Code");
                Caption = 'Daily Promotions';
            }
        }
        addbefore("Invoice Details")
        {
            group("Print on Despatch")
            {
                Editable = false;
                field("Delivery Note"; Rec."Delivery Note")
                {
                    ApplicationArea = All;

                }
                field("Collection Note"; Rec."Collection Note")
                {
                    ApplicationArea = All;

                }
                field(Invoice; Rec._Invoice)
                {
                    ApplicationArea = All;

                }
                field("Packing list"; Rec."Packing list")
                {
                    ApplicationArea = All;

                }
                field("Export Checklist"; Rec."Export Checklist")
                {
                    ApplicationArea = All;

                }
                field("Data Logger Sheet"; Rec."Data Logger Sheet")
                {
                    ApplicationArea = All;

                }
                field(Labels; Rec.Labels)
                {
                    ApplicationArea = All;

                }
                field("Extra Documents"; Rec."Extra Documents")
                {
                    ApplicationArea = All;

                }

            }

        }


        addafter("Shipping Agent Service Code")
        {
            field("Weekend Ship. Agnt. Serv. Code"; Rec."Weekend Ship. Agnt. Serv. Code")
            {
                ApplicationArea = All;
                Editable = G_EditShipping;
            }
        }
    }

    actions
    {
        addafter(Release)
        {
            action(CalculateTariff)
            {
                ApplicationArea = All;
                Caption = 'Calculate Tariff';
                Image = Calculate;
                Promoted = True;
                PromotedCategory = Process;
                RunObject = codeunit "Tariff Price Management";
                trigger OnAction()
                begin

                end;
            }
        }
    }


    trigger OnOpenPage()
    var
        GenLedgerSetup: Record "General Ledger Setup";
    begin
        Clear(G_DimensionVisibility);
        if GenLedgerSetup.Get() then begin
            if GenLedgerSetup."Shortcut Dimension 3 Code" <> '' then
                G_DimensionVisibility := true;
        end;
    end;

    trigger OnAfterGetRecord()
    var
        L_SalesLine: Record "Sales Line";
    begin
        Clear(G_EditShipping);
        L_SalesLine.Reset();
        L_SalesLine.SetRange("Document No.", Rec."No.");
        L_SalesLine.SetRange("Document Type", Rec."Document Type");
        if not L_SalesLine.IsEmpty then
            G_EditShipping := false
        else
            G_EditShipping := true;
    end;





    var
        myInt: Integer;
        cust: Record Customer;
        G_MiscellaneousCharges: Codeunit "Miscellaneous Charges";
        G_DimensionVisibility: Boolean;
        G_EditShipping: Boolean;
}