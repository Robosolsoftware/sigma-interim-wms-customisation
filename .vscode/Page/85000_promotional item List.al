page 85000 "Promotional Item List"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Price List Line";
    Editable = false;
    Caption = 'Daily Promotions';

    layout
    {
        area(Content)
        {
            repeater("Special Promotions")
            {
                Editable = false;
                field("Product No."; Rec."Product No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}