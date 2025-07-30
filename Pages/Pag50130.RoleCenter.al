namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.CRM.Contact;
using System.Automation;
using Microsoft.Foundation.Navigate;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using ALProject.ALProject;

page 50130 "Role Center"
{
    ApplicationArea = All;
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            group(Group1)
            {
                part(Part1; "Approvals Activities")
                {
                    ApplicationArea = All;
                }
                // part(Part2; "Student List") 
                // {
                //     ApplicationArea = All;
                // }
            }
        }

    }
    actions
    {
        area(Sections)
        {
            group(SeminarMenu)
            {
                group(Seminars)
                {
                    action(Contact)
                    {
                        Caption = 'Contact';
                        RunObject = page "Contact Card";
                        ApplicationArea = all;
                    }
                    action(Instructor)
                    {
                        Caption = 'Instructors';
                        RunObject = page "Instructor List";
                        ApplicationArea = all;
                    }
                    action(Seminar)
                    {
                        Caption = 'Seminars';
                        RunObject = page "Seminar Card";
                        ApplicationArea = all;
                    }
                    group("Periodic Activities")
                    {
                        action("PeriodicActivities")
                        {
                            Caption = 'Periodic Activities';
                            ApplicationArea = all;

                        }
                    }
                }

                group("Order Processing")
                {
                    action(Registrations)
                    {
                        Caption = 'Registrations';
                        RunObject = page "Seminar Registration LIst";
                        ApplicationArea = all;
                    }
                    action("Sales Invoice")
                    {
                        Caption = 'Sales Invoice';
                        RunObject = page "Sales Invoice";
                        ApplicationArea = all;
                    }
                    group(Reports)
                    {

                    }
                    group(Documents)
                    {

                    }
                    group(History)
                    {
                        action("Posted Registrations")
                        {
                            Caption = 'Posted Registration';
                            RunObject = page "Posted Seminar Reg.Listpart";
                            ApplicationArea = All;
                        }
                        action("Posted Sales Invoice")
                        {
                            Caption = 'Posted Sales Invoice';
                            RunObject = page "Posted Sales Invoice";
                            ApplicationArea = All;
                        }
                        action(Registers)
                        {
                            Caption = 'Registers';
                            RunObject = page "Seminar Registers";
                            ApplicationArea = All;
                        }
                        action(navigate)
                        {
                            Caption = 'Navigate';
                            RunObject = page Navigate;
                            ApplicationArea = All;
                        }

                    }
                }



                group(Setup)
                {
                    action("Seminar Setup")
                    {
                        Caption = 'Seminar Setup';
                        RunObject = page "Seminar Setup";
                        ApplicationArea = All;
                    }
                    action("Seminar Room Setup")
                    {
                        Caption = 'Seminar Room Setup';
                        RunObject = page "Seminar Room card";
                        ApplicationArea = All;
                    }

                }
            }
            group(Finance)
            {
                Caption = 'Finance';

            }
            group("Sale & Marketing")
            {

            }
            group(Purchase)
            {

            }
            group(Warehouse)
            {

            }
            group(Manufacturing)
            {

            }
            group(Service)
            {

            }
            group("Human Resourses")
            {

            }
            group("Resource Planning")
            {

            }
            group(Admnistartion)
            {

            }
            group(Shortcuts)
            {

            }
        }
    }
}

profile SeminarCordinator
{
    ProfileDescription = 'Seminar Profile';
    RoleCenter = "Role Center";
    Caption = 'Seminar Profile Role Center';
}
