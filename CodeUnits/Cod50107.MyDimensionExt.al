namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Finance.Dimension;
using System.Reflection;

codeunit 50107 "My Dimension Ext"
{
    // Subtype = Subscriber;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterSetupObjectNoList', '', false, false)]
    local procedure AddSeminarTables(var TempAllObjWithCaption: Record AllObjWithCaption temporary)
    begin
        TempAllObjWithCaption.Init();
        TempAllObjWithCaption."Object Type" := TempAllObjWithCaption."Object Type"::Table;

        TempAllObjWithCaption."Object ID" := Database::Seminar;
        TempAllObjWithCaption."Object Name" := 'Seminar';
        TempAllObjWithCaption.Insert();

        TempAllObjWithCaption."Object ID" := Database::"Seminar Room";
        TempAllObjWithCaption."Object Name" := 'Seminar Room';
        TempAllObjWithCaption.Insert();

        TempAllObjWithCaption."Object ID" := Database::Instructor;
        TempAllObjWithCaption."Object Name" := 'Instructor';
        TempAllObjWithCaption.Insert();
    end;

}


