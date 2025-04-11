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
                    ProjectTool: Codeunit "Project Tools";
                begin
                    ProjectTool.GenerateProjectTasks(Rec);
                    CurrPage.Update(true);
                end;
            }
        }
    }
}
