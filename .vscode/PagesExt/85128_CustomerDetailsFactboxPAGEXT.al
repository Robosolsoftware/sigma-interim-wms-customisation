pageextension 85128 "Cust. Details" extends "Customer Details FactBox"
{
    layout
    {
        addafter("Payment Terms Code")
        {
            field(Hospital; Rec.Hospital)
            {
                ApplicationArea = All;
                Caption = 'Exempt from Credit check / Overdue check';
                Visible = false;
            }
            field("Credit limit Exceeded"; Rec."Credit limit Exceeded")
            {
                ApplicationArea = All;
                Visible = false;

            }
            field("Overdue Balance"; Rec."Overdue Balance")
            {
                ApplicationArea = All;
                Visible = false;

            }
        }
    }
}