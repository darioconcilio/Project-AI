namespace ProjectAI.ProjectAI;

codeunit 60109 "Install Management"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        IsolatedStorage.SetEncrypted('BlobStorageKey', 'AWNO4BRej4d19X7mk73/5bo86yKNtQjiEhI+i1hErBzmcr4SLaid9SKv3jOQ79EWdBKGI+Qbdrjb+AStwysymA==');
        IsolatedStorage.SetEncrypted('SASToken', 'sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2025-05-30T01:14:56Z&st=2025-05-04T17:14:56Z&spr=https&sig=8lBJb%2FmB9drQ9c1QQbpvUoyumKyg61E8CRwSIejg3yI%3D');

    end;
}
