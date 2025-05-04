namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;
using System.Utilities;
using Microsoft.Projects.Project.Planning;

pageextension 60101 "Job Card Ext." extends "Job Card"
{

    actions
    {
        addfirst(Category_New)
        {
            actionref(GenerateCopilotPromoted; GenerateCopilotAction)
            {
            }
        }

        addlast(Prompting)
        {
            action(GenerateCopilotAction)
            {
                Caption = 'Draft with Copilot';
                Image = SparkleFilled;
                Ellipsis = true;
                ApplicationArea = All;
                ToolTip = 'Lets Copilot generate a draft project based on your description.';

                trigger OnAction()
                var
                    ProjectTool: Codeunit "Job Tools";
                begin
                    ProjectTool.GenerateProjectTasks(Rec);
                    CurrPage.Update(true);
                end;
            }
        }
        addlast(processing)
        {
            action(ArchiveToBlobStorage)
            {
                Caption = 'Archive to Blob Storage';
                Image = Archive;
                Ellipsis = true;
                ApplicationArea = All;
                ToolTip = 'Archive the project to Blob Storage.';

                trigger OnAction()
                var
                    BlobStorageManagement: Codeunit "Blob Storage Managament";
                    JobArchivedMsg: Label 'Job %1 archived to Blob Storage.', Comment = '%1 = Job No.';
                begin
                    BlobStorageManagement.UploadJob(Rec);
                    Message(JobArchivedMsg, Rec."No.");
                end;
            }
        }
    }
}
