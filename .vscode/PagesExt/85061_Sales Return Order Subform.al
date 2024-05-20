pageextension 85061 "SC Sales Return Order Subform" extends "Sales Return Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Return Reason Code")
        {
            ShowMandatory = Rec.Type = Rec.Type::Item;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}