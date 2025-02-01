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
                    JobTask: Record "Job Task";
                    JobPlanningLine: Record "Job Planning Line";
                    TempJobTask: Record "Job Task" temporary;
                    TempJobPlanningLine: Record "Job Planning Line" temporary;
                    ConfimManagement: Codeunit "Confirm Management";
                    JobTaskIndent: Codeunit "Job Task-Indent";
                    ProjectAIPromptPage: Page "Project AI Prompt";
                    EmptyCurrentRecordsQst: Label 'Do you want delete current records';
                    LastJobTaskNo: Code[20];
                    LastJobTaskNoInt: Integer;
                    CurrentJobTaskNo: Code[20];
                    CurrentJobTaskNoInt: Integer;
                begin
                    ProjectAIPromptPage.SetJob(Rec);
                    if ProjectAIPromptPage.RunModal() = Action::OK then begin

                        // //Chiede se bisogna eliminare i record esistenti, se ce ne sono
                        // JobTask.SetRange("Job No.", Rec."No.");
                        // if not JobTask.IsEmpty() then
                        //     if ConfimManagement.GetResponse(EmptyCurrentRecordsQst) then
                        //         JobTask.DeleteAll(true);

                        // //Recupera l'eventuale l'ultimo record
                        // if JobTask.FindLast() then begin
                        //     LastJobTaskNo := JobTask."Job Task No.";
                        //     Evaluate(LastJobTaskNoInt, LastJobTaskNo);
                        // end;

                        //Attinge dal prompt i record generati da Copilot (Azure OpenAI)
                        ProjectAIPromptPage.WriteTo(TempJobTask, TempJobPlanningLine);
                        if TempJobTask.FindSet() then
                            repeat

                                JobTask.Init();
                                JobTask."Job No." := Rec."No.";

                                // Evaluate(CurrentJobTaskNoInt, TempJobTask."Job Task No.");
                                // Evaluate(CurrentJobTaskNo, Format(CurrentJobTaskNoInt + LastJobTaskNoInt, 20));
                                // JobTask.Validate("Job Task No.", CurrentJobTaskNo);
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

                        JobTaskIndent.Indent(Rec."No.");

                        CurrPage.Update(true);
                    end;
                end;
            }
        }
    }
}
