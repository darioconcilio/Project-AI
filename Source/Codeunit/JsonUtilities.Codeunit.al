namespace ProjectAI.ProjectAI;

codeunit 60105 "Json Utilities"
{
    /// <summary>
    /// This codeunit provides utility functions for handling JSON data.
    /// </summary>
    /// <param name="RecRef"></param>
    /// <returns></returns>
    procedure GetJsonFromRecord(RecRef: RecordRef) OutputJsonObject: JsonObject
    var
        FieldRef: FieldRef;
        IndexField: Integer;
        FieldName: Text;
        ValInt: Integer;
        ValueText: Text;
        ValueDecimal: Decimal;
        ValueDate: Date;
        ValueTime: Time;
        ValueDateTime: DateTime;
        ValueOption: Integer;
        ValueBoolean: Boolean;
        ValueCode: Code[250];
    begin

        for IndexField := 1 to RecRef.FieldCount do begin
            FieldRef := RecRef.FieldIndex(IndexField);
            FieldName := FieldRef.Name;

            case FieldRef.Type of
                FieldType::Integer:
                    begin
                        ValInt := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValInt);
                    end;
                FieldType::Text:
                    begin
                        ValueText := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValueText);
                    end;
                FieldType::Decimal:
                    begin
                        ValueDecimal := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValueDecimal);
                    end;
                FieldType::Date:
                    begin
                        ValueDate := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValueDate);
                    end;
                FieldType::Time:
                    begin
                        ValueTime := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValueTime);
                    end;
                FieldType::DateTime:
                    begin
                        ValueDateTime := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValueDateTime);
                    end;
                FieldType::Option:
                    begin
                        ValueOption := FieldRef.Value; // Get the option value as an integer
                        OutputJsonObject.Add(FieldName, ValueOption);
                    end;
                FieldType::Boolean:
                    begin
                        ValueBoolean := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValueBoolean);
                    end;
                FieldType::Code:
                    begin
                        ValueCode := FieldRef.Value;
                        OutputJsonObject.Add(FieldName, ValueCode);
                    end;
            end;
        end;

        exit(OutputJsonObject);
    end;
}
