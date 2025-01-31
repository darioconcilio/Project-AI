namespace ProjectAI.Utilities;
using ProjectAI.Copilot;
using Microsoft.Projects.Project.Job;

codeunit 60103 "Project Utilities"
{
    var
        ProjectCopilot: Codeunit "Project Copilot";
        Response: Text;
        TasksJsonArray: JsonArray;
        TaskJsonToken: JsonToken;
        TaskJsonObject: JsonObject;
        SubTasksJsonToken: JsonToken;
        SubTaskJsonToken: JsonToken;
        SubTaskJsonObject: JsonObject;

    local procedure GetTextToken(CountryToAdd: JsonObject; KeyName: Text): Text
    var
        FieldJsonToken: JsonToken;
    begin
        if CountryToAdd.Get(KeyName, FieldJsonToken) then
            exit(FieldJsonToken.AsValue().AsText());

        exit('');
    end;

    local procedure GetIntToken(CountryToAdd: JsonObject; KeyName: Text): Integer
    var
        FieldJsonToken: JsonToken;
    begin
        if CountryToAdd.Get(KeyName, FieldJsonToken) then
            exit(FieldJsonToken.AsValue().AsInteger());

        exit(0);
    end;

    local procedure GetSystemPrompt() SystemPrompt: Text
    begin
        SystemPrompt := 'Generates a list of tasks related to a requested project, including specific sub-steps, in JSON format';
        SystemPrompt += 'It uses the information provided by the applicant regarding the context and specifications of the project. The main tasks must be organised in a list, where each task contains a description and a list of detailed sub-tasks consistent with the given context';

        SystemPrompt += '# Steps';
        SystemPrompt += '1. Analyses the context and any specifications provided by the applicant ';
        SystemPrompt += '2. Identifies the main tasks required to complete the project ';
        SystemPrompt += '3. Break down each main task into logical and sequential sub-steps representing the steps needed to complete the task ';
        SystemPrompt += '4. Ensure that each task and sub-task is described clearly, using specific and professional language ';
        SystemPrompt += '5. Generate output in json format, this one must be an array of object ';

        SystemPrompt += '# Example output ';

        //SystemPrompt += '``` ';
        SystemPrompt += '[ ';
        SystemPrompt += '    { ';
        SystemPrompt += '        "taskNo": 1000, ';
        SystemPrompt += '        "description": "Titolo task", ';
        SystemPrompt += '        "subTasks": [ ';
        SystemPrompt += '            { ';
        SystemPrompt += '                "no": 1010, ';
        SystemPrompt += '                "description": "Desc 1" ';
        SystemPrompt += '            }, ';
        SystemPrompt += '            { ';
        SystemPrompt += '                "no": 1020, ';
        SystemPrompt += '                "description": "Desc 2" ';
        SystemPrompt += '            } ';
        SystemPrompt += '        ] ';
        SystemPrompt += '    } ';
        SystemPrompt += '] ';
        //SystemPrompt += '``` ';
    end;

    procedure GetActivitiesSuggestion(var Job: Record Job; UserPrompt: Text; var TempJobTask: Record "Job Task" temporary)
    var
        JobTaskNo: Integer;
        JobSubTaskNo: Integer;
        StartTxt: Label 'Start %1', Comment = '%1 = Description of task';
        EndTxt: Label 'End %1', Comment = '%1 = Description of task';
        ResponseJsonObject: JsonObject;
        TasksJsonToken: JsonToken;
    //TraceUserPromptLbl: Label 'User Prompt [%1]: %2', Comment = '%1 = length of prompt, %2 = System Prompt';
    begin

        //Message(StrSubstNo(TraceUserPromptLbl, StrLen(UserPrompt), UserPrompt));

        TempJobTask.DeleteAll(false);

        Response := ProjectCopilot.Chat(GetSystemPrompt(), UserPrompt);

        ResponseJsonObject.ReadFrom(Response);

        ResponseJsonObject.Get('tasks', TasksJsonToken);
        TasksJsonArray := TasksJsonToken.AsArray();

        foreach TaskJsonToken in TasksJsonArray do begin

            TaskJsonObject := TaskJsonToken.AsObject();

            JobTaskNo := GetIntToken(TaskJsonObject, 'taskNo');

            TempJobTask.Init();
            TempJobTask."Job No." := Job."No.";
            Evaluate(TempJobTask."Job Task No.", Format(JobTaskNo, 20));
            Evaluate(TempJobTask.Description, Format(StrSubstNo(StartTxt, GetTextToken(TaskJsonObject, 'description')), 100));
            TempJobTask."Job Task Type" := TempJobTask."Job Task Type"::"Begin-Total";
            TempJobTask.Insert(false);

            if TaskJsonObject.Get('subTasks', SubTasksJsonToken) then
                foreach SubTaskJsonToken in SubTasksJsonToken.AsArray() do begin

                    SubTaskJsonObject := SubTaskJsonToken.AsObject();

                    JobSubTaskNo := GetIntToken(SubTaskJsonObject, 'no');

                    TempJobTask.Init();
                    TempJobTask."Job No." := Job."No.";
                    Evaluate(TempJobTask."Job Task No.", Format(JobSubTaskNo, 20));
                    Evaluate(TempJobTask.Description, Format(GetTextToken(SubTaskJsonObject, 'description'), 100));
                    TempJobTask."Job Task Type" := TempJobTask."Job Task Type"::Posting;
                    TempJobTask.Insert(false);

                end;

            //Example 1000 => 1999
            JobTaskNo += JobTaskNo;
            JobTaskNo -= 1;

            TempJobTask.Init();
            TempJobTask."Job No." := Job."No.";
            Evaluate(TempJobTask."Job Task No.", Format(JobTaskNo, 20));
            Evaluate(TempJobTask.Description, Format(StrSubstNo(EndTxt, GetTextToken(TaskJsonObject, 'description')), 100));
            TempJobTask."Job Task Type" := TempJobTask."Job Task Type"::"End-Total";
            TempJobTask.Insert(false);

        end;

    end;
}
