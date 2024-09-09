pageextension 85058 "SC Sales Lines" extends "Sales Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Back Order"; Rec."Back Order")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addlast(Control1)
        {
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



    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        G_MiscellaneousCharges: Codeunit "Miscellaneous Charges";
}