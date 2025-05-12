pageextension 85135 PurchasePriceListLineEXT extends "Purchase Price List Lines"
{
    layout
    {
        addafter(Description)
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = DrugTariffVisibility;
            }
        }
        addafter("Unit Cost")
        {
            field(Strength; Rec.Strength)
            {
                ApplicationArea = All;
                Visible = DrugTariffVisibility;
            }

            field("Base Volume"; Rec."Base Volume")
            {
                ApplicationArea = All;
                Visible = DrugTariffVisibility;
            }
            field("Cost Unit Thereafter"; Rec."Cost Unit Thereafter")
            {
                ApplicationArea = All;
                Visible = DrugTariffVisibility;
            }
            field(Rebate; Rec.Rebate)
            {
                ApplicationArea = All;
                //Visible = DrugTariffVisibility;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    procedure UpdateColumnVisibility()
    var
        myInt: Integer;

    begin
        DrugTariffVisibility := true;
        CurrPage.Update();

    end;

    procedure UpdateColumnVisibilityfalse()
    var
        myInt: Integer;

    begin
        DrugTariffVisibility := false;
        CurrPage.Update();

    end;

    var

        DrugTariffVisibility: Boolean;
}