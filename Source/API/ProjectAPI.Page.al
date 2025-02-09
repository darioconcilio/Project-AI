namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

page 60102 "Project API"
{
    APIGroup = 'projectGroup';
    APIPublisher = 'vitaDaSviluppatore';
    APIVersion = 'v1.0';
    Caption = 'projectAPI';
    DelayedInsert = true;
    EntityName = 'job';
    EntitySetName = 'jobs';
    PageType = API;
    SourceTable = Job;

    ODataKeyFields = "No.";

    //Editable = false;
    //DataAccessIntent = ReadOnly; //Permette di utilizzare la replica secondaria del database di BC

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field(creationDate; Rec."Creation Date")
                {
                    Caption = 'Creation Date';
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(endingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(personResponsible; Rec."Person Responsible")
                {
                    Caption = 'Person Responsible';
                }
                part(projectActivities; "Project Activity API")
                {
                    Caption = 'Project Activities';
                    SubPageLink = "Job No." = field("No.");
                }
            }
        }
    }
}
