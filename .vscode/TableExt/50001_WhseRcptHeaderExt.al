tableextension 50001 WhseRcptHeaderExt extends "Warehouse Receipt Header"
{
    fields
    {
        field(50001; "Purchase Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Purchase Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Supplier Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Item Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "No. of Items"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Total Order Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Warehouse Class Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Locationcode"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Carrier"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Requested Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Expected Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Expected Delivery Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Booked Pallets"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Lifts"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Loose Boxes"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Curtain Side"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Comments"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Actual Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Actual Receipt Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Transportation No."; Code[20])
        {

        }
        field(50021; "Receipt Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transportation Receipt Status';
            // OptionMembers = " ","Transportation Booked","Goods Arrived","Goods Not Shownup","GRN In Progress",Closed;
            // OptionCaption = ' ,Transportation Booked,Goods Arrived,Goods Not Shownup,GRN In Progress,Closed';

        }
        field(50022; "PO Expected Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "No. of Products"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(50024; CD; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "",Yes,No;
        }
        field(50025; "CD Qty"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Requested Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Sales Return Order"; Code[20])
        {

        }
        field(50028; "Customer No."; Code[20])
        {

        }
        field(50029; "Customer Name"; Text[100])
        {

        }

    }
    trigger OnDelete()
    var
        myInt: Integer;
    begin
        if (rec."Transportation No." <> '') and (Rec."Receipt Status" <> 'Closed') then
            Error('Cannot Delete the Record because either Transportation No. is not blank or Receipt Status is not set to Closed');
    end;




    var
        myInt: Integer;
        Test: Record "Posted Whse. Receipt Header";

}