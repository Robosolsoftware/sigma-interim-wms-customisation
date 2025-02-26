pageextension 85127 "Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("MLD %"; Rec."MLD %")
            {
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    Rec.TestField("Quantity Shipped", 0);
                    if Rec."Line Discount %" = 0 then begin
                        Rec.Validate("Line Discount %", Rec."MLD %");
                        Rec."Original Line Discount" := 0;
                        Rec.Modify();
                    end else begin
                        Rec."Original Line Discount" := Rec."Line Discount %";
                        Rec.Validate("Line Discount %", Rec."MLD %");
                        Rec.Modify();
                    end;
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
}