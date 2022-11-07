CREATE PROCEDURE [dbo].[GetChildPipelines]
    @RunId int,
    @MasterPipelinName VARCHAR(200)
AS
BEGIN TRY
    DECLARE @LogID int

    SELECT mp.PipelineName as MasterPipeline,
           cp.PipelineName as ChildPipeline,
           ExecutionOrder
    FROM [Mgmt].[Config_PipelineController] pc
        INNER JOIN [Mgmt].[Pipeline] mp
            on pc.MasterPipelineId = mp.PipelineId
        INNER JOIN [Mgmt].[Pipeline] cp
            on pc.ChildPipelineId = cp.PipelineId
    where pc.IsEnabled = 1
    order by ExecutionOrder

END TRY
BEGIN CATCH 

    INSERT INTO Mgmt.Log_Error_Details
    (
        UserName,
        ErrorNumber,
        ErrorState,
        ErrorSeverity,
        ErrorLine,
        ErrorProcedure,
        ErrorMessage,
        ErrorDateTime,
        RunId,
        ErrorADFTaskType
    )
    SELECT SUSER_SNAME(),
           ERROR_NUMBER(),
           ERROR_STATE(),
           ERROR_SEVERITY(),
           ERROR_LINE(),
           'GetChildPipelines',
           ERROR_MESSAGE(),
           GETDATE(),
           @RunId as RunId,
           'GetChildPipelines'; 

END CATCH