namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

pageextension 60103 "Job Task Lines Subform Ext" extends "Job Task Lines Subform"
{
    actions
    {
        addlast(Prompting)
        {
            action(GenerateCopilotAction)
            {
                Caption = 'Manipulate with Copilot';
                Image = SparkleFilled;
                Ellipsis = true;
                ApplicationArea = All;
                ToolTip = 'Allows the work line to be manipulated with Copilot.';

                trigger OnAction()
                var
                    ProjectTool: Codeunit "Project Tools";
                begin
                    ProjectTool.ManipulateJobTask(Rec);
                    CurrPage.Update(true);
                end;
            }
        }
    }
}
