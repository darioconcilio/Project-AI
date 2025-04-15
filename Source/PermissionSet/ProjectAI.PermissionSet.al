permissionset 60100 "Project AI"
{
    Caption = 'Project AI', Locked = true;
    Assignable = true;
    Permissions = codeunit "AI Settings" = X,
        codeunit Capabilities = X,
        codeunit "Toolkit Copilot" = X,
        page "Job AI Prompt" = X,
        codeunit "Job Task Function Call" = X,
        codeunit "Json Utilities" = X,
        codeunit "Job Task Utilities" = X,
        codeunit "Job Tools" = X,
        page "Project Activity API" = X,
        page "Job AI Response" = X,
        page "Project API" = X,
        page "Job Task AI Prompt" = X,
        query "Item API" = X,
        codeunit "Job Utilities" = X;
}