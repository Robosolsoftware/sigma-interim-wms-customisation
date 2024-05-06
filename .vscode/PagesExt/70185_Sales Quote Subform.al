pageextension 70185 "SC Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Quantity)
        {
            field("Total Physical"; Rec."Total Physical")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Total Inventory';
                DecimalPlaces = 0 : 5;
                Caption = 'Total Physical';
            }
            field("Total Allocated on SO"; Rec."Total Allocated on SO")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Sum of Outstanding Qty on SO across ALL Locations';
                DecimalPlaces = 0 : 5;
                Caption = 'Total Allocated on SO';
            }
            field(Physical; Rec.Physical)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Qty available in the selected location';
                DecimalPlaces = 0 : 5;
                Caption = 'Physical';
            }

            field("Allocated on SO"; Rec."Allocated on SO")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Sum of Outstanding SO Qty in the selected location';
                DecimalPlaces = 0 : 5;
                Caption = 'Allocated on SO';
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