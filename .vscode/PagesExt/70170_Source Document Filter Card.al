//Warehouse Shipment process not required in Sigma+++ 
// pageextension 70170 "SC Source Document Filter Card" extends "Source Document Filter Card"
// {
//     layout
//     {
//         // Add changes to page layout here
//         addbefore("Do Not Fill Qty. to Handle")
//         {
//             field("Number of Records"; Rec."Number of Records")
//             {
//                 ApplicationArea = All;
//             }
//         }
//     }

//     actions
//     {
//         // Add changes to page actions here
//     }

//     var
//         myInt: Integer;
//         tes: Report "Get Source Documents";
// }