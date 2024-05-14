pageextension 70133 WhseRcpSubformRbe extends "Whse. Receipt Subform"
{
    layout
    {
        modify("Variant Code")
        {
            Visible = true;
        }
        moveafter(Description; "Variant Code")

        addafter(Description)
        {
            field("Warehouse Class Code"; Rec."Warehouse Class Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Brand; Rec.Brand)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Pack Size"; Rec."Pack Size")

            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = all;
                Editable = false;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ItemTrackingLines)
        {

            action(delete)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    L_TrackingSpecification: Record "Tracking Specification";
                begin
                    L_TrackingSpecification.Reset();
                    L_TrackingSpecification.SetRange("Source Type", 39);
                    L_TrackingSpecification.SetRange("Source Subtype", 1);
                    L_TrackingSpecification.SetRange("Source ID", Rec."Source No.");
                    L_TrackingSpecification.SetRange("Source Ref. No.", Rec."Source Line No.");
                    L_TrackingSpecification.SetRange(Positive, true);
                    if L_TrackingSpecification.FindSet() then begin
                        repeat
                            L_TrackingSpecification.Validate("Variant Code", '');
                            L_TrackingSpecification.Modify();
                        until L_TrackingSpecification.Next() = 0;
                    end;
                end;
            }
            // action("Assign Variant")
            // {
            //     ApplicationArea = All;
            //     Image = Insert;
            //     // PromotedCategory = Process;
            //     // Promoted = true;

            //     trigger OnAction()
            //     var
            //         L_CustomVariant: Record "Custom Variant";
            //         Page_CustomVariantPage: Page "Custom Variant List";
            //         L_VariantCode: Record "Item Variant";
            //         L_Item: Record Item;
            //     begin
            //         L_Item.Reset();
            //         L_Item.SetRange("No.", Rec."Item No.");
            //         if L_Item.FindFirst() then begin
            //             if L_Item."Variant Mandatory if Exists" <> L_Item."Variant Mandatory if Exists"::No then
            //                 Rec.TestField("Variant Code", '')
            //             else
            //                 Error('Variant not required');
            //         end;


            //         L_CustomVariant.Reset();
            //         L_CustomVariant.SetRange("Item No.", Rec."Item No.");
            //         if L_CustomVariant.FindSet() then
            //             L_CustomVariant.DeleteAll();

            //         L_VariantCode.Reset();
            //         L_VariantCode.SetRange("Item No.", Rec."Item No.");
            //         if L_VariantCode.FindSet() then
            //             repeat
            //                 L_CustomVariant.Init();
            //                 L_CustomVariant."Item No." := L_VariantCode."Item No.";
            //                 L_CustomVariant.Code := L_VariantCode.Code;
            //                 L_CustomVariant.Description := L_VariantCode.Description;
            //                 L_CustomVariant.Insert();
            //             until L_VariantCode.Next() = 0;

            //         Clear(Page_CustomVariantPage);
            //         L_CustomVariant.Reset();
            //         L_CustomVariant.SetRange("Item No.", Rec."Item No.");
            //         if L_CustomVariant.FindSet() then begin
            //             Page_CustomVariantPage.GetOrderDetails(Rec."Source Document", Rec."Source No.");
            //             Page_CustomVariantPage.SetTableView(L_CustomVariant);
            //             Page_CustomVariantPage.Run();
            //         end;


            //     end;

            // }
        }
    }

    var
        myInt: Integer;
}