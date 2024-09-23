page 85013 "Knapp Stock to Replenish"
{
    Caption = 'Knapp Stock to Replenish';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Knapp Replenishment";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Variant Description"; Rec."Variant Description")
                {
                    ApplicationArea = All;
                }
                field("Inventory KNAPP"; Rec."Inventory KNAPP")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }



    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
        KnappQuery: Query "Item Ledger Enteries-Qty Knapp";
        // L_KnappQty: Record "Knapp Replenishment";
        L_Item: Record Item;
        L_Itemvariant: Record "Item Variant";
    begin
        Clear(KnappQuery);
        Clear(Counter);
        Counter := 0;
        Progress.OPEN(Text000, Counter);
        if KnappQuery.Open() then begin
            while KnappQuery.Read() do begin
                Rec.Init();

                Rec."Item No." := KnappQuery.Item_No_;
                Rec."Variant Code" := KnappQuery.Variant_Code;
                Rec."Location Code" := KnappQuery.Location_Code;

                IF L_Item.Get(KnappQuery.Item_No_) then
                    Rec."Item Description" := L_Item.Description;

                L_Itemvariant.Reset();
                L_Itemvariant.SetRange("Item No.", Rec."Item No.");
                L_Itemvariant.SetRange(Code, Rec."Variant Code");
                if L_Itemvariant.FindFirst() then
                    Rec."Variant Description" := L_Itemvariant.Description;

                Rec."Inventory KNAPP" := KnappQuery.Quantity;

                if KnappQuery.Quantity <> 0 then
                    Rec.Insert();

                Counter := Counter + 1;
                Progress.UPDATE(1, KnappQuery.Item_No_); // Update the field in the dialog.
                //Progress.Update(2, Counter);

                SLEEP(50);






            end;
            Progress.Close();

        end;



    end;


    var
        Text000: Label 'Processing-- #1';
        Counter: Integer;
        Progress: Dialog;

}