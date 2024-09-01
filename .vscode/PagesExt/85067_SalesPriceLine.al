pageextension 85067 DT_SalesPriceList extends "Price List Lines"
{
    layout
    {
        modify("Amount Type")
        {
            Editable = false;
            Visible = false;
        }

        // Add changes to page layout here
        addafter(Description)
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = DrugTariffVisibility;
            }
        }
        addafter("Unit Price")
        {
            field(Strength; Rec.Strength)
            {
                ApplicationArea = All;
                Visible = DrugTariffVisibility;
            }
            // field("Strength UOM"; Rec."Strength UOM")
            // {
            //     ApplicationArea = All;
            //     Visible = DrugTariffVisibility;
            // }
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
        myInt: Integer;
        P7016: page 7016;
        DrugTariffVisibility: Boolean;

}