//Warehouse Shipment process not required in Sigma+++

// reportextension 70543 "SC Create Warehouse Shipment" extends "Create Warehouse Shipment"
// {
//     dataset
//     {
//         // Add changes to dataitems and columns here


//     }

//     requestpage
//     {
//         layout
//         {
//             addlast(Options)
//             {
//                 field(G_SkipBlockedItem; G_SkipBlockedItem)
//                 {
//                     Caption = 'SkipBlockedItem';
//                     ApplicationArea = All;
//                 }
//                 field(G_SkipBlockedCustomer; G_SkipBlockedCustomer)
//                 {
//                     Caption = 'SkipBlockedCustomer';
//                     ApplicationArea = All;
//                 }
//             }
//         }

//         trigger OnOpenPage()
//         begin
//             Error('Please use updated report "Create Warehouse Shipment Version2"');
//         end;
//     }

//     trigger OnPreReport()
//     var
//         ConsolidateWarehouseShipment: Codeunit "Consolidate Warehouse Shipment";
//     begin
//         //ConsolidateWarehouseShipment.ClearGLVariable(G_SkipBlockedItem, G_SkipBlockedCustomer);
//     end;

//     var
//         G_SkipBlockedItem: Boolean;
//         G_SkipBlockedCustomer: Boolean;
// }