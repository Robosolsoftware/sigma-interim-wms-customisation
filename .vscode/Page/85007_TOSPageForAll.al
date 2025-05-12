page 85007 "TOS Page"
{
    PageType = List;
    SourceTable = "TOS Page Temp Table";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Caption = 'Shipped Qty.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("SO Qty."; Rec."SO Qty.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Loader: Codeunit "TOS Query Loader";
    begin
        Loader.LoadQueryData(Rec);
    end;

    trigger OnAfterGetRecord()
    var
        L_SalesShipmentLine: Record "Sales Shipment Line";
        L_SalesLine: Record "Sales Line";
    begin
        L_SalesShipmentLine.Reset();
        L_SalesShipmentLine.SetRange("Order No.", Rec."Order No.");
        L_SalesShipmentLine.SetRange("Order Line No.", Rec."Order Line No.");
        L_SalesShipmentLine.SetRange("Posting Date", WorkDate());
        if L_SalesShipmentLine.FindFirst() then begin
            Rec."Sell-to Customer No." := L_SalesShipmentLine."Sell-to Customer No.";
            Rec."No." := L_SalesShipmentLine."No.";
            Rec.Description := L_SalesShipmentLine.Description;
            Rec."Location Code" := L_SalesShipmentLine."Location Code";

        end;

        L_SalesLine.Reset();
        L_SalesLine.SetRange("Document No.", Rec."Order No.");
        L_SalesLine.SetRange("Line No.", rec."Order Line No.");
        L_SalesLine.SetRange("Posting Date", WorkDate());
        if L_SalesLine.FindFirst() then begin
            repeat
                rec."SO Qty." += L_SalesLine.Quantity;
            until L_SalesLine.Next() = 0;
            if Rec."SO Qty." = 0 then begin
                Rec."SO Qty." := Rec.Quantity;
            end;
        end;


    end;
}
