namespace ProjectAI.Capabilities;

codeunit 60101 "AI Settings"
{
    SingleInstance = true;

    var
        EndpointUrlKeyNameTxt: Label 'EndPointUrl', Locked = true;
        SecretKeyKeyNameTxt: Label 'SecretKey', Locked = true;
        DeploymentKeyKeyNameTxt: Label 'DeploymentKey', Locked = true;

        EndpointUrl: Text;
        SecretKey: SecretText;
        DeploymentKey: Text;

    procedure GetEndpointUrl(): Text
    begin
        if EndpointUrl = '' then
            IsolatedStorage.Get(EndpointUrlKeyNameTxt, EndpointUrl);

        exit(EndpointUrl);
    end;

    procedure SetEndpointUrl(EndpointUrlToSave: Text)
    begin
        if IsolatedStorage.SetEncrypted(EndpointUrlKeyNameTxt, EndpointUrlToSave, DataScope::Module) then
            EndpointUrl := EndpointUrlToSave;
    end;

    procedure GetSecretKey(): SecretText
    begin
        if SecretKey.IsEmpty() then
            IsolatedStorage.Get(SecretKeyKeyNameTxt, SecretKey);

        exit(SecretKey);
    end;

    procedure SetSecretKey(SecretKeyToSave: Text)
    begin
        if IsolatedStorage.SetEncrypted(SecretKeyKeyNameTxt, SecretKeyToSave, DataScope::Module) then
            SecretKey := SecretKeyToSave;
    end;

    procedure GetDeployment(): Text
    begin
        if DeploymentKey = '' then
            IsolatedStorage.Get(DeploymentKeyKeyNameTxt, DeploymentKey);

        exit(DeploymentKey);
    end;

    procedure SetDeployment(DeploymentToSave: Text)
    begin
        if IsolatedStorage.SetEncrypted(DeploymentKeyKeyNameTxt, DeploymentToSave, DataScope::Module) then
            DeploymentKey := DeploymentToSave;
    end;
}
