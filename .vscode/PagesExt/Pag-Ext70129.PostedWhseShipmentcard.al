pageextension 70129 PostedwhseShipmentCard extends "Posted Whse. Shipment"
{
    layout
    {

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
                Editable = false;
            }
            field("Shipped By"; rec."Shipped By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Time of Shipment"; rec."Time of Shipment")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Receipted By"; rec."Receipted By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Time of Receipt"; rec."Time of Receipt")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Vehicle Reg No."; rec."Vehicle Reg No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pallet ID"; rec."Pallet ID")
            {
                ApplicationArea = all;
                Caption = 'No. of Pallets';
                Editable = false;
            }



            field(Comments; rec.Comments)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Seal No."; rec."Seal No.")
            {
                ApplicationArea = all;
                Editable = false;
            }

        }

        modify(Control1900383207)
        {
            Visible = true;
        }
    }
}