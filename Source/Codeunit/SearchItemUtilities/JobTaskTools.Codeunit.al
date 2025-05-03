namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;
using System.Utilities;

codeunit 60108 "Job Task Tools"
{
    procedure AddItemToJobTask(var JobTask: Record "Job Task")
    var
        JobTaskAIPrompt: Page "Job Task AI Prompt";
    begin

        JobTaskAIPrompt.SetJobTask(JobTask);

        if JobTaskAIPrompt.RunModal() = Action::OK then begin

        end;
    end;

}
