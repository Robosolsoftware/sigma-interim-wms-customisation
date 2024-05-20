pageextension 85085 whseShipmentCardRBE extends "Warehouse Shipment"
{
    layout
    {
        addlast(General)
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
        addbefore(Shipping)
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

        addlast(General)
        {
            field("Requested By"; rec."Requested By")
            {
                ApplicationArea = all;
                //Visible = false;
            }
            field("Shipped By"; rec."Shipped By")
            {
                ApplicationArea = all;
            }
            field("Time of Shipment"; rec."Time of Shipment")
            {
                ApplicationArea = all;
            }
            field("Receipted By"; rec."Receipted By")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Time of Receipt"; rec."Time of Receipt")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Vehicle Reg No."; rec."Vehicle Reg No.")
            {
                ApplicationArea = all;
            }
            field("Pallet ID"; rec."Pallet ID")
            {
                ApplicationArea = all;
                Caption = 'No. of Pallets';
                //Visible=false;
            }

            field(Comments; rec.Comments)
            {
                ApplicationArea = all;
                //Visible = false;
            }
            field("Seal No."; rec."Seal No.")
            {
                ApplicationArea = all;

            }
            field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = All;
                MultiLine = true;
            }

        }

        modify(Control1900383207)
        {
            Visible = true;
        }
    }
    var
        G_MiscellaneousCharges: Codeunit "Miscellaneous Charges";
}