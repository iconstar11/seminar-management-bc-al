// namespace seminarmanagementbcal.seminarmanagementbcal;

// page 50121 "Seminar Registration Card"
// {
//     ApplicationArea = All;
//     Caption = 'Seminar Registration Card';
//     PageType = Card;
//     SourceTable = "Seminar Registration Header";
//     Editable = true;


//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 Caption = 'General';

//                 field("No."; Rec."No.")
//                 {
//                     ToolTip = 'Specifies the value of the No. field.', Comment = '%';
//                 }
//                 field("Seminar Code"; Rec."Seminar Code")
//                 {
//                     ToolTip = 'Specifies the value of the Seminar Code field.', Comment = '%';
//                 }
//                 field("Seminar Name"; Rec."Seminar Name")
//                 {
//                     ToolTip = 'Specifies the value of the Seminar Name field.', Comment = '%';
//                 }
//                 field("Instructor Code"; Rec."Instructor Code")
//                 {
//                     ToolTip = 'Specifies the value of the Instructor Code field.', Comment = '%';
//                 }
//                 field("Instructor Name"; Rec."Instructor Name")
//                 {
//                     ToolTip = 'Specifies the value of the Instructor Name field.', Comment = '%';
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ToolTip = 'Specifies the value of the Status field.', Comment = '%';
//                 }
//                 field("Duration"; Rec."Duration")
//                 {
//                     ToolTip = 'Specifies the value of the Duration field.', Comment = '%';
//                 }
//             }
//         }
//         area(FactBoxes)
//         {
//             part(SeminarCommentSheet; "Seminar Comment Sheet")
//             {
//                 Caption = 'Comments';
//                 ApplicationArea = All;
//                 Visible = true;
//                 Editable = true;
//                 SubPageLink = "No." = field("No.");
//             }
//         }
//     }
// }
