page 85012 "Invt. Pick Lines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Warehouse Activity Line";
    SourceTableView = where("Activity Type" = const("Invt. Pick"));
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. to Handle"; Rec."Qty. to Handle")
                {
                    ApplicationArea = All;
                }
                field("Qty. Handled"; Rec."Qty. Handled")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }


        }
    }

    actions
    {
        area(Processing)
        {
            action(AutofillQtyToHandle)
            {
                ApplicationArea = Warehouse;
                Caption = 'Autofill Qty. to Handle';
                Image = AutofillQtyToHandle;
                ToolTip = 'Have the system enter the outstanding quantity in the Qty. to Handle field.';

                trigger OnAction()
                var
                    L_WarehouseActivityLine: Record "Warehouse Activity Line";
                begin
                    L_WarehouseActivityLine.Reset();
                    CurrPage.SetSelectionFilter(L_WarehouseActivityLine);
                    if L_WarehouseActivityLine.FindSet() then begin
                        L_WarehouseActivityLine.AutofillQtyToHandle(L_WarehouseActivityLine);
                        Message('Completed..');
                    end;
                end;
            }
            action("Batch Post")
            {
                ApplicationArea = Warehouse;
                Caption = 'Batch Post';
                Ellipsis = true;
                Image = PostOrder;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    L_WarehouseActivityLine: Record "Warehouse Activity Line";
                    WhseActPostYesNo: Codeunit "Whse.-Act.-Post (Yes/No)";
                    BatchInventoryPickPost: Codeunit "Batch Inventory Pick Post";
                begin
                    L_WarehouseActivityLine.Reset();
                    CurrPage.SetSelectionFilter(L_WarehouseActivityLine);
                    if L_WarehouseActivityLine.FindSet() then begin
                        repeat
                            BatchInventoryPickPost.IsBatchPost(true);
                            WhseActPostYesNo.Run(L_WarehouseActivityLine);
                        until L_WarehouseActivityLine.Next() = 0;
                    end;
                end;
            }
        }
    }
}