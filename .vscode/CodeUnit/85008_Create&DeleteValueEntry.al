codeunit 85008 CreateValueEntry
{
    Permissions = tabledata "Value Entry" = rmid;

    procedure CreatValueEntry(var ILE: Record "Item Ledger Entry")

     var
       ValueEntry: Record "Value Entry";
       LastEntryNo: Integer;
       ManualCost: Decimal;
       vendor: Record Vendor;
       Item: Record Item;
    begin
       // ILE.Copy(Rec);
        ValueEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");
        if not ValueEntry.IsEmpty() then begin
            Message('Value Entry already exists for ILE No. %1.', ILE."Entry No.");
            exit;
        end;
        ValueEntry.Reset();
        if ValueEntry.FindLast() then
            LastEntryNo := ValueEntry."Entry No." + 1
        else
            LastEntryNo := 1;

        ValueEntry.Init();
        ValueEntry."Entry No." := LastEntryNo;
        ValueEntry."Item Ledger Entry No." := ILE."Entry No.";
        ValueEntry."Item No." := ILE."Item No.";
        ValueEntry.Description := ILE.Description;
        ValueEntry."Posting Date" := ILE."Posting Date";
        ValueEntry."Document No." := ILE."Document No.";
        ValueEntry."Item Ledger Entry Type" := ILE."Entry Type";
        ValueEntry."Document Type" := ILE."Document Type";
        ValueEntry."Entry Type" := ValueEntry."Entry Type"::"Direct Cost";
        ILE.CalcFields("Cost Amount (Expected)","Sales Amount (Actual)");
        ValueEntry."Sales Amount (Actual)" := ILE."Sales Amount (Actual)";
         ValueEntry."Cost Amount (Expected)" := 333.84;    //To be changed
        ValueEntry."Item Ledger Entry Quantity" := ILE.Quantity;
        ValueEntry."Valued Quantity" := ILE.Quantity;
        if ILE."Document Type" = ILE."Document Type"::"Purchase Invoice" then begin
            ValueEntry."Invoiced Quantity" := ILE."Invoiced Quantity";
        end else begin
            ValueEntry."Invoiced Quantity" := 0;
        end;
        ValueEntry."External Document No." := ILE."External Document No.";
        ValueEntry."Source Type" := ILE."Source Type";
        ValueEntry."Source No." := ILE."Source No.";
        ValueEntry."Location Code" := ILE."Location Code";
        ValueEntry."Document Line No." := ILE."Document Line No.";

        vendor.Reset();
        vendor.SetRange("No.", ILE."Source No.");
        if vendor.FindFirst() then begin
            ValueEntry."Gen. Bus. Posting Group" := vendor."Gen. Bus. Posting Group";
            ValueEntry."Source Posting Group" := vendor."Vendor Posting Group";
        end;
        Item.Reset();
        Item.SetRange("No.", ILE."Item No.");
        if Item.FindFirst() then begin
            ValueEntry."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
            ValueEntry."Cost per Unit" := 9.27;   //To be changed
            ValueEntry."Inventory Posting Group" := Item."Inventory Posting Group";
            
        end;

        ValueEntry."Drop Shipment" := ILE."Drop Shipment";

        ValueEntry.Insert(true);
        Message('Value Entry inserted manually for ILE No. %1', ILE."Entry No.");
    end;

    procedure DeleteVE(var VE: Record "Value Entry")
    var 
     valueEntry:Record "Value Entry";
 
    begin
         valueEntry.get(VE."Entry No.");
         valueEntry.Delete(true);
         Message('Value Entry Deleted');
    end;

}
      
