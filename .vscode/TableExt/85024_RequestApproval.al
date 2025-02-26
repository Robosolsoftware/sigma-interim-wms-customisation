tableextension 85024 "Ext Request To Approve" extends 454
{
    fields
    {
        field(85024; "Customer No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Sell-to Customer No." where("No." = field("Document No.")));
        }
        field(85025; "Min Order Value"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Min Order Value" where("No." = field("Document No.")));
        }
        field(85026; "Customer Type"; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Shortcut Dimension 3 Code" where("No." = field("Document No.")));
        }
        field(85027; "Running Total MOV"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}