tableextension 85000 WhseRcptHeaderExt extends "Warehouse Receipt Header"
{
    fields
    {
        field(85001; "Purchase Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85002; "Purchase Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(85003; "Supplier Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85005; "No. of Items"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'No. Of Items On PO';
        }
        field(85006; "Total Order Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Order Qty On PO';
        }
        field(85008; "Locationcode"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85009; "Carrier"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85010; "Requested Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(85011; "Expected Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(85012; "Expected Delivery Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(85013; "Booked Pallets"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85014; "Lifts"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85015; "Loose Boxes"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85016; "Curtain Side"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(85017; "Comments"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85018; "Actual Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(85019; "Actual Receipt Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(85020; "Transportation No."; Code[20])
        {

        }
        field(85021; "Receipt Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transportation Receipt Status';
            // OptionMembers = " ","Transportation Booked","Goods Arrived","Goods Not Shownup","GRN In Progress",Closed;
            // OptionCaption = ' ,Transportation Booked,Goods Arrived,Goods Not Shownup,GRN In Progress,Closed';

        }
        field(85022; "PO Expected Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(85023; "No. of Products"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(85024; CD; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "",Yes,No;
        }
        field(85025; "CD Qty"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(85026; "Requested Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(85027; "Sales Return Order"; Code[20])
        {

        }
        field(85028; "Customer No."; Code[20])
        {

        }
        field(85029; "Customer Name"; Text[100])
        {

        }
        field(85030; "Source Document"; Enum "Warehouse Activity Source Document")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Receipt Line"."Source Document" where("No." = field("No.")));
        }
        field(85031; "Whs. Receipt No. of Items"; Integer)
        {
            Caption = 'No. Of Items';
            FieldClass = FlowField;
            CalcFormula = count("Warehouse Receipt Line" where("No." = field("No.")));
        }
        field(85032; "Whs. Receipt Total Order Qty"; Decimal)
        {
            Caption = 'Total Order Qty';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Receipt Line".Quantity where("No." = field("No.")));
        }

    }
    trigger OnDelete()
    var
        myInt: Integer;
    begin
        if (rec."Transportation No." <> '') and (Rec."Receipt Status" <> 'Suspend') then
            Error('Cannot Delete the Record because either Transportation No. is not blank or Receipt Status is not set to Suspend');
    end;




    var
        myInt: Integer;
        Test: Record "Posted Whse. Receipt Header";

}