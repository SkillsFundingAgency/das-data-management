CREATE TABLE [AsData_PL].[EVS_PaymentStatus]
(
	[PaymentStatusId] [smallint] NOT NULL,
	[PaymentStatus] [varchar](50) NULL,
	[AsDm_UpdatedDateTime]	DateTime2 default(getdate())
)