permissionset 60100 GeneratedPermission
{
    Caption = 'Project AI', Locked = true;

    Assignable = true;
    Permissions = codeunit "AI Settings" = X,
        codeunit Capabilities = X,
        codeunit "Project Copilot" = X,
        codeunit "Project Gen. Utilities" = X,
        page "Project AI Prompt" = X;
}