pageextension 70140 "SC Sales Order Card" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addfirst(factboxes)
        {
            part("Item Variants Details"; "Item Variants Details")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Item No." = field("No.");
            }
            part("Lot-Number-by-Item"; "Lot-Number-by-Item")
            {
                SubPageLink = "Item No." = field("No.");
                ApplicationArea = all;
                Provider = SalesLines;
            }
        }
        addlast("Invoice Details")
        {
            field("Default Bank"; Rec."Default Bank")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("Warehouse Shipment Exist"; Rec."Warehouse Shipment Exist")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Visible = G_DimensionVisibility;
                Editable = false;
            }
            field("Send By"; Rec."Send By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Created At';
            }
            field(SystemCreatedBy; G_Functions.GetUserName(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Created By';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified At';
            }
            field(SystemModifiedBy; G_Functions.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'System Modified By';
            }
            field("KNAPP Customer"; Rec."KNAPP Customer")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Min Order Value"; Rec."Min Order Value")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter(SalesLines)
        {
            part("Promotional Item List"; "Promotional Item List")
            {
                ApplicationArea = All;
                SubPageLink = "Price List Code" = field("Sales Price List Code");
            }
        }
        addbefore("Invoice Details")
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

    }


    actions
    {
        // Add changes to page actions here
        addafter(Release)
        {
            action("Update Variant On Lines")
            {
                ApplicationArea = All;
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    L_SalesLine: Record "Sales Line";
                    CustomeCodeunit: Codeunit "SC Events & Subscriber";
                    RemQty: Decimal;
                    QtyToApply: Decimal;
                    L_ItemVariant: Record "Item Variant";
                    L_Count: Integer;
                    L_NewLineRequired: Boolean;
                    L_Item: Record Item;
                    Window: Dialog;
                    Counter: Integer;
                    Text005: TextConst ENU = 'Updating the Variant Code...\\', ENG = 'Updating the Variant Code...\\';
                    Text006: TextConst ENU = 'Progress', ENG = 'Progress';
                    NoOfRecords: Integer;
                begin
                    Clear(NoOfRecords);
                    Clear(Counter);
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", Rec."Document Type");
                    L_SalesLine.SetRange("Document No.", Rec."No.");
                    L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    L_SalesLine.SetFilter("Variant Code", '%1', '');
                    L_SalesLine.SetRange("Variant Code mandatory", true);
                    L_SalesLine.SetFilter(Quantity, '>%1', 0);
                    L_SalesLine.SetFilter("Location Code", '<>%1', '');
                    if L_SalesLine.FindSet() then begin
                        NoOfRecords := L_SalesLine.Count;
                        Window.OPEN(Text005 + Text006 + ' @1@@@@@@@@@@@@@\' + L_SalesLine.FIELDCAPTION("No.") + ' #3##########');
                        repeat
                            Counter += 1;
                            Window.UPDATE(1, ROUND(Counter / NoOfRecords * 10000, 1));
                            Window.UPDATE(3, L_SalesLine."No.");

                            Clear(L_NewLineRequired);
                            Clear(RemQty);
                            if CustomeCodeunit.CheckTotalAvailablityQty(L_SalesLine) > 0 then begin
                                //Total required quantity 
                                RemQty := L_SalesLine.Quantity;

                                //Update Availbale Qty on Item Variant Table(This is temproray Calculating at run time)
                                CustomeCodeunit.UpdateAvaibleQty(L_SalesLine);

                                //Without Zero and based on priority++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                //Set PriorityWithoutZero++
                                Clear(L_ItemVariant);
                                L_ItemVariant.Reset();
                                CustomeCodeunit.SetPriorityWithoutZero(L_SalesLine, L_ItemVariant);
                                Clear(L_Count);
                                L_Count := L_ItemVariant.Count;

                                //Process to update variant code and create new line if required++
                                if L_Count > 0 then begin
                                    while (RemQty > 0) AND (L_Count > 0) do begin
                                        if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) > 0 then begin
                                            if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) >= RemQty then begin
                                                if L_NewLineRequired = false then begin
                                                    L_SalesLine.Validate("Variant Code", L_ItemVariant.Code);
                                                    L_SalesLine.Validate("Original Quantity", L_SalesLine.Quantity);
                                                    L_SalesLine.Validate("Variant Created By", L_SalesLine."Line No."); //Original Line Number
                                                    L_SalesLine.Modify();
                                                    RemQty := RemQty - L_SalesLine.Quantity;
                                                end else begin
                                                    Clear(QtyToApply);
                                                    if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) >= RemQty then
                                                        QtyToApply := RemQty
                                                    else
                                                        QtyToApply := CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);

                                                    CustomeCodeunit.InsertNewSalesLine(L_SalesLine, L_ItemVariant, QtyToApply);
                                                    RemQty := RemQty - CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);
                                                end;
                                            end else begin
                                                if L_NewLineRequired = false then begin
                                                    L_SalesLine.Validate(Quantity, CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant));
                                                    L_SalesLine.Validate("Variant Code", L_ItemVariant.Code);
                                                    L_SalesLine.Validate("Original Quantity", RemQty);
                                                    L_SalesLine.Modify();
                                                    RemQty := RemQty - L_SalesLine.Quantity;
                                                    L_NewLineRequired := true;
                                                end else begin
                                                    Clear(QtyToApply);
                                                    if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) >= RemQty then
                                                        QtyToApply := RemQty
                                                    else
                                                        QtyToApply := CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);
                                                    CustomeCodeunit.InsertNewSalesLine(L_SalesLine, L_ItemVariant, QtyToApply);
                                                    RemQty := RemQty - CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);
                                                end;
                                            end;
                                        end;

                                        L_Count := L_Count - 1;
                                        L_ItemVariant.Next();
                                    end;
                                end;
                                //Without Zero and based on priority--------------------------------------------------------------------

                                //With Zero and based on priority++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                //Set PriorityWitZero++
                                Clear(L_ItemVariant);
                                L_ItemVariant.Reset();
                                CustomeCodeunit.SetPriorityWithZeroandHigherQty(L_SalesLine, L_ItemVariant);
                                Clear(L_Count);
                                L_Count := L_ItemVariant.Count;

                                //Process to update variant code and create new line if required++
                                if L_Count > 0 then begin
                                    while (RemQty > 0) AND (L_Count > 0) do begin
                                        if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) > 0 then begin
                                            if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) >= RemQty then begin
                                                if L_NewLineRequired = false then begin
                                                    L_SalesLine.Validate("Variant Code", L_ItemVariant.Code);
                                                    L_SalesLine.Validate("Original Quantity", RemQty);
                                                    L_SalesLine.Modify();
                                                    RemQty := RemQty - L_SalesLine.Quantity;
                                                end else begin
                                                    Clear(QtyToApply);
                                                    if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) >= RemQty then
                                                        QtyToApply := RemQty
                                                    else
                                                        QtyToApply := CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);

                                                    CustomeCodeunit.InsertNewSalesLine(L_SalesLine, L_ItemVariant, QtyToApply);
                                                    RemQty := RemQty - CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);
                                                end;
                                            end else begin
                                                if L_NewLineRequired = false then begin
                                                    L_SalesLine.Validate(Quantity, CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant));
                                                    L_SalesLine.Validate("Variant Code", L_ItemVariant.Code);
                                                    L_SalesLine.Validate("Original Quantity", RemQty);
                                                    L_SalesLine.Modify();
                                                    RemQty := RemQty - L_SalesLine.Quantity;
                                                    L_NewLineRequired := true;
                                                end else begin
                                                    Clear(QtyToApply);
                                                    if CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant) >= RemQty then
                                                        QtyToApply := RemQty
                                                    else
                                                        QtyToApply := CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);
                                                    CustomeCodeunit.InsertNewSalesLine(L_SalesLine, L_ItemVariant, QtyToApply);
                                                    RemQty := RemQty - CustomeCodeunit.CheckTotalAvailablityQtyVariantWise(L_SalesLine, L_ItemVariant);
                                                end;
                                            end;
                                        end;

                                        L_Count := L_Count - 1;
                                        L_ItemVariant.Next();
                                    end;
                                end;
                                //With Zero and based on priority--------------------------------------------------------------------


                            end else
                                if not Confirm(StrSubstNo('Inventory does not exist for item number %1 line number. Click Yes to continue without variant code ', L_SalesLine."No.", L_SalesLine."Line No."), false) then
                                    Error('')
                        until L_SalesLine.Next() = 0;
                        Window.CLOSE;
                    end;
                end;
            }
        }

        // modify(Release)
        // {
        //     trigger OnAfterAction()
        //     var
        //         L_SalesLine: Record "Sales Line";
        //     begin
        //         //GHST Customization++
        //         L_SalesLine.Reset();
        //         L_SalesLine.SetRange("Document No.", Rec."No.");
        //         L_SalesLine.SetRange("Document Type", Rec."Document Type");
        //         L_SalesLine.SetFilter("Variant Code", '%1', '');
        //         L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
        //         if not L_SalesLine.IsEmpty then
        //             Error('Please Assign Variant Code Item No %1 line No %2', L_SalesLine."No.", L_SalesLine."Line No.");

        //     end;
        // }
        modify(SendApprovalRequest)
        {
            trigger OnAfterAction()
            var
                L_SalesLine: Record "Sales Line";
            begin
                //GHST Customization++
                L_SalesLine.Reset();
                L_SalesLine.SetRange("Document No.", Rec."No.");
                L_SalesLine.SetRange("Document Type", Rec."Document Type");
                L_SalesLine.SetFilter("Variant Code", '%1', '');
                L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                if not L_SalesLine.IsEmpty then
                    Error('Please Assign Variant Code Item No %1 line No %2', L_SalesLine."No.", L_SalesLine."Line No.");

            end;
        }


    }

    trigger OnOpenPage()
    var
        GenLedgerSetup: Record "General Ledger Setup";
    begin
        Clear(G_DimensionVisibility);
        if GenLedgerSetup.Get() then begin
            if GenLedgerSetup."Shortcut Dimension 3 Code" <> '' then
                G_DimensionVisibility := true;
        end;

    end;

    var
        myInt: Integer;
        cust: Record Customer;
        G_Functions: Codeunit "SC Events & Subscriber";
        G_DimensionVisibility: Boolean;
}