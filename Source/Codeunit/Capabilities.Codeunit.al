namespace ProjectAI.Capabilities;

using System.AI;
using ProjectAI.Enums;

codeunit 60100 "Capabilities.Codeunit"
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
        SecretKeyTok: Label '6kRnq16RdiMGnXmhtrBegDZPU4sTr4rDAbJvXIpO47LfM9nVcubIJQQJ99BAAC5RqLJXJ3w3AAABACOGlnZc', Locked = true;
        DeploymentTxt: Label 'gpt-4o-mini', Locked = true;
        EndpointUrlTxt: Label 'https://devlife.openai.azure.com/', Locked = true;


    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'https://www.vitadasviluppatore.it/ProjectAI', Locked = true;
    begin
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::ProjectAI) then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::ProjectAI,
                                                 Enum::"Copilot Availability"::"Generally Available",
                                                 LearnMoreUrlTxt);

        AISettings.SetEndpointUrl(EndpointUrlTxt);
        AISettings.SetSecretKey(SecretKeyTok);
        AISettings.SetDeployment(DeploymentTxt);

    end;

}
