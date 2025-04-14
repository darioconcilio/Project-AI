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
        SystemPrompt := 'You are a project management assistant. Your task is to analyze the user''s request and determine if they want to break down a specific task into subtasks. ' +
                        'If the request contains keywords like "break down", "subtasks", "detailed tasks", "task breakdown", or similar phrases, and mentions a specific task, ' +
                        'you should respond with a JSON structure containing the following information: ' +
                        '1. The main task that needs to be broken down ' +
                        '2. A list of subtasks with their descriptions ' +
                        '3. Estimated duration for each subtask ' +
                        '4. Dependencies between subtasks (if any) ' +
                        'The JSON response should follow this structure: ' +
                        '{"mainTask": "task name", ' +
                        '"subtasks": [ ' +
                        '  {"name": "subtask 1", "description": "description", "duration": "estimated duration", "dependencies": []}, ' +
                        '  {"name": "subtask 2", "description": "description", "duration": "estimated duration", "dependencies": ["subtask 1"]} ' +
                        ']} ' +
                        'If the request does not clearly indicate a need for task breakdown, respond with a message explaining that the request does not contain a clear task breakdown request.';
    end;

    procedure RequestManipulationOnTask(var JobTask: Record "Job Task"; UserPrompt: Text)
    begin
        Response := ProjectCopilot.Chat(GetSystemPrompt(), UserPrompt);

        //TODO: Implement the logic to manipulate the JobTask record based on the response from Copilot.
    end;

}
