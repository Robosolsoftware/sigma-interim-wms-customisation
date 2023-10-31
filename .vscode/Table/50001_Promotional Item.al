// table 50001 "Promotional Item List"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Price List Code"; Code[20])
//         {

//         }
//         field(2; "Line No."; Integer)
//         {

//         }
//         field(3; "Source Type"; Enum "Price Source Type")
//         {

//         }
//         field(4; "Source No."; Code[20])
//         {

//         }
//         field(5; "Parent Source No."; Code[20])
//         {

//         }
//         field(6; "Source ID"; Guid)
//         {

//         }
//         field(7; "Asset Type"; Enum "Price Asset Type")
//         {

//         }
//         field(8; "Asset No."; Code[20])
//         {

//         }
//         field(9; "Variant Code"; Code[10])
//         {

//         }
//         field(10; "Currency Code"; Code[10])
//         {

//         }
//         field(11; "Work Type Code"; Code[10])
//         {

//         }
//         field(12; "Starting Date"; Date)
//         {

//         }
//         field(13; "Ending Date"; Date)
//         {

//         }
//         field(14; "Minimum Quantity"; Decimal)
//         {

//         }
//         field(15; "Unit of Measure Code"; Code[10])
//         {

//         }
//         field(16; "Amount Type"; Enum "Price Amount Type")
//         {

//         }
//         field(17; "Unit Price"; Decimal)
//         {

//         }
//         field(18; "Cost Factor"; Decimal)
//         {

//         }
//         field(19; "Unit Cost"; Decimal)
//         {

//         }
//         field(20; "Line Discount %"; Decimal)
//         {

//         }
//         field(21; "Allow Line Disc."; Boolean)
//         {

//         }
//         field(22; "Allow Invoice Disc."; Boolean)
//         {

//         }
//         field(23; "Price Includes VAT"; Boolean)
//         {

//         }
//         field(24; "VAT Bus. Posting Gr. (Price)"; Code[20])
//         {

//         }
//         field(25; "VAT Prod. Posting Group"; Code[20])
//         {

//         }
//         field(26; "Asset ID"; Guid)
//         {

//         }
//         field(27; "Line Amount"; Decimal)
//         {

//         }
//         field(28; "Price Type"; Enum "Price Type")
//         {

//         }
//         field(29; Description; Text[100])
//         {

//         }
//         field(30; Status; Enum "Price Status")
//         {

//         }
//         field(31; "Direct Unit Cost"; Decimal)
//         {

//         }
//         field(32; "Source Group"; Enum "Price Source Group")
//         {

//         }
//         field(33; "Product No."; Code[20])
//         {

//         }
//         field(34; "Assign-to No."; Code[20])
//         {

//         }
//         field(35; "Assign-to Parent No."; Code[20])
//         {

//         }
//         field(36; "Variant Code Lookup"; Code[10])
//         {

//         }
//         field(37; "Unit of Measure Code Lookup"; Code[10])
//         {

//         }
//         field(70137; "Special Price Daily"; Boolean)
//         {

//         }
//     }

//     keys
//     {
//         key(PK; "Price List Code", "Line No.")
//         {
//             Clustered = true;
//         }
//         key(Key1; "Asset Type", "Asset No.", "Source Type", "Source No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
//         {
//         }
//         key(Key2; "Source Type", "Source No.", "Asset Type", "Asset No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
//         {
//         }
//         key(Key3; Status, "Price Type", "Amount Type", "Currency Code", "Unit of Measure Code", "Source Type", "Source No.", "Asset Type", "Asset No.", "Variant Code", "Starting Date", "Ending Date", "Minimum Quantity")
//         {
//         }
//         key(Key4; Status, "Price Type", "Amount Type", "Currency Code", "Unit of Measure Code", "Source Type", "Parent Source No.", "Source No.", "Asset Type", "Asset No.", "Work Type Code", "Starting Date", "Ending Date", "Minimum Quantity")
//         {
//         }
//         key(Key5; "Product No.", "Asset No.")
//         {
//         }
//     }

//     var
//         myInt: Integer;

//     trigger OnInsert()
//     begin

//     end;

//     trigger OnModify()
//     begin

//     end;

//     trigger OnDelete()
//     begin

//     end;

//     trigger OnRename()
//     begin

//     end;

// }