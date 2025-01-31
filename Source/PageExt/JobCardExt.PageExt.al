namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

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
                    TempJobTask: Record "Job Task" temporary;
                    ProjectAIPromptPage: Page "Project AI Prompt";
                    EmptyCurrentRecordsQst: Label 'Do you want delete current records';
                    LastJobTaskNo: Code[20];
                    LastJobTaskNoInt: Integer;
                    CurrentJobTaskNo: Code[20];
                    CurrentJobTaskNoInt: Integer;
                begin

                    if ProjectAIPromptPage.RunModal() = Action::OK then begin

                        //Chiede se bisogna eliminare i record esistenti, se ce ne sono
                        JobTask.SetRange("Job No.", Rec."No.");
                        if not JobTask.IsEmpty() then
                            if Confirm(EmptyCurrentRecordsQst) then
                                JobTask.DeleteAll(true);

                        //Recupera l'eventuale l'ultimo record
                        if JobTask.FindLast() then begin
                            LastJobTaskNo := JobTask."Job Task No.";
                            Evaluate(LastJobTaskNoInt, LastJobTaskNo);
                        end;

                        //Attinge dal prompt i record generati da Copilot (Azure OpenAI)
                        ProjectAIPromptPage.WriteTo(TempJobTask);
                        if TempJobTask.FindSet() then
                            repeat

                                JobTask.Init();
                                JobTask."Job No." := Rec."No.";

                                Evaluate(CurrentJobTaskNoInt, TempJobTask."Job Task No.");
                                Evaluate(CurrentJobTaskNo, Format(CurrentJobTaskNoInt + LastJobTaskNoInt, 20));
                                JobTask.Validate("Job Task No.", CurrentJobTaskNo);

                                JobTask.Insert(true);

                                JobTask.Validate(Description, TempJobTask.Description);
                                JobTask.Validate("Job Task Type", TempJobTask."Job Task Type");
                                JobTask.Modify(true);

                            until TempJobTask.Next() = 0;

                        CurrPage.Update(true);
                    end;
                end;
            }
        }
    }
}
