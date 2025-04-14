permissionset 60100 "Project AI"
{
    Caption = 'Project AI', Locked = true;
    Assignable = true;
    Permissions = codeunit "AI Settings" = X,
        codeunit Capabilities = X,
        codeunit "Project Copilot" = X,
        page "Project AI Prompt" = X,
        codeunit "Detail Task Function Call" = X,
        codeunit "Json Utilities" = X,
        codeunit "Project Task Utilities" = X,
        codeunit "Project Tools" = X,
        page "Project Activity API" = X,
        page "Project AI Response" = X,
        page "Project API" = X,
        page "Project Task AI Prompt" = X,
        query "Item API" = X,
        codeunit "Project Gen. Utilities" = X;
}