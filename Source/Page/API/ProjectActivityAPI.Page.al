namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

page 60103 "Project Activity API"
{
    APIGroup = 'projectGroup';
    APIPublisher = 'vitaDaSviluppatore';
    APIVersion = 'v1.0';
    Caption = 'projectAPI';
    DelayedInsert = true;
    EntityName = 'jobTask';
    EntitySetName = 'jobTasks';
    PageType = API;
    SourceTable = "Job Task";

    ODataKeyFields = "Job No.", "Job Task No.";

    Editable = false;
    DataAccessIntent = ReadOnly; //Permette di utilizzare la replica secondaria del database di BC

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Project No.';
                }
                field(jobTaskNo; Rec."Job Task No.")
                {
                    Caption = 'Project Task No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(jobTaskType; Rec."Job Task Type")
                {
                    Caption = 'Project Task Type';
                }
                field(scheduleTotalCost; Rec."Schedule (Total Cost)")
                {
                    Caption = 'Budget (Total Cost)';
                }
                field(scheduleTotalPrice; Rec."Schedule (Total Price)")
                {
                    Caption = 'Budget (Total Price)';
                }
                field(usageTotalCost; Rec."Usage (Total Cost)")
                {
                    Caption = 'Actual (Total Cost)';
                }
                field(usageTotalPrice; Rec."Usage (Total Price)")
                {
                    Caption = 'Actual (Total Price)';
                }
            }
        }
    }
}
