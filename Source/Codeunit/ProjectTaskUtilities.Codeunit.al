namespace ProjectAI.Utilities;
using ProjectAI.Copilot;
using ProjectAI.ProjectAI;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;
using Microsoft.Projects.Resources.Resource;
using Microsoft.HumanResources.Employee;

codeunit 60106 "Project Task Utilities"
{
    var
        ProjectCopilot: Codeunit "Project Copilot";
        Response: Text;


    local procedure GetSystemPrompt() SystemPrompt: Text
    begin
        //TODO: Implement the logic to generate the system prompt based on the context of the task.
        SystemPrompt := '';
    end;

    procedure RequestManipulationOnTask(var JobTask: Record "Job Task"; UserPrompt: Text)
    begin
        Response := ProjectCopilot.Chat(GetSystemPrompt(), UserPrompt);

        //TODO: Implement the logic to manipulate the JobTask record based on the response from Copilot.
    end;

}
