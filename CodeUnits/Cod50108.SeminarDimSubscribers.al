namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Finance.Dimension;

codeunit 50108 SeminarDimSubscribers
{

    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterUpdateGlobalDimCode', '', false, false)]
    local procedure HandleUpdateGlobalDimCode(TableID: Integer; AccNo: Code[20]; NewDimValue: Code[20])
    var
        Seminar: Record Seminar;
        SeminarRoom: Record "Seminar Room";
        Instructor: Record Instructor;
    begin
        case TableID of
            Database::Seminar:
                if Seminar.Get(AccNo) then begin
                    Seminar.ValidateShortcutDimCode(1, NewDimValue); // Global Dim 1
                    Seminar.Modify();
                end;

            Database::"Seminar Room":
                if SeminarRoom.Get(AccNo) then begin
                    SeminarRoom.ValidateShortcutDimCode(1, NewDimValue);
                    SeminarRoom.Modify();
                end;

            Database::Instructor:
                if Instructor.Get(AccNo) then begin
                    Instructor.ValidateShortcutDimCode(1, NewDimValue);
                    Instructor.Modify();
                end;
        end;
    end;

}
