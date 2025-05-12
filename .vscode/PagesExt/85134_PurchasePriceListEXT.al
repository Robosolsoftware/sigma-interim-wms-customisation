pageextension 85134 PurchasePriceListEXT extends "Purchase Price List"
{
    layout
    {
        addlast(General)
        {
            field("Special Price Daily"; Rec."Special Price Daily")
            {
                ApplicationArea = All;
            }
            field("Drug Special"; Rec."Drug Special")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    CurrPage.Update();
                    if Rec."Drug Special" = true then
                        CurrPage.Lines.Page.UpdateColumnVisibility();

                    if Rec."Drug Special" = false then
                        CurrPage.Lines.page.UpdateColumnVisibilityfalse();

                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec."Drug Special" = true then
            CurrPage.Lines.Page.UpdateColumnVisibility();

        if Rec."Drug Special" = false then
            CurrPage.Lines.page.UpdateColumnVisibilityfalse();

    end;

    var
        myInt: Integer;
}