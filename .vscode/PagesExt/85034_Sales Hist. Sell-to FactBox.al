pageextension 85034 "SC Sales Hist. Sell-to FactBox" extends "Sales Hist. Sell-to FactBox"
{
    layout
    {
        // Add changes to page layout here
        addfirst(Control2)
        {
            field("Last Year Sales Qty."; Rec."Last Year Sales Qty.")
            {
                ApplicationArea = All;
                Caption = 'Last Year Sales Quantity';
                DecimalPlaces = 0 : 5;
                trigger OnDrillDown()
                var
                    LatsyearFromDate: Date;
                    LastyearEndDate: Date;
                    CurrentYear: Integer;

                    L_SalesInvoiceLine: Record "Sales Invoice Line";
                begin
                    Clear(CurrentYear);
                    CurrentYear := Date2DMY(Today, 3);

                    Clear(LatsyearFromDate);
                    Evaluate(LatsyearFromDate, '0101' + Format(CurrentYear - 1));

                    Clear(LastyearEndDate);
                    Evaluate(LastyearEndDate, '1231' + Format(CurrentYear - 1));

                    L_SalesInvoiceLine.Reset();
                    L_SalesInvoiceLine.SetRange("Sell-to Customer No.", Rec."No.");
                    L_SalesInvoiceLine.SetRange(Type, L_SalesInvoiceLine.Type::Item);
                    L_SalesInvoiceLine.SetFilter("Posting Date", '%1..%2', LatsyearFromDate, LastyearEndDate);
                    Page.Run(0, L_SalesInvoiceLine);
                end;
            }

            field("This Year Sales Qty."; Rec."This Year Sales Qty.")
            {
                ApplicationArea = All;
                Caption = 'This Year Sales Quantity';
                DecimalPlaces = 0 : 5;
                trigger OnDrillDown()
                var
                    ThisyearFromDate: Date;
                    ThisyearEndDate: Date;
                    CurrentYear: Integer;

                    L_SalesInvoiceLine: Record "Sales Invoice Line";
                begin
                    Clear(CurrentYear);
                    CurrentYear := Date2DMY(Today, 3);

                    Clear(ThisyearFromDate);
                    Evaluate(ThisyearFromDate, '0101' + Format(CurrentYear));

                    Clear(ThisyearEndDate);
                    Evaluate(ThisyearEndDate, '1231' + Format(CurrentYear));

                    L_SalesInvoiceLine.Reset();
                    L_SalesInvoiceLine.SetRange("Sell-to Customer No.", Rec."No.");
                    L_SalesInvoiceLine.SetRange(Type, L_SalesInvoiceLine.Type::Item);
                    L_SalesInvoiceLine.SetFilter("Posting Date", '%1..%2', ThisyearFromDate, ThisyearEndDate);
                    Page.Run(0, L_SalesInvoiceLine);
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    trigger OnAfterGetRecord()
    var
        FromDate: Date;
        EndDate: Date;
        CurrentYear: Integer;

        L_SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        //Last Year Sales Qty++
        Clear(CurrentYear);
        CurrentYear := Date2DMY(Today, 3);

        Clear(FromDate);
        Evaluate(FromDate, '0101' + Format(CurrentYear - 1));

        Clear(EndDate);
        Evaluate(EndDate, '3112' + Format(CurrentYear - 1));

        L_SalesInvoiceLine.Reset();
        L_SalesInvoiceLine.SetRange("Sell-to Customer No.", Rec."No.");
        L_SalesInvoiceLine.SetRange(Type, L_SalesInvoiceLine.Type::Item);
        L_SalesInvoiceLine.SetFilter("Posting Date", '%1..%2', FromDate, EndDate);
        L_SalesInvoiceLine.CalcSums(Quantity);
        Rec."Last Year Sales Qty." := L_SalesInvoiceLine.Quantity;
        //Last Year Sales Qty --


        //Last Year Sales Qty++
        Clear(CurrentYear);
        CurrentYear := Date2DMY(Today, 3);

        Clear(FromDate);
        Evaluate(FromDate, '0101' + Format(CurrentYear));

        Clear(EndDate);
        Evaluate(EndDate, '3112' + Format(CurrentYear));

        L_SalesInvoiceLine.Reset();
        L_SalesInvoiceLine.SetRange("Sell-to Customer No.", Rec."No.");
        L_SalesInvoiceLine.SetRange(Type, L_SalesInvoiceLine.Type::Item);
        L_SalesInvoiceLine.SetFilter("Posting Date", '%1..%2', FromDate, EndDate);
        L_SalesInvoiceLine.CalcSums(Quantity);
        Rec."This Year Sales Qty." := L_SalesInvoiceLine.Quantity;
        //Last Year Sales Qty --
        Rec.Modify();
    end;
}