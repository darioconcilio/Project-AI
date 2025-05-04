namespace ProjectAI.ProjectAI;
using System.Azure.Storage;
using Microsoft.Projects.Project.Job;

codeunit 60110 "Blob Storage Managament"
{
    var
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSBlobClient: Codeunit "ABS Blob Client";
        IsolatedStorageNameSharedKeyTxt: Label 'BlobStorageKey', Locked = true;
        SharedKey: SecretText;
        Authorization: Interface "Storage Service Authorization";
        StorageAccountTxt: Label 'devlife', Locked = true;
        ContainerTxt: Label 'jobs', Locked = true;
        JobFileNameTxt: Label 'job_%1.json', Locked = true;
        Content: Text;

    local procedure InitConnection()
    begin
        IsolatedStorage.Get(IsolatedStorageNameSharedKeyTxt, SharedKey);

        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);

        ABSBlobClient.Initialize(StorageAccountTxt, ContainerTxt, Authorization);
    end;

    procedure UploadJob(Job: Record Job)
    var
        ABSOperationResponse: Codeunit "ABS Operation Response";
        ResponseError: ErrorInfo;
    begin
        InitConnection();

        Job.AsJson().WriteTo(Content);

        ABSOperationResponse := ABSBlobClient.PutBlobBlockBlobText(StrSubstNo(JobFileNameTxt, Job."No."), Content);

        if not ABSOperationResponse.IsSuccessful() then begin
            ResponseError.Message := ABSOperationResponse.GetError();
            Error(ResponseError);
        end;
    end;
}
