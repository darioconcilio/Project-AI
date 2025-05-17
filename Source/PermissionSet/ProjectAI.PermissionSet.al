permissionset 60100 "Project AI"
{
    Caption = 'Project AI', Locked = true;
    Assignable = true;
    Permissions = codeunit "AI Settings" = X,
        codeunit Capabilities = X,
        codeunit "Toolkit Copilot" = X,
        page "Job AI Prompt" = X,
        codeunit "Search Item by Func. Call" = X,
        codeunit "Json Utilities" = X,
        codeunit "Search Item Utilities" = X,
        codeunit "Job Tools" = X,
        page "Project Activity API" = X,
        page "Job AI Response" = X,
        page "Project API" = X,
        page "Job Task Search Item Prompt" = X,
        query "Item API" = X,
        codeunit "Job Utilities" = X,
        codeunit "Blob Storage Managament" = X,
        codeunit "Install Management" = X,
        codeunit "Job Task Tools" = X,
        page "Job Task Items Response" = X;
}