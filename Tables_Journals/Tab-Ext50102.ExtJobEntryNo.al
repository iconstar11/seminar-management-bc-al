namespace seminarmanagementbcal.seminarmanagementbcal;

using Microsoft.Projects.Project.Journal;

tableextension 50102 "Ext.Job Entry No." extends "Job Entry No."
{
    fields
    {
        field(50100; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            DataClassification = ToBeClassified;
        }
    }
}
