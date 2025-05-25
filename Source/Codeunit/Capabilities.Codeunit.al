namespace ProjectAI.Capabilities;

using System.AI;
using ProjectAI.Enums;

codeunit 60100 "Capabilities"
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    var
        AISettings: Codeunit "AI Settings";
        SecretKeyTok: Label '8qV5gZ9OCnjNUI8CnqHYLcCB9opWg8dZ6Ukojlc833Gd9l8wdGyQJQQJ99BEAC5RqLJXJ3w3AAABACOGgIlx', Locked = true;
        DeploymentTxt: Label 'o3-mini', Locked = true;
        EndpointUrlTxt: Label 'https://project-ai.openai.azure.com/', Locked = true;


    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'https://www.vitadasviluppatore.it/', Locked = true;
    begin

        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::JobCopilotAI) then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::JobCopilotAI,
                                                 Enum::"Copilot Availability"::"Generally Available",
                                                 LearnMoreUrlTxt);

        AISettings.SetEndpointUrl(EndpointUrlTxt);
        AISettings.SetSecretKey(SecretKeyTok);
        AISettings.SetDeployment(DeploymentTxt);

    end;

}
