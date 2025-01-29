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
                begin
                    Page.RunModal(Page::"Project AI Prompt");
                end;
            }
        }
    }
}
