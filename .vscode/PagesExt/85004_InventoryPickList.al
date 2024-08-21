pageextension 85004 InventoryPickListExt extends "Inventory Picks"
{
    layout
    {
        addafter("Location Code")
        {
            field("Whs. Class Code type"; Rec."Whs. Class Code type")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Warehouse Class Code Type';
            }
        }
        addafter("No. of Lines")
        {
            field("System CreatedAt"; rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                caption = 'Created At';

            }
            field("System CreatedBy"; GetUserName(rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Caption = 'Created By';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action(AutofillQtyToHandle)
            {
                ApplicationArea = Warehouse;
                Caption = 'Autofill Qty. to Handle';
                Image = AutofillQtyToHandle;
                ToolTip = 'Have the system enter the outstanding quantity in the Qty. to Handle field.';

                trigger OnAction()
                var
                    L_WarehouseActivityHeader: Record "Warehouse Activity Header";
                    L_WarehouseActivityLine: Record "Warehouse Activity Line";
                begin
                    L_WarehouseActivityHeader.Reset();
                    CurrPage.SetSelectionFilter(L_WarehouseActivityHeader);
                    if L_WarehouseActivityHeader.FindSet() then begin
                        repeat
                            L_WarehouseActivityLine.Reset();
                            L_WarehouseActivityLine.SetRange("Activity Type", L_WarehouseActivityHeader.Type);
                            L_WarehouseActivityLine.SetRange("No.", L_WarehouseActivityHeader."No.");
                            L_WarehouseActivityLine.SetRange(Breakbulk, false);
                            if L_WarehouseActivityLine.FindSet() then
                                L_WarehouseActivityLine.AutofillQtyToHandle(L_WarehouseActivityLine);
                        until L_WarehouseActivityHeader.Next() = 0;
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
                    L_WarehouseActivityHeader: Record "Warehouse Activity Header";
                    L_WarehouseActivityLine: Record "Warehouse Activity Line";
                    WhseActPostYesNo: Codeunit "Whse.-Act.-Post (Yes/No)";
                    BatchInventoryPickPost: Codeunit "Batch Inventory Pick Post";
                begin
                    L_WarehouseActivityHeader.Reset();
                    CurrPage.SetSelectionFilter(L_WarehouseActivityHeader);
                    if L_WarehouseActivityHeader.FindSet() then begin
                        repeat
                            BatchInventoryPickPost.IsBatchPost(true);
                            L_WarehouseActivityLine.Reset();
                            L_WarehouseActivityLine.SetRange("Activity Type", L_WarehouseActivityLine."Activity Type"::"Invt. Pick");
                            L_WarehouseActivityLine.SetRange("No.", L_WarehouseActivityHeader."No.");
                            L_WarehouseActivityLine.FindSet();
                            WhseActPostYesNo.Run(L_WarehouseActivityLine);
                        until L_WarehouseActivityHeader.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;

    procedure GetUserName(UserSecurityId: Code[50]): Text[100]
    var
        Users: Record User;
    begin
        Users.Reset();
        Users.SetRange("User Security ID", UserSecurityId);
        if Users.FindFirst() then
            exit(Users."Full Name");

    end;
}