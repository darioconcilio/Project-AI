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
        SecretKeyTok: Label 'EsbutVRnbffXZJGB7VpcdPnfcurYEEf5ito8oLkJmmySot67jwwSJQQJ99BEACYeBjFXJ3w3AAABACOGxbMq', Locked = true;
        DeploymentTxt: Label 'gpt-4o-mini', Locked = true;
        EndpointUrlTxt: Label 'https://dev-life-ai.openai.azure.com/', Locked = true;


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
