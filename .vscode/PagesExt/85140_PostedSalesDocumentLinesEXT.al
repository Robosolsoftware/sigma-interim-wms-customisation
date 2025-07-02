// pageextension 85140 PostedSalesDocumentLines extends "Get Post.Doc - S.InvLn Subform"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         // Add changes to page actions here
//     }
//     trigger OnOpenPage()
//     begin
//         Rec.SETFILTER(Quantity, '>0');
//     end;

//     var
//         myInt: Integer;
// }