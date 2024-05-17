pageextension 70147 "SC Sales Price List" extends "Sales Price List"
{
    layout
    {
        // Add changes to page layout here
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