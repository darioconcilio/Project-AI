namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;
using System.Utilities;

codeunit 60104 "Project Tools"
{
    procedure GenerateProjectTasks(var JobByPage: Record "Job")
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        TempJobTask: Record "Job Task" temporary;
        TempJobPlanningLine: Record "Job Planning Line" temporary;
        JobTaskIndent: Codeunit "Job Task-Indent";
        ProjectAIPromptPage: Page "Project AI Prompt";
    begin
        ProjectAIPromptPage.SetJob(JobByPage);
        if ProjectAIPromptPage.RunModal() = Action::OK then begin

            //Attinge dal prompt i record generati da Copilot (Azure OpenAI)
            ProjectAIPromptPage.WriteTo(TempJobTask, TempJobPlanningLine);
            if TempJobTask.FindSet() then
                repeat

                    JobTask.Init();
                    JobTask."Job No." := JobByPage."No.";
                    JobTask."Job Task No." := TempJobTask."Job Task No.";
                    JobTask.Insert(true);

                    JobTask.Validate(Description, TempJobTask.Description);
                    JobTask.Validate("Job Task Type", TempJobTask."Job Task Type");
                    JobTask.Modify(true);

                    if JobTask."Job Task Type" = JobTask."Job Task Type"::Posting then
                        if TempJobPlanningLine.Get(JobTask."Job No.", JobTask."Job Task No.", 10000) then begin

                            JobPlanningLine.Init();
                            JobPlanningLine."Job No." := TempJobPlanningLine."Job No.";
                            JobPlanningLine."Job Task No." := TempJobPlanningLine."Job Task No.";
                            JobPlanningLine."Line No." := TempJobPlanningLine."Line No.";
                            JobPlanningLine.Insert(true);

                            JobPlanningLine.Validate("Line Type", TempJobPlanningLine."Line Type");
                            JobPlanningLine.Validate(Type, TempJobPlanningLine.Type);
                            JobPlanningLine.Validate("No.", TempJobPlanningLine."No.");

                            JobPlanningLine.Validate(Quantity, TempJobPlanningLine.Quantity);

                            JobPlanningLine.Modify(true);

                        end;


                until TempJobTask.Next() = 0;

            JobTaskIndent.Indent(JobByPage."No.");

        end;
    end;

    procedure ManipulateJobTask(var JobTask: Record "Job Task")
    var
        JobPlanningLine: Record "Job Planning Line";
    begin

    end;
}
