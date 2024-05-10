tableextension 70144 "SC Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
        // // Add changes to table fields here
        // field(70142; "Transportation No."; Code[20])
        // {

        // }
        // field(70143; "Receipt Status"; Option)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Transportation Receipt Status';
        //     OptionMembers = " ","Transportation Booked","Goods Arrived","Goods Not Shownup","GRN In Progress",Closed;
        //     OptionCaption = ' ,Transportation Booked,Goods Arrived,Goods Not Shownup,GRN In Progress,Closed';

        // }
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