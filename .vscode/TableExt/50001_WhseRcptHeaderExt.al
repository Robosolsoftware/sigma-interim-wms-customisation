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
        field(50003; "Supplier Name"; Code[20])
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
        field(50010; "Booking Requested Date"; Date)
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
        field(50020; "Receipt Status"; Option)
        {
            OptionMembers = " ","Transportation Booked","Goods Arrived","Goods Not Shownup","GRN In Progress";
            OptionCaption = ' ,Transportation Booked,Goods Arrived,Goods Not Shownup,GRN In Progress';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}