namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

tableextension 60100 "Job Ext" extends Job
{
    procedure SetBlocked(JobBlocked: Enum "Job Blocked")
    begin
        Rec.Validate(Blocked, JobBlocked);
        Rec.Modify(true);
    end;
}
