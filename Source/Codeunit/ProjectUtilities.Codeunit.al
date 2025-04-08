namespace ProjectAI.Utilities;
using ProjectAI.Copilot;
using ProjectAI.ProjectAI;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;
using Microsoft.Projects.Resources.Resource;
using Microsoft.HumanResources.Employee;

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

    // local procedure GetTextToken(CountryToAdd: JsonObject; KeyName: Text): Text
    // var
    //     FieldJsonToken: JsonToken;
    // begin
    //     if CountryToAdd.Get(KeyName, FieldJsonToken) then
    //         exit(FieldJsonToken.AsValue().AsText());

    //     exit('');
    // end;

    // local procedure GetDecimalToken(CountryToAdd: JsonObject; KeyName: Text): Decimal
    // var
    //     FieldJsonToken: JsonToken;
    // begin
    //     if CountryToAdd.Get(KeyName, FieldJsonToken) then
    //         exit(FieldJsonToken.AsValue().AsDecimal());

    //     exit(0);
    // end;

    // local procedure GetIntToken(CountryToAdd: JsonObject; KeyName: Text): Integer
    // var
    //     FieldJsonToken: JsonToken;
    // begin
    //     if CountryToAdd.Get(KeyName, FieldJsonToken) then
    //         exit(FieldJsonToken.AsValue().AsInteger());

    //     exit(0);
    // end;

    local procedure GetSystemPrompt(SimulationOption: Enum "Simulation Prompt Options") SystemPrompt: Text
    begin
        SystemPrompt := 'Generates a list of tasks related to a requested project, including specific sub-steps, in JSON format';
        SystemPrompt += 'It uses the information provided by the applicant regarding the context and specifications of the project. The main tasks must be organised in a list, where each task contains a description and a list of detailed sub-tasks consistent with the given context';

        SystemPrompt += '# Steps';
        SystemPrompt += '1. Analyses the context and any specifications provided by the applicant ';
        SystemPrompt += '2. Identifies the main tasks required to complete the project ';
        SystemPrompt += '3. Break down each main task into logical and sequential sub-steps representing the steps needed to complete the task ';
        SystemPrompt += '4. Ensure that each task and sub-task is described clearly, using specific and professional language ';
        SystemPrompt += '5. Generate output in json format, this one must be an array of object ';
        SystemPrompt += '6. Rules for numbers: taskNo must be with step 1000, subTaskNo must be step 10 and addtional number on relative taskNo ';

        if SimulationOption = SimulationOption::Budget then
            SystemPrompt += '7. Each subtask must have a budget expressed in hours that simulates the time needed to perform the task itself ';

        SystemPrompt += '**Rule to be observed in all cases: "the returned json must be an array of objects"** ';
        SystemPrompt += '# Example output ';

        //SystemPrompt += '``` ';
        SystemPrompt += '[ ';
        SystemPrompt += '    { ';
        SystemPrompt += '        "taskNo": 1000, ';
        SystemPrompt += '        "description": "Task title", ';
        SystemPrompt += '        "subTasks": [ ';
        SystemPrompt += '            { ';
        SystemPrompt += '                "no": 1010, ';

        if SimulationOption = SimulationOption::Budget then begin
            SystemPrompt += '                "description": "Desc 1", ';
            SystemPrompt += '                "budget": 16.0 ';
        end else
            SystemPrompt += '                "description": "Desc 1" ';

        SystemPrompt += '            }, ';
        SystemPrompt += '            { ';
        SystemPrompt += '                "no": 1020, ';

        if SimulationOption = SimulationOption::Budget then begin
            SystemPrompt += '                "description": "Desc 2", ';
            SystemPrompt += '                "budget": 8.0 ';
        end else
            SystemPrompt += '                "description": "Desc 2" ';

        SystemPrompt += '            } ';
        SystemPrompt += '        ] ';
        SystemPrompt += '    }, ';
        SystemPrompt += '    { ';
        SystemPrompt += '        "taskNo": 2000, ';
        SystemPrompt += '        "description": "Task title", ';
        SystemPrompt += '        "subTasks": [ ';
        SystemPrompt += '            { ';
        SystemPrompt += '                "no": 2010, ';

        if SimulationOption = SimulationOption::Budget then begin
            SystemPrompt += '                "description": "Desc 1", ';
            SystemPrompt += '                "budget": 24.0 ';
        end else
            SystemPrompt += '                "description": "Desc 1" ';

        SystemPrompt += '            }, ';
        SystemPrompt += '            { ';
        SystemPrompt += '                "no": 2020, ';

        if SimulationOption = SimulationOption::Budget then begin
            SystemPrompt += '                "description": "Desc 2", ';
            SystemPrompt += '                "budget": 4.0 ';
        end else
            SystemPrompt += '                "description": "Desc 2" ';

        SystemPrompt += '            } ';
        SystemPrompt += '        ] ';
        SystemPrompt += '    } ';
        SystemPrompt += '] ';
        //SystemPrompt += '``` ';
    end;

    procedure GetActivitiesSuggestion(var TempJob: Record Job temporary; UserPrompt: Text; var TempJobTask: Record "Job Task" temporary; var TempJobPlanningLine: Record "Job Planning Line" temporary; SimulateBudget: Enum "Simulation Prompt Options")
    var
        Resource: Record Resource;
        JobTaskNo: Integer;
        JobSubTaskNo: Integer;
        StartTxt: Label 'Start %1', Comment = '%1 = Description of task';
        EndTxt: Label 'End %1', Comment = '%1 = Description of task';
        ResponseJsonObject: JsonObject;
        TasksJsonToken: JsonToken;
    begin

        TempJobTask.DeleteAll(false);

        Response := ProjectCopilot.Chat(GetSystemPrompt(SimulateBudget), UserPrompt);

        ResponseJsonObject.ReadFrom(Response);

        ResponseJsonObject.Get('tasks', TasksJsonToken);
        TasksJsonArray := TasksJsonToken.AsArray();

        foreach TaskJsonToken in TasksJsonArray do begin

            TaskJsonObject := TaskJsonToken.AsObject();

            //JobTaskNo := GetIntToken(TaskJsonObject, 'taskNo');
            JobTaskNo := TaskJsonObject.GetInteger('taskNo', true);

            TempJobTask.Init();
            TempJobTask."Job No." := TempJob."No.";
            Evaluate(TempJobTask."Job Task No.", Format(JobTaskNo, 20));

            //Evaluate(TempJobTask.Description, Format(StrSubstNo(StartTxt, GetTextToken(TaskJsonObject, 'description')), 100));
            Evaluate(TempJobTask.Description, Format(StrSubstNo(StartTxt, TaskJsonObject.GetText('description', true)), 100));

            TempJobTask."Job Task Type" := TempJobTask."Job Task Type"::"Begin-Total";
            TempJobTask.Insert(false);

            if TaskJsonObject.Get('subTasks', SubTasksJsonToken) then
                foreach SubTaskJsonToken in SubTasksJsonToken.AsArray() do begin

                    SubTaskJsonObject := SubTaskJsonToken.AsObject();

                    //JobSubTaskNo := GetIntToken(SubTaskJsonObject, 'no');
                    JobSubTaskNo := SubTaskJsonObject.GetInteger('no', true);

                    TempJobTask.Init();
                    TempJobTask."Job No." := TempJob."No.";
                    Evaluate(TempJobTask."Job Task No.", Format(JobSubTaskNo, 20));

                    //Evaluate(TempJobTask.Description, Format(GetTextToken(SubTaskJsonObject, 'description'), 100));
                    Evaluate(TempJobTask.Description, Format(SubTaskJsonObject.GetText('description', true), 100));

                    TempJobTask."Job Task Type" := TempJobTask."Job Task Type"::Posting;
                    TempJobTask.Insert(false);

                    if SimulateBudget = SimulateBudget::Budget then begin

                        TempJobPlanningLine.Init();
                        TempJobPlanningLine."Job No." := TempJob."No.";
                        TempJobPlanningLine."Job Task No." := TempJobTask."Job Task No.";
                        TempJobPlanningLine."Line No." := 10000;
                        TempJobPlanningLine.Insert(false);

                        TempJobPlanningLine."Line Type" := TempJobPlanningLine."Line Type"::Billable;

                        TempJobPlanningLine.Type := TempJobPlanningLine.Type::Resource;
                        GetRandomResource(Resource);
                        TempJobPlanningLine."No." := Resource."No.";

                        //Evaluate(TempJobPlanningLine.Quantity, Format(GetDecimalToken(SubTaskJsonObject, 'budget'), 10));
                        Evaluate(TempJobPlanningLine.Quantity, Format(SubTaskJsonObject.GetDecimal('budget', true), 10));

                        TempJobPlanningLine.Modify(false);

                    end;

                end;

            //Example 1000 => 1999
            JobTaskNo += 1000;
            JobTaskNo -= 1;

            TempJobTask.Init();
            TempJobTask."Job No." := TempJob."No.";
            Evaluate(TempJobTask."Job Task No.", Format(JobTaskNo, 20));

            //Evaluate(TempJobTask.Description, Format(StrSubstNo(EndTxt, GetTextToken(TaskJsonObject, 'description')), 100));
            Evaluate(TempJobTask.Description, Format(StrSubstNo(EndTxt, TaskJsonObject.GetText('description', true)), 100));

            TempJobTask."Job Task Type" := TempJobTask."Job Task Type"::"End-Total";
            TempJobTask.Insert(false);

        end;

    end;

    local procedure GetRandomResource(var Resource: Record Resource)
    var
        ResourceCount: Integer;
        RandomResourceInt: Integer;
    begin
        ResourceCount := Resource.Count();
        RandomResourceInt := Random(ResourceCount);

        Resource.Next(RandomResourceInt);
    end;
}
