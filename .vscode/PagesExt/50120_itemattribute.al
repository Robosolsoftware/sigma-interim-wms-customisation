page 50120 "ItemAttributecustomFactbox"
{

    Caption = 'Item Attribute Custom Factbox';
    InsertAllowed = false;
    PageType = ListPart;
    // SourceTable = "Item Attribute Value Mapping";
    SourceTable = 7351;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Attribute ID"; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    Caption = 'Item Attribute';
                }
                field("Item Attribute Value ID"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    Caption = 'Item Attribute Value';
                }

            }
        }
    }

    actions
    {
    }



    trigger OnFindRecord(Which: Text): Boolean
    begin
        FillTempTable;
        EXIT(Rec.FIND(Which));
    end;

    var

    local procedure FillTempTable()
    var
        RecItemAttValMap: Record "Item Attribute Value Mapping";
        tp: Page "Item List";
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttribute: Record "Item Attribute";
    begin
        Rec.DELETEALL;
        RecItemAttValMap.Reset();
        RecItemAttValMap.SetRange("Table ID", 27);
        RecItemAttValMap.SetRange("No.", Rec.GetRangeMin("Item No."));
        if RecItemAttValMap.FindSet() then begin
            repeat
                // Rec.Reset();
                // Rec.SetRange("Table ID", 27);
                // Rec.SetRange("No.", RecItemAttValMap."No.");
                // Rec.SetRange("Item Attribute ID", RecItemAttValMap."Item Attribute ID");
                // if not rec.FindFirst() then begin

                ItemAttribute.Reset();
                ItemAttribute.SetRange(ID, RecItemAttValMap."Item Attribute ID");
                if ItemAttribute.FindFirst() then begin
                    ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
                    ItemAttributeValue.SetRange(ID, RecItemAttValMap."Item Attribute Value ID");
                    if ItemAttributeValue.FindFirst() then begin
                        Rec.INIT;
                        Rec."Item No." := RecItemAttValMap."No.";
                        Rec."Lot No." := Format(ItemAttribute.Name);
                        Rec."Variant Code" := Format(ItemAttributeValue.Value);
                        Rec.INSERT;
                    end;
                end;

            // end;
            until RecItemAttValMap.Next = 0;
        end;

    end;

    procedure SetItemNo(P_Item: Code[30])
    var
    begin
        Clear(G_ItemNO);
        G_ItemNO := P_Item;
    end;

    var
        G_ItemNO: Code[30];

}


