CREATE TABLE Dim_Feedback
(Feedback_SK int identity(9999,1) PRIMARY KEY,
 FeedbackType varchar(255),
 CategoryType varchar(max),
 CategorySubType varchar(255),
 MeasureType varchar(255)
 )
