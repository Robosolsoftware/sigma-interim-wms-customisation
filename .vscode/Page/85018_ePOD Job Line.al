page 85018 "ePOD Job Line"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "ePOD Job Line";
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("ePOD ID"; Rec."ePOD ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ePOD ID for normal job';
                }
                field("Collection ePOD ID"; Rec."Collection ePOD ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ePOD ID for collection job';
                    Visible = false;
                }
                field("BC Invoice Number"; Rec."BC Invoice Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Group; Rec.Group)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Synced to ePOD"; Rec."Synced to ePOD")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Consolidated to Loading Job"; Rec."Consolidated to Loading Job")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    var
        myInt: Integer;
}