namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;
using System.Utilities;
using Microsoft.Inventory.Item;

codeunit 60108 "Job Task Tools"
{
    procedure AddItemToJobTask(var JobTask: Record "Job Task")
    var
        ItemToAdd: Record Item;
        JobPlanningLine: Record "Job Planning Line";
        JobTaskSearchItemPrompt: Page "Job Task Search Item Prompt";
        LastLineNo: Integer;
    begin

        JobTaskSearchItemPrompt.SetJobTask(JobTask);

        if JobTaskSearchItemPrompt.RunModal() = Action::OK then begin
            JobTaskSearchItemPrompt.WriteTo(ItemToAdd);

            JobPlanningLine.SetRange("Job No.", JobTask."Job No.");
            JobPlanningLine.SetRange("Job Task No.", JobTask."Job Task No.");
            if JobPlanningLine.FindLast() then
                LastLineNo := JobPlanningLine."Line No.";

            JobPlanningLine.Reset();

            JobPlanningLine.Init();
            JobPlanningLine."Job No." := JobTask."Job No.";
            JobPlanningLine."Job Task No." := JobTask."Job Task No.";
            JobPlanningLine."Line No." := LastLineNo + 10000;
            JobPlanningLine.Insert(true);

            JobPlanningLine.Validate("Line Type", JobPlanningLine."Line Type"::Billable);
            JobPlanningLine.Validate(Type, JobPlanningLine.Type::Item);
            JobPlanningLine.Validate("No.", ItemToAdd."No.");
            JobPlanningLine.Validate(Quantity, 1);
            JobPlanningLine.Modify(true);

        end;

    end;

}
