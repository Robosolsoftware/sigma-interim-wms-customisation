pageextension 85055 "SC Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Location Code")
        {
            field("Inv. Pick No."; Rec."Inv. Pick No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter("Update Document")
        {
            action("Post Item Reclassification")
            {
                ApplicationArea = All;
                Image = PostingEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    L_SalesShipmentHeader: Record "Sales Shipment Header";
                    L_KnappLocation: Record Location;
                    L_Zone: Record Zone;
                    CU_PostItemReclass: Codeunit "Post Item Reclassification";
                begin
                    if Confirm('Do you really want to Post Item Reclassification for selected orders?') then begin
                        Clear(L_SalesShipmentHeader);
                        L_SalesShipmentHeader := Rec;
                        CurrPage.SetSelectionFilter(L_SalesShipmentHeader);

                        L_KnappLocation.Reset();
                        L_KnappLocation.SetRange("Knapp Location", true);
                        if L_KnappLocation.FindFirst() then begin
                            L_SalesShipmentHeader.SetFilter("Location Code", L_KnappLocation.Code);
                            if L_SalesShipmentHeader.FindSet() then begin
                                repeat
                                    L_Zone.Reset();
                                    L_Zone.SetFilter("Replenishment Priority", '<>0');
                                    L_Zone.SetCurrentKey("Replenishment Priority");
                                    L_Zone.Ascending(true);
                                    if L_Zone.FindFirst() then
                                        CU_PostItemReclass.PostItemReclassification(L_KnappLocation.Code, L_Zone."Location Code", L_SalesShipmentHeader);
                                until L_SalesShipmentHeader.Next() = 0;
                            end;
                        end;
                    end;
                end;
            }
        }
    }
}