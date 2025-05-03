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
                Caption = 'Search items with Copilot';
                Image = SparkleFilled;
                Ellipsis = true;
                ApplicationArea = All;
                ToolTip = 'Allows to add items in budget task with Copilot.';

                trigger OnAction()
                var
                    JobTaskTools: Codeunit "Job Task Tools";
                begin
                    JobTaskTools.AddItemToJobTask(Rec);
                    CurrPage.Update(true);
                end;
            }
        }
    }
}
