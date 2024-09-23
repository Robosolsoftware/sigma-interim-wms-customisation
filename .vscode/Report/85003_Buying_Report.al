report 85003 "Buying Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;



    dataset
    {
        dataitem("Buying Worksheet"; "Buying Worksheet")
        {
            column(Item_No_; "Item No.")
            {

            }
            column(Item_Description; "Item Description")
            {

            }
            column(Variant_Code; "Variant Code")
            {

            }
            column(Variant_Description; "Variant Description")
            {

            }
            column(Item_Category_Code; "Item Category Code")
            {


            }
            column(Sub_Category_Code; "Sub Category Code")
            {


            }
            column(Unit_Cost; "Unit Cost")
            {

            }
            column(Unit_Price; "Unit Price")
            {

            }

            column(Inventory_Depot1; "Inventory Depot1")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_IP3; "Inventory IP3")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_IP4; "Inventory IP4")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_KNAPP; "Inventory KNAPP")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_OPD; "Inventory OPD")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_Out__Log_; "Inventory Out. Log.")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_Own__Log; "Inventory Own. Log")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_PSP; "Inventory PSP")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_Quarantine; "Inventory Quarantine")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_SIGCARE; "Inventory SIGCARE")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_SS; "Inventory SS")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Inventory_WHO; "Inventory WHO")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Total_Inventory; "Total Inventory")
            {
                DecimalPlaces = 0 : 5;
            }
            column(Qty__On_SO; "Qty. On SO")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Total_Free_Stock; "Total Free Stock")
            {
                DecimalPlaces = 0 : 5;
            }

            column(Qty_On_PO; "Qty On PO")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Today_Sales_Qty; "Today Sales Qty")
            {
                DecimalPlaces = 0 : 5;

            }
            column(Current_Month_Sales; "Current Month Sales")
            {
                DecimalPlaces = 0 : 5;
            }
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = Excel;
            LayoutFile = 'Buying Report.xlsx';
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
        L_ILEQuery: Query "Item Ledger Enteries-Qty";
        L_Item: Record Item;
        L_ItemVariant: Record "Item Variant";
        L_Item2: Record Item;
        L_Item3: Record Item;
        L_Item4: Record Item;
        L_Item5: Record Item;
        L_Item6: Record Item;
        L_Item7: Record Item;
        L_Item8: Record Item;
        L_Item9: Record Item;
        L_Item10: Record Item;
        L_Item11: Record Item;
        L_Item12: Record Item;
        L_item13: Record item;
        L_Item14: Record Item;
        L_Item15: Record Item;
        Progress: Dialog;
        Counter: Integer;
        Text000: Label 'Processing-- #1';


    begin
        "Buying Worksheet".Reset();
        "Buying Worksheet".DeleteAll();
        Clear(L_ILEQuery);
        Clear(Counter);
        Counter := 0;
        Progress.OPEN(Text000, Counter);
        if L_ILEQuery.Open() then begin
            while L_ILEQuery.Read() do begin



                "Buying Worksheet".Init();
                "Buying Worksheet"."Item No." := L_ILEQuery.Item_No_;

                if L_Item.Get(L_ILEQuery.Item_No_) then
                    L_Item.CalcFields("Qty. on Purch. Order", "Qty. on Sales Order", "Child Category", L_Item.Inventory);

                "Buying Worksheet"."Item Description" := L_Item.Description;
                "Buying Worksheet"."Variant Code" := L_ILEQuery.Variant_Code;
                "Buying Worksheet"."Qty On PO" := L_Item."Qty. on Purch. Order";
                "Buying Worksheet"."Qty. On SO" := L_Item."Qty. on Sales Order";
                "Buying Worksheet"."Unit Cost" := L_Item."Unit Cost";
                "Buying Worksheet"."Unit Price" := L_Item."Unit Price";
                "Buying Worksheet"."Item Category Code" := L_Item."Item Category Code";
                "Buying Worksheet"."Sub Category Code" := L_Item."Child Category";
                "Buying Worksheet"."Total Inventory" := L_Item.Inventory;
                "Buying Worksheet"."Total Free Stock" := L_Item.Inventory - L_Item."Qty. on Sales Order";

                L_ItemVariant.Reset();
                L_ItemVariant.SetRange("Item No.", L_ILEQuery.Item_No_);
                L_ItemVariant.SetRange(Code, L_ILEQuery.Variant_Code);
                IF L_ItemVariant.FindFirst() then
                    "Buying Worksheet"."Variant Description" := L_ItemVariant.Description;

                "Buying Worksheet"."Qty On PO" := L_Item."Qty. on Purch. Order";
                "Buying Worksheet"."Qty. On SO" := L_Item."Qty. on Sales Order";
                "Buying Worksheet"."Item Category Code" := L_Item."Item Category Code";
                "Buying Worksheet"."Sub Category Code" := L_Item."Child Category";

                L_Item2.Reset();
                L_Item2.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item2.SetRange("Location Filter", 'KNAPP');
                L_Item2.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item2.FindFirst() then begin
                    L_Item2.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory KNAPP" := L_Item2.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item2."Sales (Qty.)";


                end;


                L_Item3.Reset();
                L_Item3.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item3.SetRange("Location Filter", 'DEPOT1');
                L_Item3.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item3.FindFirst() then begin
                    L_Item3.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory Depot1" := L_Item3.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item3."Sales (Qty.)";

                end;


                L_Item4.Reset();
                L_Item4.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item4.SetRange("Location Filter", 'IP3');
                L_Item4.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item4.FindFirst() then begin
                    L_Item4.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory IP3" := L_Item4.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item4."Sales (Qty.)";

                end;


                L_Item5.Reset();
                L_Item5.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item5.SetRange("Location Filter", 'IP4');
                L_Item5.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item5.FindFirst() then begin
                    L_Item5.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory IP4" := L_Item5.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item5."Sales (Qty.)";

                end;


                L_Item6.Reset();
                L_Item6.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item6.SetRange("Location Filter", 'OPD');
                L_Item6.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item6.FindFirst() then begin
                    L_Item6.CalcFields(Inventory, "Sales (Qty.)");

                    "Buying Worksheet"."Inventory OPD" := L_Item6.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item6."Sales (Qty.)";

                end;


                L_Item7.Reset();
                L_Item7.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item7.SetRange("Location Filter", 'OUT. LOG.');
                L_Item7.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item7.FindFirst() then begin
                    L_Item7.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory Out. Log." := L_Item7.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item7."Sales (Qty.)";


                end;


                L_Item8.Reset();
                L_Item8.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item8.SetRange("Location Filter", 'OWN LOG.');
                L_Item8.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item8.FindFirst() then begin
                    L_Item8.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory Out. Log." := L_Item8.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item8."Sales (Qty.)";

                end;


                L_Item9.Reset();
                L_Item9.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item9.SetRange("Location Filter", 'PSP');
                L_Item9.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item9.FindFirst() then begin
                    L_Item9.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory PSP" := L_Item9.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item9."Sales (Qty.)";

                end;


                L_Item10.Reset();
                L_Item10.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item10.SetRange("Location Filter", 'QUARANTINE');
                L_Item10.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item10.FindFirst() then begin
                    L_Item10.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory Quarantine" := L_Item10.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item10."Sales (Qty.)";

                end;


                L_Item11.Reset();
                L_Item11.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item11.SetRange("Location Filter", 'SIGCARE');
                L_Item11.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item11.FindFirst() then begin
                    L_Item11.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory SIGCARE" := L_Item11.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item11."Sales (Qty.)";

                end;


                L_Item12.Reset();
                L_Item12.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item12.SetRange("Location Filter", 'SS');
                L_Item12.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_Item12.FindFirst() then begin
                    L_Item12.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory SS" := L_Item12.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item12."Sales (Qty.)";

                end;


                L_item13.Reset();
                L_item13.SetRange("No.", L_ILEQuery.Item_No_);
                L_item13.SetRange("Location Filter", 'WHO');
                L_Item13.SetRange("Variant Filter", L_ILEQuery.Variant_Code);
                If L_item13.FindFirst() then begin
                    L_item13.CalcFields(Inventory, "Sales (Qty.)");
                    "Buying Worksheet"."Inventory WHO" := L_item13.Inventory;
                    //"Buying Worksheet"."Today Sales Qty" := L_Item13."Sales (Qty.)";
                end;

                L_Item14.Reset();
                L_Item14.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item14.SetRange("Date Filter", WorkDate());
                If L_Item14.FindFirst() then begin
                    L_Item14.CalcFields("Sales (Qty.)");
                    "Buying Worksheet"."Today Sales Qty" := L_Item14."Sales (Qty.)";

                end;


                L_Item15.Reset();
                L_Item15.SetRange("No.", L_ILEQuery.Item_No_);
                L_Item15.SetFilter("Date Filter", '%1..%2', CalcDate('-CM'), CalcDate('CM'));
                if L_Item15.FindFirst() then begin
                    L_Item15.CalcFields("Sales (Qty.)");
                    "Buying Worksheet"."Current Month Sales" := L_Item15."Sales (Qty.)";

                end;




                "Buying Worksheet".Insert();

                Counter := Counter + 1;
                Progress.UPDATE(1, L_Item14."No."); // Update the field in the dialog.
                //Progress.Update(2, Counter);

                SLEEP(50);

            end;
            Progress.Close();
        end;




    end;

    var
        myInt: Integer;
}