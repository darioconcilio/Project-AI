namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

pageextension 60102 "Job List Ext" extends "Job List"
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
                    ProjectTool: Codeunit "Project Tool";
                begin
                    ProjectTool.GenerateProjectTasks(Rec);
                    CurrPage.Update(true);
                end;
            }
        }
    }
}
