namespace ProjectAI.ProjectAI;

using System.AI;
using ProjectAI.Utilities;
using Microsoft.Projects.Project.Job;

codeunit 60107 "Job Task Function Call" implements "AOAI Function"
{
    var
        JobTask: Record "Job Task";
        ProjectTaskUtilities: Codeunit "Job Task Utilities";

    procedure GetPrompt(): JsonObject
    var
        Prompt: JsonObject;
        PromptText: Text;
    begin
        PromptText := '{' +
            '"type": "function",' +
            '"name": "detail_task",' +
            '"description": "Breaks down a project task into subtasks. This function helps in project planning by creating a detailed breakdown of tasks and their dependencies.",' +
            '"parameters": {' +
                '"type": "object",' +
                '"properties": {' +
                    '"task_id": {' +
                        '"type": "string",' +
                        '"description": "The unique identifier of the task to be broken down. Format: JobNo + JobTaskNo"' +
                    '},' +
                    '"user_prompt": {' +
                        '"type": "string",' +
                        '"description": "The user''s request describing how to break down the task. Include any specific requirements or constraints."' +
                    '}' +
                '},' +
                '"required": ["task_id", "user_prompt"]' +
            '}' +
        '}';

        Prompt.ReadFrom(PromptText);
        exit(Prompt);
    end;

    procedure Execute(Arguments: JsonObject): Variant
    var
        TaskId: Text;
        UserPrompt: Text;
        Token: JsonToken;
        JobNo: Code[20];
        JobTaskNo: Code[20];
    begin
        if not Arguments.Get('task_id', Token) then
            Error('Missing required parameter: task_id');
        TaskId := Token.AsValue().AsText();

        if not Arguments.Get('user_prompt', Token) then
            Error('Missing required parameter: user_prompt');
        UserPrompt := Token.AsValue().AsText();

        JobNo := CopyStr(TaskId, 1, 20);
        JobTaskNo := CopyStr(TaskId, 21, 20);

        if not JobTask.Get(JobNo, JobTaskNo) then
            Error('Task not found. Job No.: %1, Job Task No.: %2', JobNo, JobTaskNo);

        ProjectTaskUtilities.RequestManipulationOnTask(JobTask, UserPrompt);
        exit(JobTask);
    end;

    procedure GetName(): Text
    begin
        exit('detail_task');
    end;
}