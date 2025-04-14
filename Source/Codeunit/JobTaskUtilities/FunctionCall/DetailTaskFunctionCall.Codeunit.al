namespace ProjectAI.ProjectAI;

using System.AI;
using ProjectAI.Utilities;
using Microsoft.Projects.Project.Job;

codeunit 60107 "Detail Task Function Call" implements "AOAI Function"
{
    var
        JobTask: Record "Job Task";
        ProjectTaskUtilities: Codeunit "Project Task Utilities";

    procedure GetPrompt(): JsonObject
    var
        Prompt: JsonObject;
        Parameters: JsonObject;
        Properties: JsonObject;
    begin
        Prompt.Add('name', 'detail_task');
        Prompt.Add('description', 'Breaks down a project task into subtasks');

        Parameters.Add('task_id', 'string');
        Parameters.Add('user_prompt', 'string');

        Properties.Add('type', 'object');
        Properties.Add('properties', Parameters);
        Properties.Add('required', '["task_id", "user_prompt"]');

        Prompt.Add('parameters', Properties);
        exit(Prompt);
    end;

    procedure Execute(Arguments: JsonObject): Variant
    var
        TaskId: Text;
        UserPrompt: Text;
        Token: JsonToken;
    begin
        Arguments.Get('task_id', Token);
        TaskId := Token.AsValue().AsText();
        Arguments.Get('user_prompt', Token);
        UserPrompt := Token.AsValue().AsText();

        if not JobTask.Get(TaskId) then
            Error('Task not found');

        ProjectTaskUtilities.RequestManipulationOnTask(JobTask, UserPrompt);
        exit(JobTask);
    end;

    procedure GetName(): Text
    begin
        exit('detail_task');
    end;
}