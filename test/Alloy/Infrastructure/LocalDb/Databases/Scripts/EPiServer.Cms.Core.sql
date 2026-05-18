-- This script was sourced from the EPiServer.Cms.Core nupkg (episerver.cms.core\13.0.2\tools\EPiServer.Cms.Core.sql) --
-- EPiServer.Cms.Core database script--
--beginvalidatingquery
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_DatabaseVersion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
		select 0, 'The episerver cms core database is already installed'
	else
		select 1, 'Ok'
--endvalidatingquery
GO
/* Please run the below section of statements against the database name that the above [$(DatabaseName)] variable is assigned to. */
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                DATE_CORRELATION_OPTIMIZATION OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, OPERATION_MODE = READ_WRITE, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creating User-Defined Table Type [dbo].[ApplicationHostTable]...';


GO
CREATE TYPE [dbo].[ApplicationHostTable] AS TABLE (
    [Authority]           NVARCHAR (MAX) NULL,
    [Type]                INT            NULL,
    [Locale]              NVARCHAR (255) NULL,
    [UseSecureConnection] BIT            NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ScopedPropertyTable]...';


GO
CREATE TYPE [dbo].[ScopedPropertyTable] AS TABLE (
    [PropertyDefinitionID] INT            NULL,
    [ScopeName]            NVARCHAR (450) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[LongParameterTable]...';


GO
CREATE TYPE [dbo].[LongParameterTable] AS TABLE (
    [Id] BIGINT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ApplicationUrlFormatTable]...';


GO
CREATE TYPE [dbo].[ApplicationUrlFormatTable] AS TABLE (
    [fkContentTypeGUID] UNIQUEIDENTIFIER NULL,
    [Base]              NVARCHAR (50)    NULL,
    [Type]              INT              NULL,
    [Format]            NVARCHAR (MAX)   NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ScopeNameParameterTable]...';


GO
CREATE TYPE [dbo].[ScopeNameParameterTable] AS TABLE (
    [ScopeName] NVARCHAR (450) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[HostDefinitionTable]...';


GO
CREATE TYPE [dbo].[HostDefinitionTable] AS TABLE (
    [Name]     VARCHAR (MAX) NULL,
    [Type]     INT           NULL,
    [Language] VARCHAR (50)  NULL,
    [Https]    BIT           NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ChangeNotificationStringTable]...';


GO
CREATE TYPE [dbo].[ChangeNotificationStringTable] AS TABLE (
    [Value] NVARCHAR (450) COLLATE Latin1_General_BIN2 NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[PropertyBindingDefinitionTable]...';


GO
CREATE TYPE [dbo].[PropertyBindingDefinitionTable] AS TABLE (
    [SourcePropertyDefinition]      VARCHAR (255) NULL,
    [TargetPropertyDefinition]      VARCHAR (255) NULL,
    [SubContentBindingDefinitionID] INT           NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ChangeNotificationGuidTable]...';


GO
CREATE TYPE [dbo].[ChangeNotificationGuidTable] AS TABLE (
    [Value] UNIQUEIDENTIFIER NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ChangeNotificationIntTable]...';


GO
CREATE TYPE [dbo].[ChangeNotificationIntTable] AS TABLE (
    [Value] INT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[IDTable]...';


GO
CREATE TYPE [dbo].[IDTable] AS TABLE (
    [ID] INT NOT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[SavePropertyTableType]...';


GO
CREATE TYPE [dbo].[SavePropertyTableType] AS TABLE (
    [PropertyDefinitionID] INT              NULL,
    [ScopeName]            NVARCHAR (450)   NULL,
    [ListIndex]            INT              NULL,
    [Number]               INT              NULL,
    [Boolean]              BIT              NULL,
    [Date]                 DATETIME2 (7)    NULL,
    [FloatNumber]          FLOAT (53)       NULL,
    [ContentType]          INT              NULL,
    [String]               NVARCHAR (450)   NULL,
    [LinkGuid]             UNIQUEIDENTIFIER NULL,
    [ContentLink]          INT              NULL,
    [LongString]           NVARCHAR (MAX)   NULL,
    [BranchSpecificScope]  BIT              NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[BigTableDeleteItemInternalTable]...';


GO
CREATE TYPE [dbo].[BigTableDeleteItemInternalTable] AS TABLE (
    [Id]         BIGINT        NULL,
    [NestLevel]  INT           NULL,
    [ObjectPath] VARCHAR (MAX) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[InlineBlockUsageTable]...';


GO
CREATE TYPE [dbo].[InlineBlockUsageTable] AS TABLE (
    [ContentTypeID]              INT            NOT NULL,
    [ScopeName]                  NVARCHAR (450) NOT NULL,
    [PropertyDefinitionID]       INT            NOT NULL,
    [ParentPropertyDefinitionID] INT            NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[AddApprovalDefinitionReviewerTable]...';


GO
CREATE TYPE [dbo].[AddApprovalDefinitionReviewerTable] AS TABLE (
    [StepIndex]          INT            NOT NULL,
    [Username]           NVARCHAR (255) NOT NULL,
    [fkLanguageBranchID] INT            NOT NULL,
    [ReviewerType]       INT            NOT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ProjectMemberTable]...';


GO
CREATE TYPE [dbo].[ProjectMemberTable] AS TABLE (
    [ID]   INT           NULL,
    [Name] VARCHAR (255) NULL,
    [Type] SMALLINT      NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ContentLanguageTable]...';


GO
CREATE TYPE [dbo].[ContentLanguageTable] AS TABLE (
    [ContentID]  INT NULL,
    [LanguageID] INT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ContentReferenceTable]...';


GO
CREATE TYPE [dbo].[ContentReferenceTable] AS TABLE (
    [ID]       INT            NULL,
    [WorkID]   INT            NULL,
    [Provider] NVARCHAR (255) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ContentDataBindingTable]...';


GO
CREATE TYPE [dbo].[ContentDataBindingTable] AS TABLE (
    [BindingDefinitionID] INT              NULL,
    [ScopeName]           NVARCHAR (450)   NOT NULL,
    [ReferencedID]        UNIQUEIDENTIFIER NOT NULL,
    [ReferencedLanguage]  NVARCHAR (255)   NOT NULL,
    [ExternalIdentifier]  NVARCHAR (255)   NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[UriPartsTable]...';


GO
CREATE TYPE [dbo].[UriPartsTable] AS TABLE (
    [Host] NVARCHAR (255)  NOT NULL,
    [Path] NVARCHAR (2048) NOT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[AddApprovalDefinitionStepTable]...';


GO
CREATE TYPE [dbo].[AddApprovalDefinitionStepTable] AS TABLE (
    [StepIndex]      INT            NOT NULL,
    [StepName]       NVARCHAR (255) NULL,
    [ApprovesNeeded] INT            NULL,
    [SelfApprove]    BIT            NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[editDeletePageInternalTable]...';


GO
CREATE TYPE [dbo].[editDeletePageInternalTable] AS TABLE (
    [pkID]     INT              NOT NULL PRIMARY KEY CLUSTERED ([pkID] ASC),
    [PageGUID] UNIQUEIDENTIFIER NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[DateTimeConversion_DateTimeOffset]...';


GO
CREATE TYPE [dbo].[DateTimeConversion_DateTimeOffset] AS TABLE (
    [IntervalStart] DATETIME2 (7) NOT NULL,
    [IntervalEnd]   DATETIME2 (7) NOT NULL,
    [Offset]        FLOAT (53)    NOT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ContentBindingTable]...';


GO
CREATE TYPE [dbo].[ContentBindingTable] AS TABLE (
    [BindingDefinitionID] INT              NULL,
    [ScopeName]           NVARCHAR (450)   NOT NULL,
    [ReferencedID]        UNIQUEIDENTIFIER NOT NULL,
    [ReferencedLanguage]  NVARCHAR (255)   NOT NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[GuidParameterTable]...';


GO
CREATE TYPE [dbo].[GuidParameterTable] AS TABLE (
    [Id] UNIQUEIDENTIFIER NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[ProjectItemTable]...';


GO
CREATE TYPE [dbo].[ProjectItemTable] AS TABLE (
    [ID]                  INT            NULL,
    [ProjectID]           INT            NULL,
    [ContentLinkID]       INT            NULL,
    [ContentLinkWorkID]   INT            NULL,
    [ContentLinkProvider] NVARCHAR (255) NULL,
    [Language]            NVARCHAR (17)  NULL,
    [Category]            NVARCHAR (255) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[StringParameterTable]...';


GO
CREATE TYPE [dbo].[StringParameterTable] AS TABLE (
    [String] NVARCHAR (255) NULL);


GO
PRINT N'Creating User-Defined Table Type [dbo].[AddApprovalTable]...';


GO
CREATE TYPE [dbo].[AddApprovalTable] AS TABLE (
    [ApprovalDefinitionVersionID] INT            NOT NULL,
    [ApprovalKey]                 NVARCHAR (255) NOT NULL,
    [LanguageBranchID]            INT            NOT NULL);


GO
PRINT N'Creating Table [dbo].[tblApprovalStepDecision]...';


GO
CREATE TABLE [dbo].[tblApprovalStepDecision] (
    [pkID]              INT            IDENTITY (1, 1) NOT NULL,
    [fkApprovalID]      INT            NOT NULL,
    [StepIndex]         INT            NOT NULL,
    [Approve]           BIT            NOT NULL,
    [DecisionScope]     INT            NOT NULL,
    [Username]          NVARCHAR (255) NOT NULL,
    [DecisionTimeStamp] DATETIME2 (7)  NOT NULL,
    [Comment]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblApprovalStepDecision] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblApprovalStepDecision].[IDX_tblApprovalStepDecision_fkApprovalID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApprovalStepDecision_fkApprovalID]
    ON [dbo].[tblApprovalStepDecision]([fkApprovalID] ASC);


GO
PRINT N'Creating Table [dbo].[tblBigTableIdentity]...';


GO
CREATE TABLE [dbo].[tblBigTableIdentity] (
    [pkId]      BIGINT           IDENTITY (1, 1) NOT NULL,
    [Guid]      UNIQUEIDENTIFIER NOT NULL,
    [StoreName] NVARCHAR (375)   NOT NULL,
    CONSTRAINT [PK_tblBigTableIdentity] PRIMARY KEY CLUSTERED ([pkId] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblBigTableIdentity].[IDX_tblBigTableIdentity_Guid]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTableIdentity_Guid]
    ON [dbo].[tblBigTableIdentity]([Guid] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentProperty]...';


GO
CREATE TABLE [dbo].[tblContentProperty] (
    [pkID]                   BIGINT           IDENTITY (1, 1) NOT NULL,
    [fkPropertyDefinitionID] INT              NOT NULL,
    [fkContentID]            INT              NOT NULL,
    [fkLanguageBranchID]     INT              NOT NULL,
    [ScopeName]              NVARCHAR (450)   NULL,
    [guid]                   UNIQUEIDENTIFIER NOT NULL,
    [Boolean]                BIT              NOT NULL,
    [Number]                 INT              NULL,
    [FloatNumber]            FLOAT (53)       NULL,
    [ContentType]            INT              NULL,
    [ContentLink]            INT              NULL,
    [Date]                   DATETIME2 (7)    NULL,
    [String]                 NVARCHAR (450)   NULL,
    [LongString]             NVARCHAR (MAX)   NULL,
    [LongStringLength]       INT              NULL,
    [LinkGuid]               UNIQUEIDENTIFIER NULL,
    [ListIndex]              INT              NULL,
    [BranchSpecificScope]    BIT              NULL,
    CONSTRAINT [PK_tblContentProperty] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentProperty].[IDX_tblContentProperty_fkContentID]...';


GO
CREATE CLUSTERED INDEX [IDX_tblContentProperty_fkContentID]
    ON [dbo].[tblContentProperty]([fkContentID] ASC, [fkLanguageBranchID] ASC, [fkPropertyDefinitionID] ASC, [BranchSpecificScope] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentProperty].[IDX_tblContentProperty_ContentTypeID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_ContentTypeID]
    ON [dbo].[tblContentProperty]([ContentType] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentProperty].[IDX_tblContentProperty_ContentLink]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_ContentLink]
    ON [dbo].[tblContentProperty]([ContentLink] ASC, [LinkGuid] ASC)
    INCLUDE([fkPropertyDefinitionID], [fkContentID], [fkLanguageBranchID]);


GO
PRINT N'Creating Index [dbo].[tblContentProperty].[IDX_tblContentProperty_ScopeName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_ScopeName]
    ON [dbo].[tblContentProperty]([ScopeName] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentProperty].[IX_tblContentProperty_guid]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblContentProperty_guid]
    ON [dbo].[tblContentProperty]([guid] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentProperty].[IDX_tblContentProperty_fkPropertyDefinitionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_fkPropertyDefinitionID]
    ON [dbo].[tblContentProperty]([fkPropertyDefinitionID] ASC);


GO
PRINT N'Creating Table [dbo].[tblIndexRequestLog]...';


GO
CREATE TABLE [dbo].[tblIndexRequestLog] (
    [pkId]               BIGINT           NOT NULL,
    [Row]                INT              NOT NULL,
    [StoreName]          NVARCHAR (375)   NOT NULL,
    [ItemType]           NVARCHAR (2000)  NOT NULL,
    [Boolean01]          BIT              NULL,
    [Boolean02]          BIT              NULL,
    [Boolean03]          BIT              NULL,
    [Boolean04]          BIT              NULL,
    [Boolean05]          BIT              NULL,
    [Integer01]          INT              NULL,
    [Integer02]          INT              NULL,
    [Integer03]          INT              NULL,
    [Integer04]          INT              NULL,
    [Integer05]          INT              NULL,
    [Integer06]          INT              NULL,
    [Integer07]          INT              NULL,
    [Integer08]          INT              NULL,
    [Integer09]          INT              NULL,
    [Integer10]          INT              NULL,
    [Long01]             BIGINT           NULL,
    [Long02]             BIGINT           NULL,
    [Long03]             BIGINT           NULL,
    [Long04]             BIGINT           NULL,
    [Long05]             BIGINT           NULL,
    [DateTime01]         DATETIME2 (7)    NULL,
    [DateTime02]         DATETIME2 (7)    NULL,
    [DateTime03]         DATETIME2 (7)    NULL,
    [DateTime04]         DATETIME2 (7)    NULL,
    [DateTime05]         DATETIME2 (7)    NULL,
    [Guid01]             UNIQUEIDENTIFIER NULL,
    [Guid02]             UNIQUEIDENTIFIER NULL,
    [Guid03]             UNIQUEIDENTIFIER NULL,
    [Float01]            FLOAT (53)       NULL,
    [Float02]            FLOAT (53)       NULL,
    [Float03]            FLOAT (53)       NULL,
    [Float04]            FLOAT (53)       NULL,
    [Float05]            FLOAT (53)       NULL,
    [Float06]            FLOAT (53)       NULL,
    [Float07]            FLOAT (53)       NULL,
    [String01]           NVARCHAR (MAX)   NULL,
    [String02]           NVARCHAR (MAX)   NULL,
    [String03]           NVARCHAR (MAX)   NULL,
    [String04]           NVARCHAR (MAX)   NULL,
    [String05]           NVARCHAR (MAX)   NULL,
    [String06]           NVARCHAR (MAX)   NULL,
    [String07]           NVARCHAR (MAX)   NULL,
    [String08]           NVARCHAR (MAX)   NULL,
    [String09]           NVARCHAR (MAX)   NULL,
    [String10]           NVARCHAR (MAX)   NULL,
    [Binary01]           VARBINARY (MAX)  NULL,
    [Binary02]           VARBINARY (MAX)  NULL,
    [Binary03]           VARBINARY (MAX)  NULL,
    [Binary04]           VARBINARY (MAX)  NULL,
    [Binary05]           VARBINARY (MAX)  NULL,
    [Indexed_Boolean01]  BIT              NULL,
    [Indexed_Integer01]  INT              NULL,
    [Indexed_Integer02]  INT              NULL,
    [Indexed_Integer03]  INT              NULL,
    [Indexed_Long01]     BIGINT           NULL,
    [Indexed_Long02]     BIGINT           NULL,
    [Indexed_DateTime01] DATETIME2 (7)    NULL,
    [Indexed_Guid01]     UNIQUEIDENTIFIER NULL,
    [Indexed_Float01]    FLOAT (53)       NULL,
    [Indexed_Float02]    FLOAT (53)       NULL,
    [Indexed_Float03]    FLOAT (53)       NULL,
    [Indexed_String01]   NVARCHAR (450)   NULL,
    [Indexed_String02]   NVARCHAR (450)   NULL,
    [Indexed_String03]   NVARCHAR (450)   NULL,
    [Indexed_Binary01]   VARBINARY (900)  NULL,
    CONSTRAINT [PK_tblIndexRequestLog] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblIndexRequestLog].[IDX_tblIndexRequestLog_Indexed_String01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblIndexRequestLog_Indexed_String01]
    ON [dbo].[tblIndexRequestLog]([Indexed_String01] ASC);


GO
PRINT N'Creating Index [dbo].[tblIndexRequestLog].[IDX_tblIndexRequestLog_StoreName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblIndexRequestLog_StoreName]
    ON [dbo].[tblIndexRequestLog]([StoreName] ASC);


GO
PRINT N'Creating Index [dbo].[tblIndexRequestLog].[IDX_tblIndexRequestLog_Indexed_DateTime01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblIndexRequestLog_Indexed_DateTime01]
    ON [dbo].[tblIndexRequestLog]([Indexed_DateTime01] ASC);


GO
PRINT N'Creating Table [dbo].[tblDisplayTemplate]...';


GO
CREATE TABLE [dbo].[tblDisplayTemplate] (
    [pkID]               INT            IDENTITY (1, 1) NOT NULL,
    [DisplayTemplateKey] NVARCHAR (255) NOT NULL,
    [Name]               NVARCHAR (255) NOT NULL,
    [NodeType]           NVARCHAR (50)  NULL,
    [BaseType]           NVARCHAR (50)  NULL,
    [ContentTypeID]      INT            NULL,
    [IsDefault]          BIT            NOT NULL,
    [Created]            DATETIME2 (7)  NULL,
    [CreatedBy]          NVARCHAR (255) NULL,
    [Saved]              DATETIME2 (7)  NULL,
    [SavedBy]            NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblDisplayTemplate] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [IX_tblDisplayTemplate_Key] UNIQUE NONCLUSTERED ([DisplayTemplateKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblSiteConfig]...';


GO
CREATE TABLE [dbo].[tblSiteConfig] (
    [pkID]          INT            IDENTITY (1, 1) NOT NULL,
    [SiteID]        VARCHAR (250)  NOT NULL,
    [PropertyName]  VARCHAR (250)  NOT NULL,
    [PropertyValue] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_tblSiteConfig] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblSiteConfig].[IX_tblSiteConfig]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblSiteConfig]
    ON [dbo].[tblSiteConfig]([SiteID] ASC, [PropertyName] ASC);


GO
PRINT N'Creating Table [dbo].[tblFrame]...';


GO
CREATE TABLE [dbo].[tblFrame] (
    [pkID]             INT            IDENTITY (1, 1) NOT NULL,
    [FrameName]        NVARCHAR (100) NOT NULL,
    [FrameDescription] NVARCHAR (255) NULL,
    [SystemFrame]      BIT            NOT NULL,
    CONSTRAINT [PK_tblFrame] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblContentTypeDefault]...';


GO
CREATE TABLE [dbo].[tblContentTypeDefault] (
    [pkID]                    INT            IDENTITY (1, 1) NOT NULL,
    [fkContentTypeID]         INT            NOT NULL,
    [fkContentLinkID]         INT            NULL,
    [fkFrameID]               INT            NULL,
    [fkArchiveContentID]      INT            NULL,
    [Name]                    NVARCHAR (255) NULL,
    [VisibleInMenu]           BIT            NOT NULL,
    [StartPublishOffsetValue] INT            NULL,
    [StartPublishOffsetType]  NCHAR (1)      NULL,
    [StopPublishOffsetValue]  INT            NULL,
    [StopPublishOffsetType]   NCHAR (1)      NULL,
    [ChildOrderRule]          INT            NOT NULL,
    [PeerOrder]               INT            NOT NULL,
    [StartPublishOffset]      INT            NULL,
    [StopPublishOffset]       INT            NULL,
    CONSTRAINT [PK_tblContentTypeDefault] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblApprovalDefinition]...';


GO
CREATE TABLE [dbo].[tblApprovalDefinition] (
    [pkID]                                 INT            IDENTITY (1, 1) NOT NULL,
    [ApprovalDefinitionKey]                NVARCHAR (255) NOT NULL,
    [fkCurrentApprovalDefinitionVersionID] INT            NULL,
    [Created]                              DATETIME2 (7)  NOT NULL,
    [CreatedBy]                            NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblApprovalDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblApprovalDefinition].[IDX_tblApprovalDefinition_fkCurrentApprovalDefinitionVersionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApprovalDefinition_fkCurrentApprovalDefinitionVersionID]
    ON [dbo].[tblApprovalDefinition]([fkCurrentApprovalDefinitionVersionID] ASC);


GO
PRINT N'Creating Index [dbo].[tblApprovalDefinition].[IDX_tblApprovalDefinition_ApprovalDefinitionKey]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApprovalDefinition_ApprovalDefinitionKey]
    ON [dbo].[tblApprovalDefinition]([ApprovalDefinitionKey] ASC);


GO
PRINT N'Creating Table [dbo].[tblVisitorGroupStatistic]...';


GO
CREATE TABLE [dbo].[tblVisitorGroupStatistic] (
    [pkId]               BIGINT           NOT NULL,
    [Row]                INT              NOT NULL,
    [StoreName]          NVARCHAR (375)   NOT NULL,
    [ItemType]           NVARCHAR (2000)  NOT NULL,
    [Boolean01]          BIT              NULL,
    [Boolean02]          BIT              NULL,
    [Boolean03]          BIT              NULL,
    [Boolean04]          BIT              NULL,
    [Boolean05]          BIT              NULL,
    [Integer01]          INT              NULL,
    [Integer02]          INT              NULL,
    [Integer03]          INT              NULL,
    [Integer04]          INT              NULL,
    [Integer05]          INT              NULL,
    [Integer06]          INT              NULL,
    [Integer07]          INT              NULL,
    [Integer08]          INT              NULL,
    [Integer09]          INT              NULL,
    [Integer10]          INT              NULL,
    [Long01]             BIGINT           NULL,
    [Long02]             BIGINT           NULL,
    [Long03]             BIGINT           NULL,
    [Long04]             BIGINT           NULL,
    [Long05]             BIGINT           NULL,
    [DateTime01]         DATETIME2 (7)    NULL,
    [DateTime02]         DATETIME2 (7)    NULL,
    [DateTime03]         DATETIME2 (7)    NULL,
    [DateTime04]         DATETIME2 (7)    NULL,
    [DateTime05]         DATETIME2 (7)    NULL,
    [Guid01]             UNIQUEIDENTIFIER NULL,
    [Guid02]             UNIQUEIDENTIFIER NULL,
    [Guid03]             UNIQUEIDENTIFIER NULL,
    [Float01]            FLOAT (53)       NULL,
    [Float02]            FLOAT (53)       NULL,
    [Float03]            FLOAT (53)       NULL,
    [Float04]            FLOAT (53)       NULL,
    [Float05]            FLOAT (53)       NULL,
    [Float06]            FLOAT (53)       NULL,
    [Float07]            FLOAT (53)       NULL,
    [String01]           NVARCHAR (MAX)   NULL,
    [String02]           NVARCHAR (MAX)   NULL,
    [String03]           NVARCHAR (MAX)   NULL,
    [String04]           NVARCHAR (MAX)   NULL,
    [String05]           NVARCHAR (MAX)   NULL,
    [String06]           NVARCHAR (MAX)   NULL,
    [String07]           NVARCHAR (MAX)   NULL,
    [String08]           NVARCHAR (MAX)   NULL,
    [String09]           NVARCHAR (MAX)   NULL,
    [String10]           NVARCHAR (MAX)   NULL,
    [Binary01]           VARBINARY (MAX)  NULL,
    [Binary02]           VARBINARY (MAX)  NULL,
    [Binary03]           VARBINARY (MAX)  NULL,
    [Binary04]           VARBINARY (MAX)  NULL,
    [Binary05]           VARBINARY (MAX)  NULL,
    [Indexed_Boolean01]  BIT              NULL,
    [Indexed_Integer01]  INT              NULL,
    [Indexed_Integer02]  INT              NULL,
    [Indexed_Integer03]  INT              NULL,
    [Indexed_Long01]     BIGINT           NULL,
    [Indexed_Long02]     BIGINT           NULL,
    [Indexed_DateTime01] DATETIME2 (7)    NULL,
    [Indexed_Guid01]     UNIQUEIDENTIFIER NULL,
    [Indexed_Float01]    FLOAT (53)       NULL,
    [Indexed_Float02]    FLOAT (53)       NULL,
    [Indexed_Float03]    FLOAT (53)       NULL,
    [Indexed_String01]   NVARCHAR (450)   NULL,
    [Indexed_String02]   NVARCHAR (450)   NULL,
    [Indexed_String03]   NVARCHAR (450)   NULL,
    [Indexed_Binary01]   VARBINARY (900)  NULL,
    CONSTRAINT [PK_tblVisitorGroupStatistic] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Integer02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Integer02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Integer02] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Float01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Float01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Float01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_DateTime01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_DateTime01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_DateTime01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Float03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Float03]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Float03] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Long01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Long01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Long01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Boolean01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Boolean01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Boolean01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Binary01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Binary01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Binary01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_String02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_String02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_String02] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Integer03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Integer03]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Integer03] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_String01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_String01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_String01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Guid01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Guid01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Guid01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Float02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Float02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Float02] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Long02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Long02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Long02] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_StoreName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_StoreName]
    ON [dbo].[tblVisitorGroupStatistic]([StoreName] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_Integer01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Integer01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Integer01] ASC);


GO
PRINT N'Creating Index [dbo].[tblVisitorGroupStatistic].[IDX_tblVisitorGroupStatistic_Indexed_String03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_String03]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_String03] ASC);


GO
PRINT N'Creating Table [dbo].[tblApprovalDefinitionReviewer]...';


GO
CREATE TABLE [dbo].[tblApprovalDefinitionReviewer] (
    [pkID]                          INT            IDENTITY (1, 1) NOT NULL,
    [fkApprovalDefinitionStepID]    INT            NOT NULL,
    [fkApprovalDefinitionVersionID] INT            NOT NULL,
    [Username]                      NVARCHAR (255) NOT NULL,
    [fkLanguageBranchID]            INT            NOT NULL,
    [ReviewerType]                  INT            NOT NULL,
    CONSTRAINT [PK_tblApprovalDefinitionReviewer] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblApprovalDefinitionReviewer].[IDX_tblApprovalDefinitionReviewer_Username]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApprovalDefinitionReviewer_Username]
    ON [dbo].[tblApprovalDefinitionReviewer]([Username] ASC);


GO
PRINT N'Creating Index [dbo].[tblApprovalDefinitionReviewer].[IDX_tblApprovalDefinitionReviewer_fkApprovalDefinitionVersionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApprovalDefinitionReviewer_fkApprovalDefinitionVersionID]
    ON [dbo].[tblApprovalDefinitionReviewer]([fkApprovalDefinitionVersionID] ASC);


GO
PRINT N'Creating Table [dbo].[tblApprovalDefinitionVersion]...';


GO
CREATE TABLE [dbo].[tblApprovalDefinitionVersion] (
    [pkID]                    INT            IDENTITY (1, 1) NOT NULL,
    [fkApprovalDefinitionID]  INT            NOT NULL,
    [SavedBy]                 NVARCHAR (255) NOT NULL,
    [Saved]                   DATETIME2 (7)  NOT NULL,
    [RequireCommentOnApprove] BIT            NOT NULL,
    [RequireCommentOnReject]  BIT            NOT NULL,
    [RequireCommentOnStart]   BIT            NOT NULL,
    [IsEnabled]               BIT            NOT NULL,
    [ApprovesNeeded]          INT            NOT NULL,
    [SelfApprove]             BIT            NOT NULL,
    CONSTRAINT [PK_tblApprovalDefinitionVersion] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblApprovalDefinitionVersion].[IDX_tblApprovalDefinitionVersion_fkApprovalDefinitionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApprovalDefinitionVersion_fkApprovalDefinitionID]
    ON [dbo].[tblApprovalDefinitionVersion]([fkApprovalDefinitionID] ASC);


GO
PRINT N'Creating Table [dbo].[tblApproval]...';


GO
CREATE TABLE [dbo].[tblApproval] (
    [pkID]                          INT            IDENTITY (1, 1) NOT NULL,
    [fkApprovalDefinitionVersionID] INT            NOT NULL,
    [ApprovalKey]                   NVARCHAR (255) NOT NULL,
    [fkLanguageBranchID]            INT            NOT NULL,
    [ActiveStepIndex]               INT            NOT NULL,
    [ActiveStepStarted]             DATETIME2 (7)  NOT NULL,
    [StepCount]                     INT            NOT NULL,
    [StartedBy]                     NVARCHAR (255) NOT NULL,
    [Started]                       DATETIME2 (7)  NOT NULL,
    [Completed]                     DATETIME2 (7)  NULL,
    [ApprovalStatus]                INT            NOT NULL,
    [CompletedComment]              NVARCHAR (MAX) NULL,
    [CompletedBy]                   NVARCHAR (255) NULL,
    [RequireCommentOnApprove]       BIT            NOT NULL,
    [RequireCommentOnReject]        BIT            NOT NULL,
    [RequireCommentOnStart]         BIT            NOT NULL,
    CONSTRAINT [PK_tblApproval] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblApproval].[IDX_tblApproval_ApprovalKeyAndStatus]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApproval_ApprovalKeyAndStatus]
    ON [dbo].[tblApproval]([ApprovalKey] ASC, [ApprovalStatus] ASC);


GO
PRINT N'Creating Index [dbo].[tblApproval].[IDX_tblApproval_fkApprovalDefinitionVersionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApproval_fkApprovalDefinitionVersionID]
    ON [dbo].[tblApproval]([fkApprovalDefinitionVersionID] ASC);


GO
PRINT N'Creating Table [dbo].[tblPropertyDefinitionGroup]...';


GO
CREATE TABLE [dbo].[tblPropertyDefinitionGroup] (
    [pkID]         INT            IDENTITY (100, 1) NOT NULL,
    [SystemGroup]  BIT            NOT NULL,
    [Access]       INT            NOT NULL,
    [GroupVisible] BIT            NOT NULL,
    [GroupOrder]   INT            NOT NULL,
    [Name]         NVARCHAR (255) NULL,
    [DisplayName]  NVARCHAR (255) NULL,
    [Created]      DATETIME2 (7)  NULL,
    [CreatedBy]    NVARCHAR (255) NULL,
    [Saved]        DATETIME2 (7)  NULL,
    [SavedBy]      NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblPropertyDefinitionGroup] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblBigTableReference]...';


GO
CREATE TABLE [dbo].[tblBigTableReference] (
    [pkId]             BIGINT           NOT NULL,
    [Type]             INT              NOT NULL,
    [PropertyName]     NVARCHAR (75)    NOT NULL,
    [CollectionType]   NVARCHAR (2000)  NULL,
    [ElementType]      NVARCHAR (2000)  NULL,
    [ElementStoreName] NVARCHAR (375)   NULL,
    [IsKey]            BIT              NOT NULL,
    [Index]            INT              NOT NULL,
    [BooleanValue]     BIT              NULL,
    [IntegerValue]     INT              NULL,
    [LongValue]        BIGINT           NULL,
    [DateTimeValue]    DATETIME2 (7)    NULL,
    [GuidValue]        UNIQUEIDENTIFIER NULL,
    [FloatValue]       FLOAT (53)       NULL,
    [StringValue]      NVARCHAR (MAX)   NULL,
    [BinaryValue]      VARBINARY (MAX)  NULL,
    [RefIdValue]       BIGINT           NULL,
    [ExternalIdValue]  BIGINT           NULL,
    [DecimalValue]     DECIMAL (18, 3)  NULL,
    CONSTRAINT [PK_tblBigTableReference] PRIMARY KEY CLUSTERED ([pkId] ASC, [PropertyName] ASC, [IsKey] ASC, [Index] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblBigTableReference].[IDX_tblBigTableReference_RefIdValue]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTableReference_RefIdValue]
    ON [dbo].[tblBigTableReference]([RefIdValue] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentBindingDefinition]...';


GO
CREATE TABLE [dbo].[tblContentBindingDefinition] (
    [pkID]                  INT              IDENTITY (1, 1) NOT NULL,
    [Key]                   NVARCHAR (255)   NOT NULL,
    [Created]               DATETIME2 (7)    NOT NULL,
    [CreatedBy]             NVARCHAR (255)   NULL,
    [Saved]                 DATETIME2 (7)    NOT NULL,
    [SavedBy]               NVARCHAR (255)   NULL,
    [SourceContentTypeGUID] UNIQUEIDENTIFIER NOT NULL,
    [TargetContentTypeGUID] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ContentBindingDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentBindingDefinition].[IDX_tblContentBinding_Key]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContentBinding_Key]
    ON [dbo].[tblContentBindingDefinition]([Key] ASC);


GO
PRINT N'Creating Table [dbo].[tblBigTableStoreInfo]...';


GO
CREATE TABLE [dbo].[tblBigTableStoreInfo] (
    [fkStoreId]         BIGINT          NOT NULL,
    [PropertyName]      NVARCHAR (75)   NOT NULL,
    [PropertyMapType]   NVARCHAR (64)   NOT NULL,
    [PropertyIndex]     INT             NOT NULL,
    [PropertyType]      NVARCHAR (2000) NOT NULL,
    [Active]            BIT             NOT NULL,
    [Version]           INT             NOT NULL,
    [ColumnName]        NVARCHAR (128)  NULL,
    [ColumnRowIndex]    INT             NULL,
    [Obsoleted]         BIT             NULL,
    [OldName]           NVARCHAR (75)   NULL,
    [DataConverterType] NVARCHAR (2000) NULL,
    CONSTRAINT [PK_tblBigTableStoreInfo] PRIMARY KEY CLUSTERED ([fkStoreId] ASC, [PropertyName] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblSynchedApplication]...';


GO
CREATE TABLE [dbo].[tblSynchedApplication] (
    [pkID]                   INT            IDENTITY (1, 1) NOT NULL,
    [ApplicationName]        NVARCHAR (255) NOT NULL,
    [LoweredApplicationName] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_tblSynchedApplication] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblSynchedApplication].[IX_tblSynchedApplication_Unique]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblSynchedApplication_Unique]
    ON [dbo].[tblSynchedApplication]([LoweredApplicationName] ASC);


GO
PRINT N'Creating Table [dbo].[tblAzureWebhookMetadata]...';


GO
CREATE TABLE [dbo].[tblAzureWebhookMetadata] (
    [pkID]           INT            IDENTITY (1, 1) NOT NULL,
    [Key]            NVARCHAR (255) NOT NULL,
    [DisplayName]    NVARCHAR (255) NULL,
    [Description]    NVARCHAR (512) NULL,
    [SavedBy]        NVARCHAR (255) NULL,
    [Saved]          DATETIME2 (7)  NOT NULL,
    [CreatedBy]      NVARCHAR (255) NULL,
    [Created]        DATETIME2 (7)  NOT NULL,
    [HasQueryString] BIT            NOT NULL,
    CONSTRAINT [PK_tblAzureWebhookMetadata] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblAzureWebhookMetadata].[IDX_tblAzureWebhookMetadata_Key]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblAzureWebhookMetadata_Key]
    ON [dbo].[tblAzureWebhookMetadata]([Key] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentLanguage]...';


GO
CREATE TABLE [dbo].[tblContentLanguage] (
    [fkContentID]        INT              NOT NULL,
    [fkLanguageBranchID] INT              NOT NULL,
    [ContentLinkGUID]    UNIQUEIDENTIFIER NULL,
    [fkFrameID]          INT              NULL,
    [CreatorName]        NVARCHAR (255)   NULL,
    [ChangedByName]      NVARCHAR (255)   NULL,
    [ContentGUID]        UNIQUEIDENTIFIER NOT NULL,
    [Name]               NVARCHAR (255)   NULL,
    [URLSegment]         NVARCHAR (255)   NULL,
    [LinkURL]            NVARCHAR (255)   NULL,
    [BlobUri]            NVARCHAR (255)   NULL,
    [ThumbnailUri]       NVARCHAR (255)   NULL,
    [ExternalURL]        NVARCHAR (255)   NULL,
    [AutomaticLink]      BIT              NOT NULL,
    [FetchData]          BIT              NOT NULL,
    [Created]            DATETIME2 (7)    NOT NULL,
    [Changed]            DATETIME2 (7)    NOT NULL,
    [Saved]              DATETIME2 (7)    NOT NULL,
    [StartPublish]       DATETIME2 (7)    NULL,
    [StopPublish]        DATETIME2 (7)    NULL,
    [Version]            INT              NULL,
    [Status]             INT              NOT NULL,
    [DelayPublishUntil]  DATETIME2 (7)    NULL,
    CONSTRAINT [PK_tblContentLanguage] PRIMARY KEY CLUSTERED ([fkContentID] ASC, [fkLanguageBranchID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_ContentGUID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContentLanguage_ContentGUID]
    ON [dbo].[tblContentLanguage]([ContentGUID] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_Name]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_Name]
    ON [dbo].[tblContentLanguage]([Name] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_ExternalURL]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_ExternalURL]
    ON [dbo].[tblContentLanguage]([ExternalURL] ASC) WHERE (ExternalURL IS NOT NULL);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_fkLanguageBranchID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_fkLanguageBranchID]
    ON [dbo].[tblContentLanguage]([fkLanguageBranchID] ASC, [fkContentID] ASC)
    INCLUDE([Name]);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_ContentLinkGUID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_ContentLinkGUID]
    ON [dbo].[tblContentLanguage]([ContentLinkGUID] ASC) WHERE (ContentLinkGUID IS NOT NULL);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_URLSegment]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_URLSegment]
    ON [dbo].[tblContentLanguage]([URLSegment] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_Version]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_Version]
    ON [dbo].[tblContentLanguage]([Version] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentLanguage].[IDX_tblContentLanguage_fkLanguageBranchID2]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_fkLanguageBranchID2]
    ON [dbo].[tblContentLanguage]([fkLanguageBranchID] ASC)
    INCLUDE([fkContentID], [StartPublish]);


GO
PRINT N'Creating Table [dbo].[tblPropertyDefinitionType]...';


GO
CREATE TABLE [dbo].[tblPropertyDefinitionType] (
    [pkID]         INT              NOT NULL,
    [Property]     INT              NOT NULL,
    [Name]         NVARCHAR (255)   NOT NULL,
    [GUID]         UNIQUEIDENTIFIER NULL,
    [TypeName]     NVARCHAR (255)   NULL,
    [AssemblyName] NVARCHAR (255)   NULL,
    [DisplayName]  NVARCHAR (255)   NULL,
    [GroupName]    NVARCHAR (50)    NULL,
    [Hidden]       BIT              NULL,
    [Created]      DATETIME2 (7)    NULL,
    [CreatedBy]    NVARCHAR (255)   NULL,
    [Saved]        DATETIME2 (7)    NULL,
    [SavedBy]      NVARCHAR (255)   NULL,
    CONSTRAINT [PK_tblPropertyDefinitionType] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblSystemBigTable]...';


GO
CREATE TABLE [dbo].[tblSystemBigTable] (
    [pkId]               BIGINT           NOT NULL,
    [Row]                INT              NOT NULL,
    [StoreName]          NVARCHAR (375)   NOT NULL,
    [ItemType]           NVARCHAR (2000)  NOT NULL,
    [Boolean01]          BIT              NULL,
    [Boolean02]          BIT              NULL,
    [Boolean03]          BIT              NULL,
    [Boolean04]          BIT              NULL,
    [Boolean05]          BIT              NULL,
    [Integer01]          INT              NULL,
    [Integer02]          INT              NULL,
    [Integer03]          INT              NULL,
    [Integer04]          INT              NULL,
    [Integer05]          INT              NULL,
    [Integer06]          INT              NULL,
    [Integer07]          INT              NULL,
    [Integer08]          INT              NULL,
    [Integer09]          INT              NULL,
    [Integer10]          INT              NULL,
    [Long01]             BIGINT           NULL,
    [Long02]             BIGINT           NULL,
    [Long03]             BIGINT           NULL,
    [Long04]             BIGINT           NULL,
    [Long05]             BIGINT           NULL,
    [DateTime01]         DATETIME2 (7)    NULL,
    [DateTime02]         DATETIME2 (7)    NULL,
    [DateTime03]         DATETIME2 (7)    NULL,
    [DateTime04]         DATETIME2 (7)    NULL,
    [DateTime05]         DATETIME2 (7)    NULL,
    [Guid01]             UNIQUEIDENTIFIER NULL,
    [Guid02]             UNIQUEIDENTIFIER NULL,
    [Guid03]             UNIQUEIDENTIFIER NULL,
    [Float01]            FLOAT (53)       NULL,
    [Float02]            FLOAT (53)       NULL,
    [Float03]            FLOAT (53)       NULL,
    [Float04]            FLOAT (53)       NULL,
    [Float05]            FLOAT (53)       NULL,
    [Float06]            FLOAT (53)       NULL,
    [Float07]            FLOAT (53)       NULL,
    [String01]           NVARCHAR (MAX)   NULL,
    [String02]           NVARCHAR (MAX)   NULL,
    [String03]           NVARCHAR (MAX)   NULL,
    [String04]           NVARCHAR (MAX)   NULL,
    [String05]           NVARCHAR (MAX)   NULL,
    [String06]           NVARCHAR (MAX)   NULL,
    [String07]           NVARCHAR (MAX)   NULL,
    [String08]           NVARCHAR (MAX)   NULL,
    [String09]           NVARCHAR (MAX)   NULL,
    [String10]           NVARCHAR (MAX)   NULL,
    [Binary01]           VARBINARY (MAX)  NULL,
    [Binary02]           VARBINARY (MAX)  NULL,
    [Binary03]           VARBINARY (MAX)  NULL,
    [Binary04]           VARBINARY (MAX)  NULL,
    [Binary05]           VARBINARY (MAX)  NULL,
    [Indexed_Boolean01]  BIT              NULL,
    [Indexed_Integer01]  INT              NULL,
    [Indexed_Integer02]  INT              NULL,
    [Indexed_Integer03]  INT              NULL,
    [Indexed_Long01]     BIGINT           NULL,
    [Indexed_Long02]     BIGINT           NULL,
    [Indexed_DateTime01] DATETIME2 (7)    NULL,
    [Indexed_Guid01]     UNIQUEIDENTIFIER NULL,
    [Indexed_Float01]    FLOAT (53)       NULL,
    [Indexed_Float02]    FLOAT (53)       NULL,
    [Indexed_Float03]    FLOAT (53)       NULL,
    [Indexed_String01]   NVARCHAR (450)   NULL,
    [Indexed_String02]   NVARCHAR (450)   NULL,
    [Indexed_String03]   NVARCHAR (450)   NULL,
    [Indexed_Binary01]   VARBINARY (900)  NULL,
    [Decimal01]          DECIMAL (18, 3)  NULL,
    [Decimal02]          DECIMAL (18, 3)  NULL,
    [Indexed_Decimal01]  DECIMAL (18, 3)  NULL,
    CONSTRAINT [PK_tblSystemBigTable] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Float01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Float01]
    ON [dbo].[tblSystemBigTable]([Indexed_Float01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_String01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_String01]
    ON [dbo].[tblSystemBigTable]([Indexed_String01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Integer03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Integer03]
    ON [dbo].[tblSystemBigTable]([Indexed_Integer03] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_StoreName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_StoreName]
    ON [dbo].[tblSystemBigTable]([StoreName] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Long02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Long02]
    ON [dbo].[tblSystemBigTable]([Indexed_Long02] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Float02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Float02]
    ON [dbo].[tblSystemBigTable]([Indexed_Float02] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Long01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Long01]
    ON [dbo].[tblSystemBigTable]([Indexed_Long01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_String02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_String02]
    ON [dbo].[tblSystemBigTable]([Indexed_String02] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Boolean01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Boolean01]
    ON [dbo].[tblSystemBigTable]([Indexed_Boolean01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Binary01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Binary01]
    ON [dbo].[tblSystemBigTable]([Indexed_Binary01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_DateTime01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_DateTime01]
    ON [dbo].[tblSystemBigTable]([Indexed_DateTime01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Float03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Float03]
    ON [dbo].[tblSystemBigTable]([Indexed_Float03] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_String03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_String03]
    ON [dbo].[tblSystemBigTable]([Indexed_String03] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Integer01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Integer01]
    ON [dbo].[tblSystemBigTable]([Indexed_Integer01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Guid01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Guid01]
    ON [dbo].[tblSystemBigTable]([Indexed_Guid01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Decimal01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Decimal01]
    ON [dbo].[tblSystemBigTable]([Indexed_Decimal01] ASC);


GO
PRINT N'Creating Index [dbo].[tblSystemBigTable].[IDX_tblSystemBigTable_Indexed_Integer02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblSystemBigTable_Indexed_Integer02]
    ON [dbo].[tblSystemBigTable]([Indexed_Integer02] ASC);


GO
PRINT N'Creating Table [dbo].[tblSynchedUserRelations]...';


GO
CREATE TABLE [dbo].[tblSynchedUserRelations] (
    [fkSynchedUser] INT NOT NULL,
    [fkSynchedRole] INT NOT NULL,
    CONSTRAINT [PK_tblSynchedUserRelations] PRIMARY KEY CLUSTERED ([fkSynchedUser] ASC, [fkSynchedRole] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblChangeNotificationProcessor]...';


GO
CREATE TABLE [dbo].[tblChangeNotificationProcessor] (
    [ProcessorId]                UNIQUEIDENTIFIER NOT NULL,
    [ChangeNotificationDataType] NVARCHAR (30)    NOT NULL,
    [ProcessorName]              NVARCHAR (4000)  NOT NULL,
    [ProcessorStatus]            NVARCHAR (30)    NOT NULL,
    [NextQueueOrderValue]        INT              NOT NULL,
    [LastConsistentDbUtc]        DATETIME2 (7)    NULL,
    CONSTRAINT [PK_ChangeNotificationProcessor] PRIMARY KEY CLUSTERED ([ProcessorId] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblPropertyDefinition]...';


GO
CREATE TABLE [dbo].[tblPropertyDefinition] (
    [pkID]                       INT              IDENTITY (1, 1) NOT NULL,
    [fkContentTypeID]            INT              NULL,
    [fkPropertyDefinitionTypeID] INT              NULL,
    [FieldOrder]                 INT              NULL,
    [Name]                       NVARCHAR (255)   NOT NULL,
    [Property]                   INT              NOT NULL,
    [Required]                   BIT              NULL,
    [Advanced]                   INT              NULL,
    [IndexingType]               INT              NULL,
    [EditCaption]                NVARCHAR (255)   NULL,
    [HelpText]                   NVARCHAR (2000)  NULL,
    [ObjectProgID]               NVARCHAR (255)   NULL,
    [DefaultValueType]           INT              NOT NULL,
    [LongStringSettings]         INT              NOT NULL,
    [SettingsID]                 UNIQUEIDENTIFIER NULL,
    [LanguageSpecific]           INT              NOT NULL,
    [DisplayEditUI]              BIT              NULL,
    [ExistsOnModel]              BIT              NOT NULL,
    [EditorHint]                 NVARCHAR (255)   NULL,
    [ImageDescriptor]            NVARCHAR (50)    NULL,
    [IsList]                     BIT              NULL,
    [Saved]                      DATETIME2 (7)    NOT NULL,
    [ItemTypeID]                 UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_tblPropertyDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblPropertyDefinition].[IDX_tblPropertyDefinition_fkPropertyDefinitionTypeID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_fkPropertyDefinitionTypeID]
    ON [dbo].[tblPropertyDefinition]([fkPropertyDefinitionTypeID] ASC);


GO
PRINT N'Creating Index [dbo].[tblPropertyDefinition].[IDX_tblPropertyDefinition_ContentTypeAndName]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_ContentTypeAndName]
    ON [dbo].[tblPropertyDefinition]([fkContentTypeID] ASC, [Name] ASC);


GO
PRINT N'Creating Index [dbo].[tblPropertyDefinition].[IDX_tblPropertyDefinition_fkContentTypeID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_fkContentTypeID]
    ON [dbo].[tblPropertyDefinition]([fkContentTypeID] ASC);


GO
PRINT N'Creating Index [dbo].[tblPropertyDefinition].[IDX_tblPropertyDefinition_Name]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_Name]
    ON [dbo].[tblPropertyDefinition]([Name] ASC);


GO
PRINT N'Creating Table [dbo].[tblDisplaySetting]...';


GO
CREATE TABLE [dbo].[tblDisplaySetting] (
    [fkTemplateId]      INT            NOT NULL,
    [SortOrder]         INT            NOT NULL,
    [DisplaySettingKey] NVARCHAR (255) NOT NULL,
    [Name]              NVARCHAR (255) NOT NULL,
    [Editor]            NVARCHAR (50)  NULL,
    [Choices]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblDisplaySetting] PRIMARY KEY CLUSTERED ([fkTemplateId] ASC, [DisplaySettingKey] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblWorkContentProperty]...';


GO
CREATE TABLE [dbo].[tblWorkContentProperty] (
    [pkID]                   BIGINT           IDENTITY (1, 1) NOT NULL,
    [fkPropertyDefinitionID] INT              NOT NULL,
    [fkWorkContentID]        INT              NOT NULL,
    [ScopeName]              NVARCHAR (450)   NULL,
    [guid]                   UNIQUEIDENTIFIER NOT NULL,
    [Boolean]                BIT              NOT NULL,
    [Number]                 INT              NULL,
    [FloatNumber]            FLOAT (53)       NULL,
    [ContentType]            INT              NULL,
    [ContentLink]            INT              NULL,
    [Date]                   DATETIME2 (7)    NULL,
    [String]                 NVARCHAR (450)   NULL,
    [LongString]             NVARCHAR (MAX)   NULL,
    [LinkGuid]               UNIQUEIDENTIFIER NULL,
    [ListIndex]              INT              NULL,
    [BranchSpecificScope]    BIT              NULL,
    CONSTRAINT [PK_tblWorkProperty] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblWorkContentProperty].[IX_tblWorkContentProperty_fkWorkContentID]...';


GO
CREATE CLUSTERED INDEX [IX_tblWorkContentProperty_fkWorkContentID]
    ON [dbo].[tblWorkContentProperty]([fkWorkContentID] ASC, [BranchSpecificScope] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContentProperty].[IDX_tblWorkContentProperty_fkPropertyDefinitionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_fkPropertyDefinitionID]
    ON [dbo].[tblWorkContentProperty]([fkPropertyDefinitionID] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContentProperty].[IDX_tblWorkContentProperty_ScopeName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_ScopeName]
    ON [dbo].[tblWorkContentProperty]([ScopeName] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContentProperty].[IDX_tblWorkContentProperty_ContentTypeID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_ContentTypeID]
    ON [dbo].[tblWorkContentProperty]([ContentType] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContentProperty].[IDX_tblWorkContentProperty_ContentLink]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_ContentLink]
    ON [dbo].[tblWorkContentProperty]([ContentLink] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContentProperty].[IX_tblWorkContentProperty_guid]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblWorkContentProperty_guid]
    ON [dbo].[tblWorkContentProperty]([guid] ASC);


GO
PRINT N'Creating Table [dbo].[tblChangeNotificationQueuedGuid]...';


GO
CREATE TABLE [dbo].[tblChangeNotificationQueuedGuid] (
    [ProcessorId]  UNIQUEIDENTIFIER NOT NULL,
    [ConnectionId] UNIQUEIDENTIFIER NULL,
    [QueueOrder]   INT              NOT NULL,
    [Value]        UNIQUEIDENTIFIER NOT NULL
);


GO
PRINT N'Creating Index [dbo].[tblChangeNotificationQueuedGuid].[IDX_tblChangeNotificationQueuedGuid]...';


GO
CREATE CLUSTERED INDEX [IDX_tblChangeNotificationQueuedGuid]
    ON [dbo].[tblChangeNotificationQueuedGuid]([ProcessorId] ASC, [QueueOrder] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentSoftlink]...';


GO
CREATE TABLE [dbo].[tblContentSoftlink] (
    [pkID]                        BIGINT           IDENTITY (1, 1) NOT NULL,
    [fkOwnerContentID]            INT              NOT NULL,
    [fkReferencedContentGUID]     UNIQUEIDENTIFIER NULL,
    [OwnerLanguageID]             INT              NULL,
    [ReferencedLanguageID]        INT              NULL,
    [LinkURL]                     NVARCHAR (2048)  NOT NULL,
    [LinkType]                    INT              NOT NULL,
    [LinkProtocol]                NVARCHAR (10)    NULL,
    [ContentLink]                 NVARCHAR (255)   NULL,
    [LastCheckedDate]             DATETIME2 (7)    NULL,
    [FirstDateBroken]             DATETIME2 (7)    NULL,
    [HttpStatusCode]              INT              NULL,
    [fkOwnerPropertyDefinitionID] INT              NULL,
    [ExtendedData]                NVARCHAR (MAX)   NULL,
    [ProviderName]                NVARCHAR (255)   NULL,
    CONSTRAINT [PK_tblContentSoftlink] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentSoftlink].[IDX_tblContentSoftlink_ProviderName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentSoftlink_ProviderName]
    ON [dbo].[tblContentSoftlink]([ProviderName] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentSoftlink].[IDX_tblContentSoftlink_fkReferencedContentGUID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentSoftlink_fkReferencedContentGUID]
    ON [dbo].[tblContentSoftlink]([fkReferencedContentGUID] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentSoftlink].[IDX_tblContentSoftlink_fkContentID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentSoftlink_fkContentID]
    ON [dbo].[tblContentSoftlink]([fkOwnerContentID] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentSoftlink].[IDX_tblContentSoftlink_ContentLink]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentSoftlink_ContentLink]
    ON [dbo].[tblContentSoftlink]([ContentLink] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentVariation]...';


GO
CREATE TABLE [dbo].[tblContentVariation] (
    [pkID]       INT            IDENTITY (1, 1) NOT NULL,
    [Key]        NVARCHAR (255) NOT NULL,
    [LoweredKey] NVARCHAR (255) NOT NULL,
    [Saved]      DATETIME2 (7)  NULL,
    [SavedBy]    NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblContentVariation] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentVariation].[IDX_tblContentVariation_LoweredKey]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentVariation_LoweredKey]
    ON [dbo].[tblContentVariation]([LoweredKey] ASC);


GO
PRINT N'Creating Table [dbo].[tblNotificationSubscription]...';


GO
CREATE TABLE [dbo].[tblNotificationSubscription] (
    [pkID]            INT            IDENTITY (1, 1) NOT NULL,
    [UserName]        NVARCHAR (255) NOT NULL,
    [SubscriptionKey] NVARCHAR (255) NOT NULL,
    [Active]          BIT            NOT NULL,
    CONSTRAINT [PK_tblNotificationSubscription] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblNotificationSubscription].[IDX_tblNotificationSubscription_SubscriptionKey]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationSubscription_SubscriptionKey]
    ON [dbo].[tblNotificationSubscription]([SubscriptionKey] ASC, [Active] ASC)
    INCLUDE([UserName]);


GO
PRINT N'Creating Index [dbo].[tblNotificationSubscription].[IDX_tblNotificationSubscription_UserName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationSubscription_UserName]
    ON [dbo].[tblNotificationSubscription]([UserName] ASC);


GO
PRINT N'Creating Table [dbo].[tblActivityLogComment]...';


GO
CREATE TABLE [dbo].[tblActivityLogComment] (
    [pkID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [EntryId]     BIGINT         NOT NULL,
    [Author]      NVARCHAR (255) NULL,
    [Created]     DATETIME2 (7)  NOT NULL,
    [LastUpdated] DATETIME2 (7)  NOT NULL,
    [Message]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblActivityLogComment] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblActivityLogComment].[IDX_tblActivityLogComment_EntryId]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLogComment_EntryId]
    ON [dbo].[tblActivityLogComment]([EntryId] ASC);


GO
PRINT N'Creating Table [dbo].[tblBigTable]...';


GO
CREATE TABLE [dbo].[tblBigTable] (
    [pkId]               BIGINT           NOT NULL,
    [Row]                INT              NOT NULL,
    [StoreName]          NVARCHAR (375)   NOT NULL,
    [ItemType]           NVARCHAR (2000)  NOT NULL,
    [Boolean01]          BIT              NULL,
    [Boolean02]          BIT              NULL,
    [Boolean03]          BIT              NULL,
    [Boolean04]          BIT              NULL,
    [Boolean05]          BIT              NULL,
    [Integer01]          INT              NULL,
    [Integer02]          INT              NULL,
    [Integer03]          INT              NULL,
    [Integer04]          INT              NULL,
    [Integer05]          INT              NULL,
    [Integer06]          INT              NULL,
    [Integer07]          INT              NULL,
    [Integer08]          INT              NULL,
    [Integer09]          INT              NULL,
    [Integer10]          INT              NULL,
    [Long01]             BIGINT           NULL,
    [Long02]             BIGINT           NULL,
    [Long03]             BIGINT           NULL,
    [Long04]             BIGINT           NULL,
    [Long05]             BIGINT           NULL,
    [DateTime01]         DATETIME2 (7)    NULL,
    [DateTime02]         DATETIME2 (7)    NULL,
    [DateTime03]         DATETIME2 (7)    NULL,
    [DateTime04]         DATETIME2 (7)    NULL,
    [DateTime05]         DATETIME2 (7)    NULL,
    [Guid01]             UNIQUEIDENTIFIER NULL,
    [Guid02]             UNIQUEIDENTIFIER NULL,
    [Guid03]             UNIQUEIDENTIFIER NULL,
    [Float01]            FLOAT (53)       NULL,
    [Float02]            FLOAT (53)       NULL,
    [Float03]            FLOAT (53)       NULL,
    [Float04]            FLOAT (53)       NULL,
    [Float05]            FLOAT (53)       NULL,
    [Float06]            FLOAT (53)       NULL,
    [Float07]            FLOAT (53)       NULL,
    [Decimal01]          DECIMAL (18, 3)  NULL,
    [Decimal02]          DECIMAL (18, 3)  NULL,
    [String01]           NVARCHAR (MAX)   NULL,
    [String02]           NVARCHAR (MAX)   NULL,
    [String03]           NVARCHAR (MAX)   NULL,
    [String04]           NVARCHAR (MAX)   NULL,
    [String05]           NVARCHAR (MAX)   NULL,
    [String06]           NVARCHAR (MAX)   NULL,
    [String07]           NVARCHAR (MAX)   NULL,
    [String08]           NVARCHAR (MAX)   NULL,
    [String09]           NVARCHAR (MAX)   NULL,
    [String10]           NVARCHAR (MAX)   NULL,
    [Binary01]           VARBINARY (MAX)  NULL,
    [Binary02]           VARBINARY (MAX)  NULL,
    [Binary03]           VARBINARY (MAX)  NULL,
    [Binary04]           VARBINARY (MAX)  NULL,
    [Binary05]           VARBINARY (MAX)  NULL,
    [Indexed_Boolean01]  BIT              NULL,
    [Indexed_Integer01]  INT              NULL,
    [Indexed_Integer02]  INT              NULL,
    [Indexed_Integer03]  INT              NULL,
    [Indexed_Long01]     BIGINT           NULL,
    [Indexed_Long02]     BIGINT           NULL,
    [Indexed_DateTime01] DATETIME2 (7)    NULL,
    [Indexed_Guid01]     UNIQUEIDENTIFIER NULL,
    [Indexed_Float01]    FLOAT (53)       NULL,
    [Indexed_Float02]    FLOAT (53)       NULL,
    [Indexed_Float03]    FLOAT (53)       NULL,
    [Indexed_Decimal01]  DECIMAL (18, 3)  NULL,
    [Indexed_String01]   NVARCHAR (450)   NULL,
    [Indexed_String02]   NVARCHAR (450)   NULL,
    [Indexed_String03]   NVARCHAR (450)   NULL,
    [Indexed_Binary01]   VARBINARY (900)  NULL,
    CONSTRAINT [PK_tblBigTable] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Integer03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Integer03]
    ON [dbo].[tblBigTable]([Indexed_Integer03] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Long02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Long02]
    ON [dbo].[tblBigTable]([Indexed_Long02] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Float03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Float03]
    ON [dbo].[tblBigTable]([Indexed_Float03] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Binary01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Binary01]
    ON [dbo].[tblBigTable]([Indexed_Binary01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_DateTime01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_DateTime01]
    ON [dbo].[tblBigTable]([Indexed_DateTime01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_StoreName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_StoreName]
    ON [dbo].[tblBigTable]([StoreName] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Decimal01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Decimal01]
    ON [dbo].[tblBigTable]([Indexed_Decimal01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Float01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Float01]
    ON [dbo].[tblBigTable]([Indexed_Float01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Integer01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Integer01]
    ON [dbo].[tblBigTable]([Indexed_Integer01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_String02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_String02]
    ON [dbo].[tblBigTable]([Indexed_String02] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Float02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Float02]
    ON [dbo].[tblBigTable]([Indexed_Float02] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_String03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_String03]
    ON [dbo].[tblBigTable]([Indexed_String03] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Integer02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Integer02]
    ON [dbo].[tblBigTable]([Indexed_Integer02] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Long01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Long01]
    ON [dbo].[tblBigTable]([Indexed_Long01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_String01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_String01]
    ON [dbo].[tblBigTable]([Indexed_String01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Boolean01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Boolean01]
    ON [dbo].[tblBigTable]([Indexed_Boolean01] ASC);


GO
PRINT N'Creating Index [dbo].[tblBigTable].[IDX_tblBigTable_Indexed_Guid01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTable_Indexed_Guid01]
    ON [dbo].[tblBigTable]([Indexed_Guid01] ASC);


GO
PRINT N'Creating Table [dbo].[tblActivityArchive]...';


GO
CREATE TABLE [dbo].[tblActivityArchive] (
    [pkID]       BIGINT         NOT NULL,
    [LogData]    NVARCHAR (MAX) NULL,
    [ChangeDate] DATETIME2 (7)  NOT NULL,
    [Type]       NVARCHAR (50)  NOT NULL,
    [Action]     INT            NOT NULL,
    [ChangedBy]  NVARCHAR (255) NOT NULL,
    [Deleted]    BIT            NOT NULL,
    CONSTRAINT [PK_tblActivityArchive] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblApplicationHost]...';


GO
CREATE TABLE [dbo].[tblApplicationHost] (
    [pkID]                INT            IDENTITY (1, 1) NOT NULL,
    [fkApplicationID]     INT            NOT NULL,
    [Authority]           NVARCHAR (MAX) NOT NULL,
    [Type]                INT            NOT NULL,
    [Locale]              NVARCHAR (255) NULL,
    [UseSecureConnection] BIT            NOT NULL,
    [PreferredUrlScheme]  BIT            NOT NULL,
    CONSTRAINT [PK_tblApplicationHost] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblApprovalDefinitionStep]...';


GO
CREATE TABLE [dbo].[tblApprovalDefinitionStep] (
    [pkID]                          INT            IDENTITY (1, 1) NOT NULL,
    [fkApprovalDefinitionVersionID] INT            NOT NULL,
    [StepIndex]                     INT            NOT NULL,
    [StepName]                      NVARCHAR (255) NULL,
    [ApprovesNeeded]                INT            NULL,
    [SelfApprove]                   BIT            NULL,
    CONSTRAINT [PK_tblApprovalDefinitionStep] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblApprovalDefinitionStep].[IDX_tblApprovalDefinitionStep_fkApprovalDefinitionVersionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblApprovalDefinitionStep_fkApprovalDefinitionVersionID]
    ON [dbo].[tblApprovalDefinitionStep]([fkApprovalDefinitionVersionID] ASC);


GO
PRINT N'Creating Table [dbo].[tblApplication]...';


GO
CREATE TABLE [dbo].[tblApplication] (
    [pkID]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]              NVARCHAR (255) NOT NULL,
    [DisplayName]       NVARCHAR (255) NOT NULL,
    [Type]              INT            NOT NULL,
    [Created]           DATETIME2 (7)  NOT NULL,
    [CreatedBy]         NVARCHAR (255) NULL,
    [Saved]             DATETIME2 (7)  NULL,
    [SavedBy]           NVARCHAR (255) NULL,
    [Source]            NVARCHAR (255) NULL,
    [RoutingEntryPoint] NVARCHAR (255) NULL,
    [UsePreviewTokens]  BIT            NOT NULL,
    [fkAssetsRootID]    INT            NULL,
    [IsDefault]         BIT            NOT NULL,
    [IsResourceable]    BIT            NOT NULL,
    CONSTRAINT [PK_tblApplication] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblApplication].[UQ_tblApplication_Name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_tblApplication_Name]
    ON [dbo].[tblApplication]([Name] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentLanguageSetting]...';


GO
CREATE TABLE [dbo].[tblContentLanguageSetting] (
    [fkContentID]            INT             NOT NULL,
    [fkLanguageBranchID]     INT             NOT NULL,
    [fkReplacementBranchID]  INT             NULL,
    [LanguageBranchFallback] NVARCHAR (1000) NULL,
    [Active]                 BIT             NOT NULL,
    CONSTRAINT [PK_tblContentLanguageSetting] PRIMARY KEY CLUSTERED ([fkContentID] ASC, [fkLanguageBranchID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblContentTypeContract]...';


GO
CREATE TABLE [dbo].[tblContentTypeContract] (
    [pkID]          INT              IDENTITY (1, 1) NOT NULL,
    [ContractID]    UNIQUEIDENTIFIER NOT NULL,
    [ContentTypeID] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_tblContentTypeContract] PRIMARY KEY CLUSTERED ([ContractID] ASC, [pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentTypeContract].[IDX_tblContentTypeContract_ContentTypeID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentTypeContract_ContentTypeID]
    ON [dbo].[tblContentTypeContract]([ContentTypeID] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentTypeContract].[IDX_tblContentTypeContract_ContractID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentTypeContract_ContractID]
    ON [dbo].[tblContentTypeContract]([ContractID] ASC);


GO
PRINT N'Creating Table [dbo].[tblHostDefinition]...';


GO
CREATE TABLE [dbo].[tblHostDefinition] (
    [pkID]     INT           IDENTITY (1, 1) NOT NULL,
    [fkSiteID] INT           NOT NULL,
    [Name]     VARCHAR (MAX) NOT NULL,
    [Type]     INT           NOT NULL,
    [Language] VARCHAR (50)  NULL,
    [Https]    BIT           NULL,
    CONSTRAINT [PK_tblHostDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblHostDefinition].[IX_tblHostDefinition_fkID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblHostDefinition_fkID]
    ON [dbo].[tblHostDefinition]([fkSiteID] ASC);


GO
PRINT N'Creating Table [dbo].[tblScheduledItem]...';


GO
CREATE TABLE [dbo].[tblScheduledItem] (
    [pkID]                 UNIQUEIDENTIFIER NOT NULL,
    [Name]                 NVARCHAR (50)    NULL,
    [Enabled]              BIT              NOT NULL,
    [LastExec]             DATETIME2 (7)    NULL,
    [LastStatus]           INT              NULL,
    [LastText]             NVARCHAR (MAX)   NULL,
    [NextExec]             DATETIME2 (7)    NULL,
    [DatePart]             NCHAR (2)        NULL,
    [Interval]             INT              NULL,
    [MethodName]           NVARCHAR (100)   NOT NULL,
    [fStatic]              BIT              NOT NULL,
    [TypeName]             NVARCHAR (1024)  NOT NULL,
    [AssemblyName]         NVARCHAR (100)   NOT NULL,
    [IsRunning]            BIT              NOT NULL,
    [CurrentStatusMessage] NVARCHAR (2048)  NULL,
    [LastPing]             DATETIME2 (7)    NULL,
    [IsStoppable]          BIT              NOT NULL,
    [LastExecutionAttempt] INT              NOT NULL,
    [Restartable]          BIT              NOT NULL,
    [Hidden]               BIT              NOT NULL,
    [StoppedResponding]    BIT              NOT NULL,
    CONSTRAINT [PK__tblScheduledItem__1940BAED] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblProject]...';


GO
CREATE TABLE [dbo].[tblProject] (
    [pkID]                    INT            IDENTITY (1, 1) NOT NULL,
    [Name]                    NVARCHAR (255) NOT NULL,
    [IsPublic]                BIT            NOT NULL,
    [Created]                 DATETIME2 (7)  NOT NULL,
    [CreatedBy]               NVARCHAR (255) NOT NULL,
    [Status]                  INT            NOT NULL,
    [PublishingTrackingToken] NVARCHAR (255) NULL,
    [DelayPublishUntil]       DATETIME2 (7)  NULL,
    [Alias]                   NVARCHAR (255) NOT NULL,
    [Source]                  NVARCHAR (255) NULL,
    [Saved]                   DATETIME2 (7)  NOT NULL,
    [SavedBy]                 NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblProject] PRIMARY KEY CLUSTERED ([pkID] ASC),
    UNIQUE NONCLUSTERED ([Alias] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblProject].[IX_tblProject_StatusName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblProject_StatusName]
    ON [dbo].[tblProject]([Status] ASC, [Name] ASC);


GO
PRINT N'Creating Table [dbo].[tblTaskInformation]...';


GO
CREATE TABLE [dbo].[tblTaskInformation] (
    [pkId]               BIGINT           NOT NULL,
    [Row]                INT              NOT NULL,
    [StoreName]          NVARCHAR (375)   NOT NULL,
    [ItemType]           NVARCHAR (2000)  NOT NULL,
    [Boolean01]          BIT              NULL,
    [Boolean02]          BIT              NULL,
    [Integer01]          INT              NULL,
    [Long01]             BIGINT           NULL,
    [DateTime01]         DATETIME2 (7)    NULL,
    [Guid01]             UNIQUEIDENTIFIER NULL,
    [Float01]            FLOAT (53)       NULL,
    [String01]           NVARCHAR (MAX)   NULL,
    [Indexed_Integer01]  INT              NULL,
    [Indexed_DateTime01] DATETIME2 (7)    NULL,
    [Indexed_DateTime02] DATETIME2 (7)    NULL,
    [Indexed_Guid01]     UNIQUEIDENTIFIER NULL,
    [Indexed_String01]   NVARCHAR (450)   NULL,
    [Indexed_String02]   NVARCHAR (450)   NULL,
    CONSTRAINT [PK_tblTaskInformation] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblTaskInformation].[IDX_tblTaskInformation_Indexed_Guid01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_Guid01]
    ON [dbo].[tblTaskInformation]([Indexed_Guid01] ASC);


GO
PRINT N'Creating Index [dbo].[tblTaskInformation].[IDX_tblTaskInformation_Indexed_DateTime01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_DateTime01]
    ON [dbo].[tblTaskInformation]([Indexed_DateTime01] ASC);


GO
PRINT N'Creating Index [dbo].[tblTaskInformation].[IDX_tblTaskInformation_Indexed_String01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_String01]
    ON [dbo].[tblTaskInformation]([Indexed_String01] ASC);


GO
PRINT N'Creating Index [dbo].[tblTaskInformation].[IDX_tblTaskInformation_StoreName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_StoreName]
    ON [dbo].[tblTaskInformation]([StoreName] ASC);


GO
PRINT N'Creating Index [dbo].[tblTaskInformation].[IDX_tblTaskInformation_Indexed_Integer01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_Integer01]
    ON [dbo].[tblTaskInformation]([Indexed_Integer01] ASC);


GO
PRINT N'Creating Index [dbo].[tblTaskInformation].[IDX_tblTaskInformation_Indexed_String02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_String02]
    ON [dbo].[tblTaskInformation]([Indexed_String02] ASC);


GO
PRINT N'Creating Index [dbo].[tblTaskInformation].[IDX_tblTaskInformation_Indexed_DateTime02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_DateTime02]
    ON [dbo].[tblTaskInformation]([Indexed_DateTime02] ASC);


GO
PRINT N'Creating Table [dbo].[tblPropertyBindingDefinition]...';


GO
CREATE TABLE [dbo].[tblPropertyBindingDefinition] (
    [pkID]                            INT           IDENTITY (1, 1) NOT NULL,
    [fkContentBindingDefinitionID]    INT           NOT NULL,
    [SourcePropertyDefinition]        VARCHAR (255) NOT NULL,
    [TargetPropertyDefinition]        VARCHAR (255) NOT NULL,
    [fkSubContentBindingDefinitionID] INT           NULL,
    CONSTRAINT [PK_PropertyBindingDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblActivityLog]...';


GO
CREATE TABLE [dbo].[tblActivityLog] (
    [pkID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [LogData]     NVARCHAR (MAX) NULL,
    [ChangeDate]  DATETIME2 (7)  NOT NULL,
    [Type]        NVARCHAR (50)  NOT NULL,
    [Action]      INT            NOT NULL,
    [ChangedBy]   NVARCHAR (255) NOT NULL,
    [RelatedItem] NVARCHAR (255) NULL,
    [Deleted]     BIT            NOT NULL,
    CONSTRAINT [PK_tblActivityLog] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblActivityLog].[IDX_tblActivityLog_ChangeDate]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLog_ChangeDate]
    ON [dbo].[tblActivityLog]([ChangeDate] ASC);


GO
PRINT N'Creating Index [dbo].[tblActivityLog].[IDX_tblActivityLog_Pkid_ChangeDate]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLog_Pkid_ChangeDate]
    ON [dbo].[tblActivityLog]([pkID] ASC, [ChangeDate] ASC);


GO
PRINT N'Creating Index [dbo].[tblActivityLog].[IDX_tblActivityLog_RelatedItem]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLog_RelatedItem]
    ON [dbo].[tblActivityLog]([RelatedItem] ASC)
    INCLUDE([Deleted]);


GO
PRINT N'Creating Table [dbo].[tblContentType]...';


GO
CREATE TABLE [dbo].[tblContentType] (
    [pkID]                     INT              IDENTITY (1, 1) NOT NULL,
    [ContentTypeGUID]          UNIQUEIDENTIFIER NOT NULL,
    [Created]                  DATETIME2 (7)    NOT NULL,
    [Saved]                    DATETIME2 (7)    NULL,
    [SavedBy]                  NVARCHAR (255)   NULL,
    [DefaultMvcController]     NVARCHAR (1024)  NULL,
    [DefaultMvcPartialView]    NVARCHAR (255)   NULL,
    [ModelType]                NVARCHAR (1024)  NULL,
    [Name]                     NVARCHAR (255)   NOT NULL,
    [DisplayName]              NVARCHAR (255)   NULL,
    [Description]              NVARCHAR (255)   NULL,
    [IdString]                 NVARCHAR (50)    NULL,
    [Available]                BIT              NULL,
    [SortOrder]                INT              NULL,
    [MetaDataInherit]          INT              NOT NULL,
    [MetaDataDefault]          INT              NOT NULL,
    [WorkflowEditFields]       BIT              NULL,
    [ACL]                      NVARCHAR (MAX)   NULL,
    [ContentType]              INT              NOT NULL,
    [Base]                     NVARCHAR (50)    NULL,
    [Version]                  NVARCHAR (50)    NULL,
    [SupportedMediaExtensions] NVARCHAR (255)   NULL,
    [GroupName]                NVARCHAR (50)    NULL,
    [CompositionBehavior]      NVARCHAR (450)   NULL,
    [IsContract]               BIT              NOT NULL,
    [Source]                   NVARCHAR (255)   NULL,
    [CreatedBy]                NVARCHAR (255)   NULL,
    CONSTRAINT [PK_tblContentType] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentType].[IDX_tblContentType_ContentTypeGUID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContentType_ContentTypeGUID]
    ON [dbo].[tblContentType]([ContentTypeGUID] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentType].[IDX_tblContentType_Name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContentType_Name]
    ON [dbo].[tblContentType]([Name] ASC);


GO
PRINT N'Creating Table [dbo].[tblProjectMember]...';


GO
CREATE TABLE [dbo].[tblProjectMember] (
    [pkID]        INT            IDENTITY (1, 1) NOT NULL,
    [fkProjectID] INT            NOT NULL,
    [Name]        NVARCHAR (255) NOT NULL,
    [Type]        SMALLINT       NOT NULL,
    CONSTRAINT [PK_tblProjectMember] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblProjectMember].[IX_tblProjectMember_fkProjectID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblProjectMember_fkProjectID]
    ON [dbo].[tblProjectMember]([fkProjectID] ASC);


GO
PRINT N'Creating Table [dbo].[tblApplicationUrlFormat]...';


GO
CREATE TABLE [dbo].[tblApplicationUrlFormat] (
    [pkID]              INT              IDENTITY (1, 1) NOT NULL,
    [fkApplicationID]   INT              NOT NULL,
    [fkContentTypeGUID] UNIQUEIDENTIFIER NULL,
    [Base]              NVARCHAR (50)    NULL,
    [Type]              INT              NOT NULL,
    [Format]            NVARCHAR (MAX)   NOT NULL,
    CONSTRAINT [PK_tblApplicationUrlFormat] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblUserPermission]...';


GO
CREATE TABLE [dbo].[tblUserPermission] (
    [pkID]       INT            IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (255) NOT NULL,
    [IsRole]     INT            NOT NULL,
    [Permission] NVARCHAR (150) NOT NULL,
    [GroupName]  NVARCHAR (150) NOT NULL,
    CONSTRAINT [PK_tblUserPermission] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblUserPermission].[IX_tblUserPermission_Permission_GroupName]...';


GO
CREATE CLUSTERED INDEX [IX_tblUserPermission_Permission_GroupName]
    ON [dbo].[tblUserPermission]([Permission] ASC, [GroupName] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentCategory]...';


GO
CREATE TABLE [dbo].[tblContentCategory] (
    [pkID]               INT            IDENTITY (1, 1) NOT NULL,
    [fkContentID]        INT            NOT NULL,
    [fkCategoryID]       INT            NOT NULL,
    [CategoryType]       INT            NOT NULL,
    [fkLanguageBranchID] INT            NOT NULL,
    [ScopeName]          NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_tblContentCategory] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentCategory].[IDX_tblContentCategory_fkContentID]...';


GO
CREATE CLUSTERED INDEX [IDX_tblContentCategory_fkContentID]
    ON [dbo].[tblContentCategory]([fkContentID] ASC, [CategoryType] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentCategory].[IDX_tblContentCategory_fkCategoryID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentCategory_fkCategoryID]
    ON [dbo].[tblContentCategory]([fkCategoryID] ASC)
    INCLUDE([fkContentID], [CategoryType], [fkLanguageBranchID]);


GO
PRINT N'Creating Table [dbo].[tblWorkContentCategory]...';


GO
CREATE TABLE [dbo].[tblWorkContentCategory] (
    [pkID]            INT            IDENTITY (1, 1) NOT NULL,
    [fkWorkContentID] INT            NOT NULL,
    [fkCategoryID]    INT            NOT NULL,
    [CategoryType]    INT            NOT NULL,
    [ScopeName]       NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_tblWorkContentCategory] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblWorkContentCategory].[IDX_tblWorkContentCategory_fkWorkContentID]...';


GO
CREATE CLUSTERED INDEX [IDX_tblWorkContentCategory_fkWorkContentID]
    ON [dbo].[tblWorkContentCategory]([fkWorkContentID] ASC, [CategoryType] ASC);


GO
PRINT N'Creating Table [dbo].[tblInlineBlockUsage]...';


GO
CREATE TABLE [dbo].[tblInlineBlockUsage] (
    [pkID]                         BIGINT         IDENTITY (1, 1) NOT NULL,
    [fkContentTypeID]              INT            NOT NULL,
    [fkContentID]                  INT            NOT NULL,
    [fkWorkContentID]              INT            NOT NULL,
    [ScopeName]                    NVARCHAR (450) NOT NULL,
    [fkPropertyDefinitionID]       INT            NOT NULL,
    [fkParentPropertyDefinitionID] INT            NULL,
    CONSTRAINT [PK_tblInlineBlockUsage] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblInlineBlockUsage].[IDX_tblInlineBlockUsage_fkContentTypeID]...';


GO
CREATE CLUSTERED INDEX [IDX_tblInlineBlockUsage_fkContentTypeID]
    ON [dbo].[tblInlineBlockUsage]([fkContentTypeID] ASC);


GO
PRINT N'Creating Index [dbo].[tblInlineBlockUsage].[IDX_tblInlineBlockUsage_fkPropertyDefinitionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblInlineBlockUsage_fkPropertyDefinitionID]
    ON [dbo].[tblInlineBlockUsage]([fkPropertyDefinitionID] ASC);


GO
PRINT N'Creating Index [dbo].[tblInlineBlockUsage].[IDX_tblInlineBlockUsage_ScopeName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblInlineBlockUsage_ScopeName]
    ON [dbo].[tblInlineBlockUsage]([ScopeName] ASC);


GO
PRINT N'Creating Table [dbo].[tblPropertyDefinitionDefault]...';


GO
CREATE TABLE [dbo].[tblPropertyDefinitionDefault] (
    [pkID]                   INT              IDENTITY (1, 1) NOT NULL,
    [fkPropertyDefinitionID] INT              NOT NULL,
    [Boolean]                BIT              NOT NULL,
    [Number]                 INT              NULL,
    [FloatNumber]            FLOAT (53)       NULL,
    [ContentType]            INT              NULL,
    [ContentLink]            INT              NULL,
    [Date]                   DATETIME2 (7)    NULL,
    [String]                 NVARCHAR (450)   NULL,
    [LongString]             NVARCHAR (MAX)   NULL,
    [LinkGuid]               UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_tblPropertyDefinitionDefault] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblContentAccess]...';


GO
CREATE TABLE [dbo].[tblContentAccess] (
    [fkContentID] INT            NOT NULL,
    [Name]        NVARCHAR (255) NOT NULL,
    [IsRole]      INT            NOT NULL,
    [AccessMask]  INT            NOT NULL,
    CONSTRAINT [PK_tblContentAccess] PRIMARY KEY CLUSTERED ([fkContentID] ASC, [Name] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblXFormData]...';


GO
CREATE TABLE [dbo].[tblXFormData] (
    [pkId]             BIGINT           NOT NULL,
    [Row]              INT              NOT NULL,
    [StoreName]        NVARCHAR (375)   NOT NULL,
    [ItemType]         NVARCHAR (2000)  NOT NULL,
    [ChannelOptions]   INT              NULL,
    [DatePosted]       DATETIME2 (7)    NULL,
    [FormId]           UNIQUEIDENTIFIER NULL,
    [PageGuid]         UNIQUEIDENTIFIER NULL,
    [UserName]         NVARCHAR (450)   NULL,
    [String01]         NVARCHAR (MAX)   NULL,
    [String02]         NVARCHAR (MAX)   NULL,
    [String03]         NVARCHAR (MAX)   NULL,
    [String04]         NVARCHAR (MAX)   NULL,
    [String05]         NVARCHAR (MAX)   NULL,
    [String06]         NVARCHAR (MAX)   NULL,
    [String07]         NVARCHAR (MAX)   NULL,
    [String08]         NVARCHAR (MAX)   NULL,
    [String09]         NVARCHAR (MAX)   NULL,
    [String10]         NVARCHAR (MAX)   NULL,
    [String11]         NVARCHAR (MAX)   NULL,
    [String12]         NVARCHAR (MAX)   NULL,
    [String13]         NVARCHAR (MAX)   NULL,
    [String14]         NVARCHAR (MAX)   NULL,
    [String15]         NVARCHAR (MAX)   NULL,
    [String16]         NVARCHAR (MAX)   NULL,
    [String17]         NVARCHAR (MAX)   NULL,
    [String18]         NVARCHAR (MAX)   NULL,
    [String19]         NVARCHAR (MAX)   NULL,
    [String20]         NVARCHAR (MAX)   NULL,
    [Indexed_String01] NVARCHAR (450)   NULL,
    [Indexed_String02] NVARCHAR (450)   NULL,
    [Indexed_String03] NVARCHAR (450)   NULL,
    CONSTRAINT [PK_tblXFormData] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblXFormData].[IDX_tblXFormData_String03]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblXFormData_String03]
    ON [dbo].[tblXFormData]([Indexed_String03] ASC);


GO
PRINT N'Creating Index [dbo].[tblXFormData].[IDX_tblXFormData_String01]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblXFormData_String01]
    ON [dbo].[tblXFormData]([Indexed_String01] ASC);


GO
PRINT N'Creating Index [dbo].[tblXFormData].[IDX_tblXFormData_String02]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblXFormData_String02]
    ON [dbo].[tblXFormData]([Indexed_String02] ASC);


GO
PRINT N'Creating Table [dbo].[tblWorkContent]...';


GO
CREATE TABLE [dbo].[tblWorkContent] (
    [pkID]               INT              IDENTITY (1, 1) NOT NULL,
    [fkContentID]        INT              NOT NULL,
    [fkMasterVersionID]  INT              NULL,
    [ContentLinkGUID]    UNIQUEIDENTIFIER NULL,
    [fkFrameID]          INT              NULL,
    [ArchiveContentGUID] UNIQUEIDENTIFIER NULL,
    [ChangedByName]      NVARCHAR (255)   NOT NULL,
    [NewStatusByName]    NVARCHAR (255)   NULL,
    [Name]               NVARCHAR (255)   NULL,
    [URLSegment]         NVARCHAR (255)   NULL,
    [LinkURL]            NVARCHAR (255)   NULL,
    [BlobUri]            NVARCHAR (255)   NULL,
    [ThumbnailUri]       NVARCHAR (255)   NULL,
    [ExternalURL]        NVARCHAR (255)   NULL,
    [VisibleInMenu]      BIT              NOT NULL,
    [LinkType]           INT              NOT NULL,
    [Created]            DATETIME2 (7)    NOT NULL,
    [Saved]              DATETIME2 (7)    NOT NULL,
    [StartPublish]       DATETIME2 (7)    NULL,
    [StopPublish]        DATETIME2 (7)    NULL,
    [ChildOrderRule]     INT              NOT NULL,
    [PeerOrder]          INT              NOT NULL,
    [ChangedOnPublish]   BIT              NOT NULL,
    [RejectComment]      NVARCHAR (2000)  NULL,
    [fkLanguageBranchID] INT              NOT NULL,
    [CommonDraft]        BIT              NOT NULL,
    [fkVariationID]      INT              NULL,
    [Status]             INT              NOT NULL,
    [DelayPublishUntil]  DATETIME2 (7)    NULL,
    CONSTRAINT [PK_tblWorkContent] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_StatusFields]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_StatusFields]
    ON [dbo].[tblWorkContent]([Status] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_Name]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_Name]
    ON [dbo].[tblWorkContent]([Name] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_fkMasterVersionID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_fkMasterVersionID]
    ON [dbo].[tblWorkContent]([fkMasterVersionID] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_BlobUri]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_BlobUri]
    ON [dbo].[tblWorkContent]([BlobUri] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_fkVariationID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_fkVariationID]
    ON [dbo].[tblWorkContent]([fkVariationID] ASC) WHERE [fkVariationID] IS NOT NULL;


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_fkContentID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_fkContentID]
    ON [dbo].[tblWorkContent]([fkContentID] ASC)
    INCLUDE([fkLanguageBranchID], [Name]);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_ContentLinkGUID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_ContentLinkGUID]
    ON [dbo].[tblWorkContent]([ContentLinkGUID] ASC) WHERE (ContentLinkGUID IS NOT NULL);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_ChangedByName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_ChangedByName]
    ON [dbo].[tblWorkContent]([ChangedByName] ASC)
    INCLUDE([Name], [Status]) WHERE ([ChangedByName] <> '');


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_ArchiveContentGUID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_ArchiveContentGUID]
    ON [dbo].[tblWorkContent]([ArchiveContentGUID] ASC);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_DelayPublishUntil]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_DelayPublishUntil]
    ON [dbo].[tblWorkContent]([DelayPublishUntil] DESC);


GO
PRINT N'Creating Index [dbo].[tblWorkContent].[IDX_tblWorkContent_fkLanguageBranchID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_fkLanguageBranchID]
    ON [dbo].[tblWorkContent]([fkLanguageBranchID] ASC);


GO
PRINT N'Creating Table [dbo].[tblChangeNotificationConnection]...';


GO
CREATE TABLE [dbo].[tblChangeNotificationConnection] (
    [ConnectionId]      UNIQUEIDENTIFIER NOT NULL,
    [ProcessorId]       UNIQUEIDENTIFIER NOT NULL,
    [IsOpen]            BIT              NOT NULL,
    [LastActivityDbUtc] DATETIME2 (7)    NOT NULL,
    CONSTRAINT [PK_ChangeNotificationConnection] PRIMARY KEY CLUSTERED ([ConnectionId] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblSynchedUser]...';


GO
CREATE TABLE [dbo].[tblSynchedUser] (
    [pkID]             INT            IDENTITY (1, 1) NOT NULL,
    [UserName]         NVARCHAR (255) NOT NULL,
    [LoweredUserName]  NVARCHAR (255) NOT NULL,
    [Email]            NVARCHAR (255) NULL,
    [GivenName]        NVARCHAR (255) NULL,
    [LoweredGivenName] NVARCHAR (255) NULL,
    [Surname]          NVARCHAR (255) NULL,
    [LoweredSurname]   NVARCHAR (255) NULL,
    [Metadata]         NVARCHAR (MAX) NULL,
    [RolesHash]        INT            NULL,
    [LastSynced]       DATETIME2 (7)  NULL,
    CONSTRAINT [PK_tblWindowsUser] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblSynchedUser].[IX_tblWindowsUser_LoweredGivenName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblWindowsUser_LoweredGivenName]
    ON [dbo].[tblSynchedUser]([LoweredGivenName] ASC);


GO
PRINT N'Creating Index [dbo].[tblSynchedUser].[IX_tblWindowsUser_LoweredSurname]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblWindowsUser_LoweredSurname]
    ON [dbo].[tblSynchedUser]([LoweredSurname] ASC);


GO
PRINT N'Creating Index [dbo].[tblSynchedUser].[IX_tblWindowsUser_Email]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblWindowsUser_Email]
    ON [dbo].[tblSynchedUser]([Email] ASC);


GO
PRINT N'Creating Index [dbo].[tblSynchedUser].[IX_tblWindowsUser_Unique]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblWindowsUser_Unique]
    ON [dbo].[tblSynchedUser]([LoweredUserName] ASC);


GO
PRINT N'Creating Table [dbo].[tblUniqueSequence]...';


GO
CREATE TABLE [dbo].[tblUniqueSequence] (
    [Name]      NVARCHAR (255) NOT NULL,
    [LastValue] INT            NOT NULL,
    CONSTRAINT [PK_tblUniqueSequence] PRIMARY KEY CLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblProjectItem]...';


GO
CREATE TABLE [dbo].[tblProjectItem] (
    [pkID]                INT            IDENTITY (1, 1) NOT NULL,
    [fkProjectID]         INT            NOT NULL,
    [ContentLinkID]       INT            NOT NULL,
    [ContentLinkWorkID]   INT            NOT NULL,
    [ContentLinkProvider] NVARCHAR (255) NOT NULL,
    [Language]            VARCHAR (17)   NOT NULL,
    [Category]            NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_tblProjectItem] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblProjectItem].[IX_tblProjectItem_fkProjectID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblProjectItem_fkProjectID]
    ON [dbo].[tblProjectItem]([fkProjectID] ASC, [Category] ASC, [Language] ASC);


GO
PRINT N'Creating Index [dbo].[tblProjectItem].[IX_tblProjectItem_ContentLink]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblProjectItem_ContentLink]
    ON [dbo].[tblProjectItem]([ContentLinkID] ASC, [ContentLinkProvider] ASC, [ContentLinkWorkID] ASC);


GO
PRINT N'Creating Table [dbo].[tblMappedIdentity]...';


GO
CREATE TABLE [dbo].[tblMappedIdentity] (
    [pkID]                   INT              IDENTITY (1, 1) NOT NULL,
    [Provider]               NVARCHAR (255)   NOT NULL,
    [ProviderUniqueId]       NVARCHAR (450)   NOT NULL,
    [ContentGuid]            UNIQUEIDENTIFIER NOT NULL,
    [ExistingContentId]      INT              NULL,
    [ExistingCustomProvider] BIT              NULL,
    [Metadata]               NVARCHAR (MAX)   NULL,
    [Saved]                  DATETIME2 (7)    NULL,
    CONSTRAINT [PK_tblMappedIdentity] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblMappedIdentity].[IDX_tblMappedIdentity_ProviderUniqueId]...';


GO
CREATE CLUSTERED INDEX [IDX_tblMappedIdentity_ProviderUniqueId]
    ON [dbo].[tblMappedIdentity]([ProviderUniqueId] ASC);


GO
PRINT N'Creating Index [dbo].[tblMappedIdentity].[IDX_tblMappedIdentity_Provider]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblMappedIdentity_Provider]
    ON [dbo].[tblMappedIdentity]([Provider] ASC);


GO
PRINT N'Creating Index [dbo].[tblMappedIdentity].[IDX_tblMappedIdentity_ExistingContentId]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblMappedIdentity_ExistingContentId]
    ON [dbo].[tblMappedIdentity]([ExistingContentId] ASC) WHERE ExistingContentId IS NOT NULL;


GO
PRINT N'Creating Index [dbo].[tblMappedIdentity].[IDX_tblMappedIdentity_ExternalId]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblMappedIdentity_ExternalId]
    ON [dbo].[tblMappedIdentity]([ExistingContentId] ASC, [ExistingCustomProvider] ASC);


GO
PRINT N'Creating Index [dbo].[tblMappedIdentity].[IDX_tblMappedIdentity_ContentGuid]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblMappedIdentity_ContentGuid]
    ON [dbo].[tblMappedIdentity]([ContentGuid] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentTypeToContentType]...';


GO
CREATE TABLE [dbo].[tblContentTypeToContentType] (
    [fkContentTypeParentID] INT            NOT NULL,
    [fkContentTypeChildID]  INT            NOT NULL,
    [Access]                INT            NOT NULL,
    [Availability]          INT            NOT NULL,
    [Allow]                 BIT            NULL,
    [Saved]                 DATETIME2 (7)  NULL,
    [SavedBy]               NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblContentTypeToContentType] PRIMARY KEY CLUSTERED ([fkContentTypeParentID] ASC, [fkContentTypeChildID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblScheduledItemLog]...';


GO
CREATE TABLE [dbo].[tblScheduledItemLog] (
    [pkID]              INT              IDENTITY (1, 1) NOT NULL,
    [fkScheduledItemId] UNIQUEIDENTIFIER NOT NULL,
    [Exec]              DATETIME2 (7)    NOT NULL,
    [Status]            INT              NULL,
    [Text]              NVARCHAR (MAX)   NULL,
    [Duration]          BIGINT           NULL,
    [Server]            NVARCHAR (255)   NULL,
    [Trigger]           INT              NULL,
    CONSTRAINT [PK_tblScheduledItemLog] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblScheduledItemLog].[IX_tblScheduledItemLog_fkScheduledItemId]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblScheduledItemLog_fkScheduledItemId]
    ON [dbo].[tblScheduledItemLog]([fkScheduledItemId] ASC);


GO
PRINT N'Creating Table [dbo].[tblEntityType]...';


GO
CREATE TABLE [dbo].[tblEntityType] (
    [intID]   INT           IDENTITY (1, 1) NOT NULL,
    [strName] VARCHAR (400) NOT NULL,
    CONSTRAINT [PK_tblEntityType] PRIMARY KEY CLUSTERED ([intID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblSynchedUserRole]...';


GO
CREATE TABLE [dbo].[tblSynchedUserRole] (
    [pkID]            INT            IDENTITY (1, 1) NOT NULL,
    [RoleName]        NVARCHAR (255) NOT NULL,
    [LoweredRoleName] NVARCHAR (255) NOT NULL,
    [Enabled]         BIT            NOT NULL,
    CONSTRAINT [PK_tblSynchedUserRole] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblSynchedUserRole].[IX_tblSynchedUserRole_Unique]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblSynchedUserRole_Unique]
    ON [dbo].[tblSynchedUserRole]([LoweredRoleName] ASC);


GO
PRINT N'Creating Table [dbo].[tblNotificationMessage]...';


GO
CREATE TABLE [dbo].[tblNotificationMessage] (
    [pkID]        INT            IDENTITY (1, 1) NOT NULL,
    [Sender]      NVARCHAR (255) NULL,
    [Recipient]   NVARCHAR (255) NOT NULL,
    [Channel]     NVARCHAR (50)  NULL,
    [Type]        NVARCHAR (50)  NULL,
    [Subject]     NVARCHAR (255) NULL,
    [Content]     NVARCHAR (MAX) NULL,
    [Sent]        DATETIME2 (7)  NULL,
    [SendAt]      DATETIME2 (7)  NULL,
    [Saved]       DATETIME2 (7)  NOT NULL,
    [Failed]      DATETIME2 (7)  NULL,
    [RetriesLeft] INT            NULL,
    [Read]        DATETIME2 (7)  NULL,
    [Category]    NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblNotificationMessage] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblNotificationMessage].[IDX_tblNotificationMessage_SendAt]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationMessage_SendAt]
    ON [dbo].[tblNotificationMessage]([SendAt] ASC);


GO
PRINT N'Creating Index [dbo].[tblNotificationMessage].[IDX_tblNotificationMessage_RecipientUnread]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationMessage_RecipientUnread]
    ON [dbo].[tblNotificationMessage]([Recipient] ASC, [Read] ASC) WHERE [Read] IS NULL;


GO
PRINT N'Creating Index [dbo].[tblNotificationMessage].[IDX_tblNotificationMessage_Read]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationMessage_Read]
    ON [dbo].[tblNotificationMessage]([Read] ASC);


GO
PRINT N'Creating Index [dbo].[tblNotificationMessage].[IDX_tblNotificationMessage_Sent]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotificationMessage_Sent]
    ON [dbo].[tblNotificationMessage]([Sent] ASC);


GO
PRINT N'Creating Table [dbo].[tblBlobPendingDelete]...';


GO
CREATE TABLE [dbo].[tblBlobPendingDelete] (
    [pkID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [fkContentId] INT            NOT NULL,
    [BlobUri]     NVARCHAR (255) NOT NULL,
    [Provider]    NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblBlobPendingDelete] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblTree]...';


GO
CREATE TABLE [dbo].[tblTree] (
    [fkParentID]   INT      NOT NULL,
    [fkChildID]    INT      NOT NULL,
    [NestingLevel] SMALLINT NOT NULL,
    CONSTRAINT [PK_tblTree] PRIMARY KEY CLUSTERED ([fkParentID] ASC, [fkChildID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblTree].[IDX_tblTree_fkChildID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblTree_fkChildID]
    ON [dbo].[tblTree]([fkChildID] ASC);


GO
PRINT N'Creating Table [dbo].[tblLanguageBranch]...';


GO
CREATE TABLE [dbo].[tblLanguageBranch] (
    [pkID]               INT            IDENTITY (1, 1) NOT NULL,
    [LanguageID]         NCHAR (17)     NOT NULL,
    [Name]               NVARCHAR (255) NULL,
    [SortIndex]          INT            NOT NULL,
    [SystemIconPath]     NVARCHAR (255) NULL,
    [URLSegment]         NVARCHAR (255) NULL,
    [ACL]                NVARCHAR (MAX) NULL,
    [Enabled]            BIT            NOT NULL,
    [fkFallbackBranchId] INT            NULL,
    [Created]            DATETIME2 (7)  NOT NULL,
    [CreatedBy]          NVARCHAR (255) NULL,
    [Saved]              DATETIME2 (7)  NOT NULL,
    [SavedBy]            NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblLanguageBranch] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [IX_tblLanguageBranch] UNIQUE NONCLUSTERED ([LanguageID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblSiteDefinition]...';


GO
CREATE TABLE [dbo].[tblSiteDefinition] (
    [pkID]           INT              IDENTITY (1, 1) NOT NULL,
    [UniqueId]       UNIQUEIDENTIFIER NOT NULL,
    [Name]           NVARCHAR (255)   NOT NULL,
    [StartPage]      VARCHAR (255)    NULL,
    [SiteUrl]        VARCHAR (MAX)    NULL,
    [SiteAssetsRoot] VARCHAR (255)    NULL,
    [SavedBy]        NVARCHAR (255)   NULL,
    [Saved]          DATETIME2 (7)    NULL,
    CONSTRAINT [PK_tblSiteDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblSiteDefinition].[IX_tblSiteDefinition_UniqueId]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblSiteDefinition_UniqueId]
    ON [dbo].[tblSiteDefinition]([UniqueId] ASC);


GO
PRINT N'Creating Table [dbo].[tblChangeNotificationQueuedString]...';


GO
CREATE TABLE [dbo].[tblChangeNotificationQueuedString] (
    [ProcessorId]  UNIQUEIDENTIFIER NOT NULL,
    [ConnectionId] UNIQUEIDENTIFIER NULL,
    [QueueOrder]   INT              NOT NULL,
    [Value]        NVARCHAR (450)   COLLATE Latin1_General_BIN2 NOT NULL
);


GO
PRINT N'Creating Index [dbo].[tblChangeNotificationQueuedString].[IDX_tblChangeNotificationQueuedString]...';


GO
CREATE CLUSTERED INDEX [IDX_tblChangeNotificationQueuedString]
    ON [dbo].[tblChangeNotificationQueuedString]([ProcessorId] ASC, [QueueOrder] ASC);


GO
PRINT N'Creating Table [dbo].[tblActivityLogAssociation]...';


GO
CREATE TABLE [dbo].[tblActivityLogAssociation] (
    [From] NVARCHAR (255) NOT NULL,
    [To]   BIGINT         NOT NULL,
    CONSTRAINT [PK_tblActivityLogAssociation] PRIMARY KEY NONCLUSTERED ([From] ASC, [To] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblActivityLogAssociation].[IDX_tblActivityLogAssociation_From]...';


GO
CREATE CLUSTERED INDEX [IDX_tblActivityLogAssociation_From]
    ON [dbo].[tblActivityLogAssociation]([From] ASC);


GO
PRINT N'Creating Index [dbo].[tblActivityLogAssociation].[IDX_tblActivityLogAssociation_To]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblActivityLogAssociation_To]
    ON [dbo].[tblActivityLogAssociation]([To] ASC);


GO
PRINT N'Creating Table [dbo].[tblEntityGuid]...';


GO
CREATE TABLE [dbo].[tblEntityGuid] (
    [intObjectTypeID] INT              NOT NULL,
    [intObjectID]     INT              NOT NULL,
    [unqID]           UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_tblEntityGuid] PRIMARY KEY CLUSTERED ([intObjectTypeID] ASC, [intObjectID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblContentBinding]...';


GO
CREATE TABLE [dbo].[tblContentBinding] (
    [pkID]                BIGINT           IDENTITY (1, 1) NOT NULL,
    [fkContentId]         INT              NOT NULL,
    [fkWorkId]            INT              NOT NULL,
    [ScopeName]           NVARCHAR (450)   NOT NULL,
    [fkBindingId]         INT              NULL,
    [ReferencedContentId] UNIQUEIDENTIFIER NOT NULL,
    [ReferencedLanguage]  NVARCHAR (255)   NULL,
    [ExternalIdentifier]  NVARCHAR (255)   NULL,
    CONSTRAINT [PK_tblContentBinding] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContentBinding].[IX_tblContentBinding_tblContent_ReferencedContentId]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblContentBinding_tblContent_ReferencedContentId]
    ON [dbo].[tblContentBinding]([ReferencedContentId] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentBinding].[IX_tblContentBinding_tblContent_tblWorkContent]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblContentBinding_tblContent_tblWorkContent]
    ON [dbo].[tblContentBinding]([fkContentId] ASC, [fkWorkId] ASC, [ScopeName] ASC);


GO
PRINT N'Creating Index [dbo].[tblContentBinding].[IX_tblContentBinding_tblContent_ExternalIdentifier]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblContentBinding_tblContent_ExternalIdentifier]
    ON [dbo].[tblContentBinding]([ExternalIdentifier] ASC) WHERE ([ExternalIdentifier] IS NOT NULL);


GO
PRINT N'Creating Table [dbo].[tblBigTableStoreConfig]...';


GO
CREATE TABLE [dbo].[tblBigTableStoreConfig] (
    [pkId]          BIGINT          IDENTITY (1, 1) NOT NULL,
    [StoreName]     NVARCHAR (375)  NOT NULL,
    [TableName]     NVARCHAR (128)  NULL,
    [EntityTypeId]  INT             NULL,
    [DateTimeKind]  INT             NOT NULL,
    [StoreVersion]  NVARCHAR (32)   NULL,
    [StoreItemType] NVARCHAR (2000) NULL,
    CONSTRAINT [PK_tblBigTableStoreConfig] PRIMARY KEY CLUSTERED ([pkId] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblBigTableStoreConfig].[IDX_tblBigTableStoreConfig_StoreName]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTableStoreConfig_StoreName]
    ON [dbo].[tblBigTableStoreConfig]([StoreName] ASC);


GO
PRINT N'Creating Table [dbo].[tblContentSource]...';


GO
CREATE TABLE [dbo].[tblContentSource] (
    [pkID]             INT              IDENTITY (1, 1) NOT NULL,
    [Type]             NVARCHAR (50)    NOT NULL,
    [Key]              NVARCHAR (255)   NOT NULL,
    [MappedProperties] NVARCHAR (MAX)   NULL,
    [SourceKey]        NVARCHAR (255)   NOT NULL,
    [ContentTypeGuid]  UNIQUEIDENTIFIER NOT NULL,
    [GuidIdFormat]     NVARCHAR (10)    NULL,
    [KeyFormat]        NVARCHAR (10)    NULL,
    [SourceType]       NVARCHAR (255)   NOT NULL,
    [DisplayName]      NVARCHAR (255)   NULL,
    [Created]          DATETIME2 (7)    NOT NULL,
    [Saved]            DATETIME2 (7)    NOT NULL,
    [SavedBy]          NVARCHAR (255)   NULL,
    [ContentTypeBase]  NVARCHAR (50)    NULL,
    [CreatedBy]        NVARCHAR (255)   NULL,
    CONSTRAINT [PK_tblContentSource] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Table [dbo].[tblCategory]...';


GO
CREATE TABLE [dbo].[tblCategory] (
    [pkID]                INT              IDENTITY (1, 1) NOT NULL,
    [fkParentID]          INT              NULL,
    [CategoryGUID]        UNIQUEIDENTIFIER NOT NULL,
    [SortOrder]           INT              NOT NULL,
    [Available]           BIT              NOT NULL,
    [Selectable]          BIT              NOT NULL,
    [SuperCategory]       BIT              NOT NULL,
    [CategoryName]        NVARCHAR (50)    NOT NULL,
    [CategoryDescription] NVARCHAR (255)   NULL,
    CONSTRAINT [PK_tblCategory] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblCategory].[IDX_tblCategory_Unique]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblCategory_Unique]
    ON [dbo].[tblCategory]([fkParentID] ASC, [CategoryName] ASC);


GO
PRINT N'Creating Table [dbo].[tblContent]...';


GO
CREATE TABLE [dbo].[tblContent] (
    [pkID]                     INT              IDENTITY (1, 1) NOT NULL,
    [fkContentTypeID]          INT              NOT NULL,
    [fkParentID]               INT              NULL,
    [ArchiveContentGUID]       UNIQUEIDENTIFIER NULL,
    [CreatorName]              NVARCHAR (255)   NULL,
    [Created]                  DATETIME2 (7)    NOT NULL,
    [ContentGUID]              UNIQUEIDENTIFIER NOT NULL,
    [VisibleInMenu]            BIT              NOT NULL,
    [Deleted]                  BIT              NOT NULL,
    [ChildOrderRule]           INT              NOT NULL,
    [PeerOrder]                INT              NOT NULL,
    [ContentAssetsID]          UNIQUEIDENTIFIER NULL,
    [ContentOwnerID]           UNIQUEIDENTIFIER NULL,
    [DeletedBy]                NVARCHAR (255)   NULL,
    [DeletedDate]              DATETIME2 (7)    NULL,
    [SavedBy]                  NVARCHAR (255)   NULL,
    [Saved]                    DATETIME2 (7)    NOT NULL,
    [fkMasterLanguageBranchID] INT              NOT NULL,
    [ContentPath]              VARCHAR (900)    NOT NULL,
    [ContentType]              INT              NOT NULL,
    [IsLeafNode]               BIT              NOT NULL,
    [Blueprint]                BIT              NOT NULL,
    CONSTRAINT [PK_tblContent] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
PRINT N'Creating Index [dbo].[tblContent].[IDX_tblContent_fkContentTypeID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_fkContentTypeID]
    ON [dbo].[tblContent]([fkContentTypeID] ASC);


GO
PRINT N'Creating Index [dbo].[tblContent].[IDX_tblContent_Deleted]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_Deleted]
    ON [dbo].[tblContent]([Deleted] ASC);


GO
PRINT N'Creating Index [dbo].[tblContent].[IDX_tblContent_ContentPath]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_ContentPath]
    ON [dbo].[tblContent]([ContentPath] ASC);


GO
PRINT N'Creating Index [dbo].[tblContent].[IDX_tblContent_ContentType]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_ContentType]
    ON [dbo].[tblContent]([ContentType] ASC);


GO
PRINT N'Creating Index [dbo].[tblContent].[IDX_tblContent_ArchiveContentGUID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_ArchiveContentGUID]
    ON [dbo].[tblContent]([ArchiveContentGUID] ASC) WHERE ([ArchiveContentGUID] IS NOT NULL);


GO
PRINT N'Creating Index [dbo].[tblContent].[IDX_tblContent_ContentGUID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContent_ContentGUID]
    ON [dbo].[tblContent]([ContentGUID] ASC);


GO
PRINT N'Creating Index [dbo].[tblContent].[IDX_tblContent_fkParentID]...';


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_fkParentID]
    ON [dbo].[tblContent]([fkParentID] ASC)
    INCLUDE([fkContentTypeID], [IsLeafNode], [ContentType], [fkMasterLanguageBranchID]);


GO
PRINT N'Creating Table [dbo].[tblChangeNotificationQueuedInt]...';


GO
CREATE TABLE [dbo].[tblChangeNotificationQueuedInt] (
    [ProcessorId]  UNIQUEIDENTIFIER NOT NULL,
    [ConnectionId] UNIQUEIDENTIFIER NULL,
    [QueueOrder]   INT              NOT NULL,
    [Value]        INT              NOT NULL
);


GO
PRINT N'Creating Index [dbo].[tblChangeNotificationQueuedInt].[IDX_tblChangeNotificationQueuedInt]...';


GO
CREATE CLUSTERED INDEX [IDX_tblChangeNotificationQueuedInt]
    ON [dbo].[tblChangeNotificationQueuedInt]([ProcessorId] ASC, [QueueOrder] ASC);


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblBigTableIdentity_Guid]...';


GO
ALTER TABLE [dbo].[tblBigTableIdentity]
    ADD CONSTRAINT [DF_tblBigTableIdentity_Guid] DEFAULT (newid()) FOR [Guid];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblPropert__guid__43F60EC8]...';


GO
ALTER TABLE [dbo].[tblContentProperty]
    ADD CONSTRAINT [DF__tblPropert__guid__43F60EC8] DEFAULT (newid()) FOR [guid];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblProper__Boole__44EA3301]...';


GO
ALTER TABLE [dbo].[tblContentProperty]
    ADD CONSTRAINT [DF__tblProper__Boole__44EA3301] DEFAULT (0) FOR [Boolean];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblProper__fkLan__29B609E9]...';


GO
ALTER TABLE [dbo].[tblContentProperty]
    ADD CONSTRAINT [DF__tblProper__fkLan__29B609E9] DEFAULT (1) FOR [fkLanguageBranchID];


GO
PRINT N'Creating Default Constraint [dbo].[[tblIndexRequestLog_Row]...';


GO
ALTER TABLE [dbo].[tblIndexRequestLog]
    ADD CONSTRAINT [[tblIndexRequestLog_Row] DEFAULT (1) FOR [Row];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblDisplayTemplate]...';


GO
ALTER TABLE [dbo].[tblDisplayTemplate]
    ADD DEFAULT (0) FOR [IsDefault];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblFrame_SystemFrame]...';


GO
ALTER TABLE [dbo].[tblFrame]
    ADD CONSTRAINT [DF_tblFrame_SystemFrame] DEFAULT (0) FOR [SystemFrame];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentTypeDefault_VisibleInMenu]...';


GO
ALTER TABLE [dbo].[tblContentTypeDefault]
    ADD CONSTRAINT [DF_tblContentTypeDefault_VisibleInMenu] DEFAULT (1) FOR [VisibleInMenu];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentTypeDefault_ChildOrderRule]...';


GO
ALTER TABLE [dbo].[tblContentTypeDefault]
    ADD CONSTRAINT [DF_tblContentTypeDefault_ChildOrderRule] DEFAULT (1) FOR [ChildOrderRule];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentTypeDefault_PeerOrder]...';


GO
ALTER TABLE [dbo].[tblContentTypeDefault]
    ADD CONSTRAINT [DF_tblContentTypeDefault_PeerOrder] DEFAULT (100) FOR [PeerOrder];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblApprovalDefinition__Created]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinition]
    ADD CONSTRAINT [DF__tblApprovalDefinition__Created] DEFAULT (GETUTCDATE()) FOR [Created];


GO
PRINT N'Creating Default Constraint [dbo].[tblVisitorGroupStatistic_Row]...';


GO
ALTER TABLE [dbo].[tblVisitorGroupStatistic]
    ADD CONSTRAINT [tblVisitorGroupStatistic_Row] DEFAULT (1) FOR [Row];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionReviewer]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionReviewer]
    ADD DEFAULT 0 FOR [ReviewerType];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionVersion]
    ADD DEFAULT (0) FOR [RequireCommentOnApprove];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionVersion]
    ADD DEFAULT (1) FOR [SelfApprove];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionVersion]
    ADD DEFAULT (0) FOR [RequireCommentOnStart];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionVersion]
    ADD DEFAULT (1) FOR [ApprovesNeeded];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionVersion]
    ADD DEFAULT (1) FOR [IsEnabled];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionVersion]
    ADD DEFAULT (0) FOR [RequireCommentOnReject];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinitionGroup_GroupOrder]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinitionGroup]
    ADD CONSTRAINT [DF_tblPropertyDefinitionGroup_GroupOrder] DEFAULT (1) FOR [GroupOrder];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinitionGroup_SystemGroup]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinitionGroup]
    ADD CONSTRAINT [DF_tblPropertyDefinitionGroup_SystemGroup] DEFAULT (0) FOR [SystemGroup];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinitionGroup_Access]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinitionGroup]
    ADD CONSTRAINT [DF_tblPropertyDefinitionGroup_Access] DEFAULT (10) FOR [Access];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinitionGroup_DefaultVisible]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinitionGroup]
    ADD CONSTRAINT [DF_tblPropertyDefinitionGroup_DefaultVisible] DEFAULT (1) FOR [GroupVisible];


GO
PRINT N'Creating Default Constraint [dbo].[tblBigTableReference_Index]...';


GO
ALTER TABLE [dbo].[tblBigTableReference]
    ADD CONSTRAINT [tblBigTableReference_Index] DEFAULT (1) FOR [Index];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblAzureWebhookMetadata]...';


GO
ALTER TABLE [dbo].[tblAzureWebhookMetadata]
    ADD DEFAULT 0 FOR [HasQueryString];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContentLanguage__Automatic]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD CONSTRAINT [DF__tblContentLanguage__Automatic] DEFAULT (1) FOR [AutomaticLink];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblContentLanguage]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD DEFAULT (2) FOR [Status];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContentLanguage__FetchData]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD CONSTRAINT [DF__tblContentLanguage__FetchData] DEFAULT (0) FOR [FetchData];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContentLanguage__ContentGUID]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD CONSTRAINT [DF__tblContentLanguage__ContentGUID] DEFAULT (newid()) FOR [ContentGUID];


GO
PRINT N'Creating Default Constraint [dbo].[tblSystemBigTable_Row]...';


GO
ALTER TABLE [dbo].[tblSystemBigTable]
    ADD CONSTRAINT [tblSystemBigTable_Row] DEFAULT (1) FOR [Row];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinition_DefaultValueType]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinition]
    ADD CONSTRAINT [DF_tblPropertyDefinition_DefaultValueType] DEFAULT (0) FOR [DefaultValueType];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinition_CommonLang]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinition]
    ADD CONSTRAINT [DF_tblPropertyDefinition_CommonLang] DEFAULT (0) FOR [LanguageSpecific];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinition_LongStringSettings]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinition]
    ADD CONSTRAINT [DF_tblPropertyDefinition_LongStringSettings] DEFAULT ((-1)) FOR [LongStringSettings];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefinition_ExistsOnModel]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinition]
    ADD CONSTRAINT [DF_tblPropertyDefinition_ExistsOnModel] DEFAULT (0) FOR [ExistsOnModel];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblWorkPr__Boole__55209ACA]...';


GO
ALTER TABLE [dbo].[tblWorkContentProperty]
    ADD CONSTRAINT [DF__tblWorkPr__Boole__55209ACA] DEFAULT (0) FOR [Boolean];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblWorkContentProperty_guid]...';


GO
ALTER TABLE [dbo].[tblWorkContentProperty]
    ADD CONSTRAINT [DF__tblWorkContentProperty_guid] DEFAULT (newid()) FOR [guid];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblNotificationSubscription]...';


GO
ALTER TABLE [dbo].[tblNotificationSubscription]
    ADD DEFAULT 1 FOR [Active];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblBigTable_Row]...';


GO
ALTER TABLE [dbo].[tblBigTable]
    ADD CONSTRAINT [DF_tblBigTable_Row] DEFAULT (1) FOR [Row];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblActivityArchive]...';


GO
ALTER TABLE [dbo].[tblActivityArchive]
    ADD DEFAULT (0) FOR [Deleted];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblActivityArchive_Action]...';


GO
ALTER TABLE [dbo].[tblActivityArchive]
    ADD CONSTRAINT [DF_tblActivityArchive_Action] DEFAULT (0) FOR [Action];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplicationHost_Type]...';


GO
ALTER TABLE [dbo].[tblApplicationHost]
    ADD CONSTRAINT [DEFAULT_tblApplicationHost_Type] DEFAULT ((0)) FOR [Type];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplicationHost_PreferredUrlScheme]...';


GO
ALTER TABLE [dbo].[tblApplicationHost]
    ADD CONSTRAINT [DEFAULT_tblApplicationHost_PreferredUrlScheme] DEFAULT ((1)) FOR [PreferredUrlScheme];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplicationHost_UseSecureConnection]...';


GO
ALTER TABLE [dbo].[tblApplicationHost]
    ADD CONSTRAINT [DEFAULT_tblApplicationHost_UseSecureConnection] DEFAULT ((0)) FOR [UseSecureConnection];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionStep]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionStep]
    ADD DEFAULT (NULL) FOR [ApprovesNeeded];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblApprovalDefinitionStep]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionStep]
    ADD DEFAULT (NULL) FOR [SelfApprove];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplication_UsePreviewTokens]...';


GO
ALTER TABLE [dbo].[tblApplication]
    ADD CONSTRAINT [DEFAULT_tblApplication_UsePreviewTokens] DEFAULT ((0)) FOR [UsePreviewTokens];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplication_Type]...';


GO
ALTER TABLE [dbo].[tblApplication]
    ADD CONSTRAINT [DEFAULT_tblApplication_Type] DEFAULT ((0)) FOR [Type];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplication_IsDefault]...';


GO
ALTER TABLE [dbo].[tblApplication]
    ADD CONSTRAINT [DEFAULT_tblApplication_IsDefault] DEFAULT ((0)) FOR [IsDefault];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplication_IsResourceable]...';


GO
ALTER TABLE [dbo].[tblApplication]
    ADD CONSTRAINT [DEFAULT_tblApplication_IsResourceable] DEFAULT ((0)) FOR [IsResourceable];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblConten__Activ__51300E55]...';


GO
ALTER TABLE [dbo].[tblContentLanguageSetting]
    ADD CONSTRAINT [DF__tblConten__Activ__51300E55] DEFAULT (1) FOR [Active];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblHostDefinition]...';


GO
ALTER TABLE [dbo].[tblHostDefinition]
    ADD DEFAULT 0 FOR [Type];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblScheduledItem__IsRunnning]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD CONSTRAINT [DF__tblScheduledItem__IsRunnning] DEFAULT (0) FOR [IsRunning];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblScheduledItem]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD DEFAULT (0) FOR [Hidden];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblSchedul__pkID__1A34DF26]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD CONSTRAINT [DF__tblSchedul__pkID__1A34DF26] DEFAULT (newid()) FOR [pkID];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblScheduledItem]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD DEFAULT (0) FOR [LastExecutionAttempt];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblScheduledItem]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD DEFAULT (0) FOR [Restartable];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblScheduledItem]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD DEFAULT (0) FOR [StoppedResponding];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblScheduledItem_Enabled]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD CONSTRAINT [DF_tblScheduledItem_Enabled] DEFAULT (0) FOR [Enabled];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblScheduledItem__IsStoppable]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD CONSTRAINT [DF__tblScheduledItem__IsStoppable] DEFAULT (0) FOR [IsStoppable];


GO
PRINT N'Creating Default Constraint [dbo].[tblTaskInformation_Row]...';


GO
ALTER TABLE [dbo].[tblTaskInformation]
    ADD CONSTRAINT [tblTaskInformation_Row] DEFAULT (1) FOR [Row];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblActivityLog_Action]...';


GO
ALTER TABLE [dbo].[tblActivityLog]
    ADD CONSTRAINT [DF_tblActivityLog_Action] DEFAULT ((0)) FOR [Action];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblActivityLog]...';


GO
ALTER TABLE [dbo].[tblActivityLog]
    ADD DEFAULT (0) FOR [Deleted];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentType_ContentType]...';


GO
ALTER TABLE [dbo].[tblContentType]
    ADD CONSTRAINT [DF_tblContentType_ContentType] DEFAULT (0) FOR [ContentType];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentType_MetaDataInherit]...';


GO
ALTER TABLE [dbo].[tblContentType]
    ADD CONSTRAINT [DF_tblContentType_MetaDataInherit] DEFAULT (0) FOR [MetaDataInherit];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentType_IsContract]...';


GO
ALTER TABLE [dbo].[tblContentType]
    ADD CONSTRAINT [DF_tblContentType_IsContract] DEFAULT (0) FOR [IsContract];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentType_MetaDataDefault]...';


GO
ALTER TABLE [dbo].[tblContentType]
    ADD CONSTRAINT [DF_tblContentType_MetaDataDefault] DEFAULT (0) FOR [MetaDataDefault];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentType_ContentTypeGUID]...';


GO
ALTER TABLE [dbo].[tblContentType]
    ADD CONSTRAINT [DF_tblContentType_ContentTypeGUID] DEFAULT (newid()) FOR [ContentTypeGUID];


GO
PRINT N'Creating Default Constraint [dbo].[DEFAULT_tblApplicationUrlFormat_Type]...';


GO
ALTER TABLE [dbo].[tblApplicationUrlFormat]
    ADD CONSTRAINT [DEFAULT_tblApplicationUrlFormat_Type] DEFAULT ((0)) FOR [Type];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblUserPermission_IsRole]...';


GO
ALTER TABLE [dbo].[tblUserPermission]
    ADD CONSTRAINT [DF_tblUserPermission_IsRole] DEFAULT (1) FOR [IsRole];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentCategory_LanguageBranchID]...';


GO
ALTER TABLE [dbo].[tblContentCategory]
    ADD CONSTRAINT [DF_tblContentCategory_LanguageBranchID] DEFAULT (1) FOR [fkLanguageBranchID];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentCategory_CategoryType]...';


GO
ALTER TABLE [dbo].[tblContentCategory]
    ADD CONSTRAINT [DF_tblContentCategory_CategoryType] DEFAULT (0) FOR [CategoryType];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblWorkContentCategory_CategoryType]...';


GO
ALTER TABLE [dbo].[tblWorkContentCategory]
    ADD CONSTRAINT [DF_tblWorkContentCategory_CategoryType] DEFAULT (0) FOR [CategoryType];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblPropertyDefault_Boolean]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinitionDefault]
    ADD CONSTRAINT [DF_tblPropertyDefault_Boolean] DEFAULT (0) FOR [Boolean];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblAccess_IsRole]...';


GO
ALTER TABLE [dbo].[tblContentAccess]
    ADD CONSTRAINT [DF_tblAccess_IsRole] DEFAULT (1) FOR [IsRole];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblXFormData_Row]...';


GO
ALTER TABLE [dbo].[tblXFormData]
    ADD CONSTRAINT [DF_tblXFormData_Row] DEFAULT ((1)) FOR [Row];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblWorkContent_CommonDraft]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [DF_tblWorkContent_CommonDraft] DEFAULT (0) FOR [CommonDraft];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblWorkPa__Chang__4E739D3B]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [DF__tblWorkPa__Chang__4E739D3B] DEFAULT (0) FOR [ChangedOnPublish];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblWorkPa__Child__4B973090]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [DF__tblWorkPa__Child__4B973090] DEFAULT (1) FOR [ChildOrderRule];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblWorkContent]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD DEFAULT (2) FOR [Status];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblWorkPa__fkLan__4258C320]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [DF__tblWorkPa__fkLan__4258C320] DEFAULT (1) FOR [fkLanguageBranchID];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblWorkPa__PeerO__4C8B54C9]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [DF__tblWorkPa__PeerO__4C8B54C9] DEFAULT (100) FOR [PeerOrder];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblWorkPa__LinkT__48BAC3E5]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [DF__tblWorkPa__LinkT__48BAC3E5] DEFAULT (0) FOR [LinkType];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblUniqueSequence__LastValue]...';


GO
ALTER TABLE [dbo].[tblUniqueSequence]
    ADD CONSTRAINT [DF__tblUniqueSequence__LastValue] DEFAULT (0) FOR [LastValue];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblMappedIdentity_ContentGuid]...';


GO
ALTER TABLE [dbo].[tblMappedIdentity]
    ADD CONSTRAINT [DF_tblMappedIdentity_ContentGuid] DEFAULT (NEWID()) FOR [ContentGuid];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentTypeToContentType_Access]...';


GO
ALTER TABLE [dbo].[tblContentTypeToContentType]
    ADD CONSTRAINT [DF_tblContentTypeToContentType_Access] DEFAULT (20) FOR [Access];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContentTypeToContentType_Availability]...';


GO
ALTER TABLE [dbo].[tblContentTypeToContentType]
    ADD CONSTRAINT [DF_tblContentTypeToContentType_Availability] DEFAULT (0) FOR [Availability];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblSynchedUserRole]...';


GO
ALTER TABLE [dbo].[tblSynchedUserRole]
    ADD DEFAULT (1) FOR [Enabled];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblLanguageBranch__Saved]...';


GO
ALTER TABLE [dbo].[tblLanguageBranch]
    ADD CONSTRAINT [DF__tblLanguageBranch__Saved] DEFAULT (GETUTCDATE()) FOR [Saved];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblLanguageBranch__Enabled]...';


GO
ALTER TABLE [dbo].[tblLanguageBranch]
    ADD CONSTRAINT [DF__tblLanguageBranch__Enabled] DEFAULT (1) FOR [Enabled];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblLanguageBranch__Created]...';


GO
ALTER TABLE [dbo].[tblLanguageBranch]
    ADD CONSTRAINT [DF__tblLanguageBranch__Created] DEFAULT (GETUTCDATE()) FOR [Created];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblBigTableStoreConfig]...';


GO
ALTER TABLE [dbo].[tblBigTableStoreConfig]
    ADD DEFAULT 0 FOR [DateTimeKind];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblCategory_SuperCategory]...';


GO
ALTER TABLE [dbo].[tblCategory]
    ADD CONSTRAINT [DF_tblCategory_SuperCategory] DEFAULT (0) FOR [SuperCategory];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblCategory_PeerOrder]...';


GO
ALTER TABLE [dbo].[tblCategory]
    ADD CONSTRAINT [DF_tblCategory_PeerOrder] DEFAULT (100) FOR [SortOrder];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblCategory_CategoryGUID]...';


GO
ALTER TABLE [dbo].[tblCategory]
    ADD CONSTRAINT [DF_tblCategory_CategoryGUID] DEFAULT (newid()) FOR [CategoryGUID];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblCategory_Available]...';


GO
ALTER TABLE [dbo].[tblCategory]
    ADD CONSTRAINT [DF_tblCategory_Available] DEFAULT (1) FOR [Available];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblCategory_Selectable]...';


GO
ALTER TABLE [dbo].[tblCategory]
    ADD CONSTRAINT [DF_tblCategory_Selectable] DEFAULT (1) FOR [Selectable];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContent_ContentType]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF_tblContent_ContentType] DEFAULT (0) FOR [ContentType];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContent__Visible__2E06CDA9]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF__tblContent__Visible__2E06CDA9] DEFAULT (1) FOR [VisibleInMenu];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContent_Created]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF_tblContent_Created] DEFAULT (GETUTCDATE()) FOR [Created];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContent__ChildOr__35A7EF71]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF__tblContent__ChildOr__35A7EF71] DEFAULT (1) FOR [ChildOrderRule];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContent_Saved]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF_tblContent_Saved] DEFAULT (GETUTCDATE()) FOR [Saved];


GO
PRINT N'Creating Default Constraint [dbo].[DF_tblContent_IsLeafNode]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF_tblContent_IsLeafNode] DEFAULT (1) FOR [IsLeafNode];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContent__ContentGUID]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF__tblContent__ContentGUID] DEFAULT (newid()) FOR [ContentGUID];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContent__fkMasterLangaugeBranchID]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF__tblContent__fkMasterLangaugeBranchID] DEFAULT (1) FOR [fkMasterLanguageBranchID];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContent__PeerOrd__369C13AA]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF__tblContent__PeerOrd__369C13AA] DEFAULT (100) FOR [PeerOrder];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[tblContent]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD DEFAULT (0) FOR [Blueprint];


GO
PRINT N'Creating Default Constraint [dbo].[DF__tblContent__Deleted__2EFAF1E2]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [DF__tblContent__Deleted__2EFAF1E2] DEFAULT (0) FOR [Deleted];


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApprovalStepDecision_tblApproval]...';


GO
ALTER TABLE [dbo].[tblApprovalStepDecision]
    ADD CONSTRAINT [FK_tblApprovalStepDecision_tblApproval] FOREIGN KEY ([fkApprovalID]) REFERENCES [dbo].[tblApproval] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentProperty_tblLanguageBranch]...';


GO
ALTER TABLE [dbo].[tblContentProperty]
    ADD CONSTRAINT [FK_tblContentProperty_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentProperty_tblContent2]...';


GO
ALTER TABLE [dbo].[tblContentProperty]
    ADD CONSTRAINT [FK_tblContentProperty_tblContent2] FOREIGN KEY ([ContentLink]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentProperty_tblContent]...';


GO
ALTER TABLE [dbo].[tblContentProperty]
    ADD CONSTRAINT [FK_tblContentProperty_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentProperty_tblPropertyDefinition]...';


GO
ALTER TABLE [dbo].[tblContentProperty]
    ADD CONSTRAINT [FK_tblContentProperty_tblPropertyDefinition] FOREIGN KEY ([fkPropertyDefinitionID]) REFERENCES [dbo].[tblPropertyDefinition] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblIndexRequestLog_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblIndexRequestLog]
    ADD CONSTRAINT [FK_tblIndexRequestLog_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentTypeDefault_tblContentType]...';


GO
ALTER TABLE [dbo].[tblContentTypeDefault]
    ADD CONSTRAINT [FK_tblContentTypeDefault_tblContentType] FOREIGN KEY ([fkContentTypeID]) REFERENCES [dbo].[tblContentType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApprovalDefinition_tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinition]
    ADD CONSTRAINT [FK_tblApprovalDefinition_tblApprovalDefinitionVersion] FOREIGN KEY ([fkCurrentApprovalDefinitionVersionID]) REFERENCES [dbo].[tblApprovalDefinitionVersion] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblVisitorGroupStatistic_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblVisitorGroupStatistic]
    ADD CONSTRAINT [FK_tblVisitorGroupStatistic_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApprovalDefinitionReviewer_tblLanguageBranch]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionReviewer]
    ADD CONSTRAINT [FK_tblApprovalDefinitionReviewer_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApprovalDefinitionReviewer_tblApprovalDefinitionStep]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionReviewer]
    ADD CONSTRAINT [FK_tblApprovalDefinitionReviewer_tblApprovalDefinitionStep] FOREIGN KEY ([fkApprovalDefinitionStepID]) REFERENCES [dbo].[tblApprovalDefinitionStep] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApprovalDefinitionReviewer_tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionReviewer]
    ADD CONSTRAINT [FK_tblApprovalDefinitionReviewer_tblApprovalDefinitionVersion] FOREIGN KEY ([fkApprovalDefinitionVersionID]) REFERENCES [dbo].[tblApprovalDefinitionVersion] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApprovalDefinitionVersion_tblApprovalDefinition]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionVersion]
    ADD CONSTRAINT [FK_tblApprovalDefinitionVersion_tblApprovalDefinition] FOREIGN KEY ([fkApprovalDefinitionID]) REFERENCES [dbo].[tblApprovalDefinition] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApproval_tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApproval]
    ADD CONSTRAINT [FK_tblApproval_tblApprovalDefinitionVersion] FOREIGN KEY ([fkApprovalDefinitionVersionID]) REFERENCES [dbo].[tblApprovalDefinitionVersion] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApproval_tblLanguageBranch]...';


GO
ALTER TABLE [dbo].[tblApproval]
    ADD CONSTRAINT [FK_tblApproval_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblBigTableReference_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblBigTableReference]
    ADD CONSTRAINT [FK_tblBigTableReference_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblBigTableReference_RefId_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblBigTableReference]
    ADD CONSTRAINT [FK_tblBigTableReference_RefId_tblBigTableIdentity] FOREIGN KEY ([RefIdValue]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentBindingDefinition_tblContentType_Source]...';


GO
ALTER TABLE [dbo].[tblContentBindingDefinition]
    ADD CONSTRAINT [FK_tblContentBindingDefinition_tblContentType_Source] FOREIGN KEY ([SourceContentTypeGUID]) REFERENCES [dbo].[tblContentType] ([ContentTypeGUID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentBindingDefinition_tblContentType_Target]...';


GO
ALTER TABLE [dbo].[tblContentBindingDefinition]
    ADD CONSTRAINT [FK_tblContentBindingDefinition_tblContentType_Target] FOREIGN KEY ([TargetContentTypeGUID]) REFERENCES [dbo].[tblContentType] ([ContentTypeGUID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblBigTableStoreInfo_tblBigTableStoreConfig]...';


GO
ALTER TABLE [dbo].[tblBigTableStoreInfo]
    ADD CONSTRAINT [FK_tblBigTableStoreInfo_tblBigTableStoreConfig] FOREIGN KEY ([fkStoreId]) REFERENCES [dbo].[tblBigTableStoreConfig] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentLanguage_tblFrame]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD CONSTRAINT [FK_tblContentLanguage_tblFrame] FOREIGN KEY ([fkFrameID]) REFERENCES [dbo].[tblFrame] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentLanguage_tblContent2]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD CONSTRAINT [FK_tblContentLanguage_tblContent2] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentLanguage_tblWorkContent]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD CONSTRAINT [FK_tblContentLanguage_tblWorkContent] FOREIGN KEY ([Version]) REFERENCES [dbo].[tblWorkContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentLanguage_tblLanguageBranch]...';


GO
ALTER TABLE [dbo].[tblContentLanguage]
    ADD CONSTRAINT [FK_tblContentLanguage_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblSystemBigTable_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblSystemBigTable]
    ADD CONSTRAINT [FK_tblSystemBigTable_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblSynchedUserRelations_Group]...';


GO
ALTER TABLE [dbo].[tblSynchedUserRelations]
    ADD CONSTRAINT [FK_tblSynchedUserRelations_Group] FOREIGN KEY ([fkSynchedRole]) REFERENCES [dbo].[tblSynchedUserRole] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblSyncheduserRelations_User]...';


GO
ALTER TABLE [dbo].[tblSynchedUserRelations]
    ADD CONSTRAINT [FK_tblSyncheduserRelations_User] FOREIGN KEY ([fkSynchedUser]) REFERENCES [dbo].[tblSynchedUser] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblPropertyDefinition_tblPropertyDefinitionType]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinition]
    ADD CONSTRAINT [FK_tblPropertyDefinition_tblPropertyDefinitionType] FOREIGN KEY ([fkPropertyDefinitionTypeID]) REFERENCES [dbo].[tblPropertyDefinitionType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblPropertyDefinition_tblContentType]...';


GO
ALTER TABLE [dbo].[tblPropertyDefinition]
    ADD CONSTRAINT [FK_tblPropertyDefinition_tblContentType] FOREIGN KEY ([fkContentTypeID]) REFERENCES [dbo].[tblContentType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblDisplaySetting_tblDisplayTemplate]...';


GO
ALTER TABLE [dbo].[tblDisplaySetting]
    ADD CONSTRAINT [FK_tblDisplaySetting_tblDisplayTemplate] FOREIGN KEY ([fkTemplateId]) REFERENCES [dbo].[tblDisplayTemplate] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContentProperty_tblWorkContent]...';


GO
ALTER TABLE [dbo].[tblWorkContentProperty]
    ADD CONSTRAINT [FK_tblWorkContentProperty_tblWorkContent] FOREIGN KEY ([fkWorkContentID]) REFERENCES [dbo].[tblWorkContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContentProperty_tblContent]...';


GO
ALTER TABLE [dbo].[tblWorkContentProperty]
    ADD CONSTRAINT [FK_tblWorkContentProperty_tblContent] FOREIGN KEY ([ContentLink]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContentProperty_tblContentType]...';


GO
ALTER TABLE [dbo].[tblWorkContentProperty]
    ADD CONSTRAINT [FK_tblWorkContentProperty_tblContentType] FOREIGN KEY ([ContentType]) REFERENCES [dbo].[tblContentType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContentProperty_tblPropertyDefinition]...';


GO
ALTER TABLE [dbo].[tblWorkContentProperty]
    ADD CONSTRAINT [FK_tblWorkContentProperty_tblPropertyDefinition] FOREIGN KEY ([fkPropertyDefinitionID]) REFERENCES [dbo].[tblPropertyDefinition] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ChangeNotification_ChangeNotificationGuid_ChangeNotificationProcessor]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationQueuedGuid]
    ADD CONSTRAINT [FK_ChangeNotification_ChangeNotificationGuid_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ChangeNotification_ChangeNotificationGuid_ChangeNotificationConnection]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationQueuedGuid]
    ADD CONSTRAINT [FK_ChangeNotification_ChangeNotificationGuid_ChangeNotificationConnection] FOREIGN KEY ([ConnectionId]) REFERENCES [dbo].[tblChangeNotificationConnection] ([ConnectionId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentSoftlink_tblContent]...';


GO
ALTER TABLE [dbo].[tblContentSoftlink]
    ADD CONSTRAINT [FK_tblContentSoftlink_tblContent] FOREIGN KEY ([fkOwnerContentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentSoftlink_tblPropertyDefinition]...';


GO
ALTER TABLE [dbo].[tblContentSoftlink]
    ADD CONSTRAINT [FK_tblContentSoftlink_tblPropertyDefinition] FOREIGN KEY ([fkOwnerPropertyDefinitionID]) REFERENCES [dbo].[tblPropertyDefinition] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblActivityLogComment_tblActivityLog]...';


GO
ALTER TABLE [dbo].[tblActivityLogComment]
    ADD CONSTRAINT [FK_tblActivityLogComment_tblActivityLog] FOREIGN KEY ([EntryId]) REFERENCES [dbo].[tblActivityLog] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblBigTable_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblBigTable]
    ADD CONSTRAINT [FK_tblBigTable_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApplicationHost_tblApplication]...';


GO
ALTER TABLE [dbo].[tblApplicationHost]
    ADD CONSTRAINT [FK_tblApplicationHost_tblApplication] FOREIGN KEY ([fkApplicationID]) REFERENCES [dbo].[tblApplication] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApprovalDefinitionStep_tblApprovalDefinitionVersion]...';


GO
ALTER TABLE [dbo].[tblApprovalDefinitionStep]
    ADD CONSTRAINT [FK_tblApprovalDefinitionStep_tblApprovalDefinitionVersion] FOREIGN KEY ([fkApprovalDefinitionVersionID]) REFERENCES [dbo].[tblApprovalDefinitionVersion] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApplication_tblContent]...';


GO
ALTER TABLE [dbo].[tblApplication]
    ADD CONSTRAINT [FK_tblApplication_tblContent] FOREIGN KEY ([fkAssetsRootID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentLanguageSetting_tblLanguageBranch2]...';


GO
ALTER TABLE [dbo].[tblContentLanguageSetting]
    ADD CONSTRAINT [FK_tblContentLanguageSetting_tblLanguageBranch2] FOREIGN KEY ([fkReplacementBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentLanguageSetting_tblContent]...';


GO
ALTER TABLE [dbo].[tblContentLanguageSetting]
    ADD CONSTRAINT [FK_tblContentLanguageSetting_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentLanguageSetting_tblLanguageBranch1]...';


GO
ALTER TABLE [dbo].[tblContentLanguageSetting]
    ADD CONSTRAINT [FK_tblContentLanguageSetting_tblLanguageBranch1] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentTypeContract_ContentTypeID]...';


GO
ALTER TABLE [dbo].[tblContentTypeContract]
    ADD CONSTRAINT [FK_tblContentTypeContract_ContentTypeID] FOREIGN KEY ([ContentTypeID]) REFERENCES [dbo].[tblContentType] ([ContentTypeGUID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentTypeContract_Contract]...';


GO
ALTER TABLE [dbo].[tblContentTypeContract]
    ADD CONSTRAINT [FK_tblContentTypeContract_Contract] FOREIGN KEY ([ContractID]) REFERENCES [dbo].[tblContentType] ([ContentTypeGUID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblHostDefinition_tblSiteDefinition]...';


GO
ALTER TABLE [dbo].[tblHostDefinition]
    ADD CONSTRAINT [FK_tblHostDefinition_tblSiteDefinition] FOREIGN KEY ([fkSiteID]) REFERENCES [dbo].[tblSiteDefinition] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblTaskInformation_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblTaskInformation]
    ADD CONSTRAINT [FK_tblTaskInformation_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_SubPropertyBindingDefinition_tblContentBindingDefinition]...';


GO
ALTER TABLE [dbo].[tblPropertyBindingDefinition]
    ADD CONSTRAINT [FK_SubPropertyBindingDefinition_tblContentBindingDefinition] FOREIGN KEY ([fkSubContentBindingDefinitionID]) REFERENCES [dbo].[tblContentBindingDefinition] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblPropertyBindingDefinition_tblContentBindingDefinition]...';


GO
ALTER TABLE [dbo].[tblPropertyBindingDefinition]
    ADD CONSTRAINT [FK_tblPropertyBindingDefinition_tblContentBindingDefinition] FOREIGN KEY ([fkContentBindingDefinitionID]) REFERENCES [dbo].[tblContentBindingDefinition] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblProjectMember_tblProject]...';


GO
ALTER TABLE [dbo].[tblProjectMember]
    ADD CONSTRAINT [FK_tblProjectMember_tblProject] FOREIGN KEY ([fkProjectID]) REFERENCES [dbo].[tblProject] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApplicationUrlFormat_tblApplication]...';


GO
ALTER TABLE [dbo].[tblApplicationUrlFormat]
    ADD CONSTRAINT [FK_tblApplicationUrlFormat_tblApplication] FOREIGN KEY ([fkApplicationID]) REFERENCES [dbo].[tblApplication] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblApplicationUrlFormat_tblContentType]...';


GO
ALTER TABLE [dbo].[tblApplicationUrlFormat]
    ADD CONSTRAINT [FK_tblApplicationUrlFormat_tblContentType] FOREIGN KEY ([fkContentTypeGUID]) REFERENCES [dbo].[tblContentType] ([ContentTypeGUID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentCategory_tblCategory]...';


GO
ALTER TABLE [dbo].[tblContentCategory]
    ADD CONSTRAINT [FK_tblContentCategory_tblCategory] FOREIGN KEY ([fkCategoryID]) REFERENCES [dbo].[tblCategory] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentCategory_tblContent]...';


GO
ALTER TABLE [dbo].[tblContentCategory]
    ADD CONSTRAINT [FK_tblContentCategory_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContentCategory_tblWorkContent]...';


GO
ALTER TABLE [dbo].[tblWorkContentCategory]
    ADD CONSTRAINT [FK_tblWorkContentCategory_tblWorkContent] FOREIGN KEY ([fkWorkContentID]) REFERENCES [dbo].[tblWorkContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContentCategory_tblCategory]...';


GO
ALTER TABLE [dbo].[tblWorkContentCategory]
    ADD CONSTRAINT [FK_tblWorkContentCategory_tblCategory] FOREIGN KEY ([fkCategoryID]) REFERENCES [dbo].[tblCategory] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblInlineBlockUsage_tblWorkContent]...';


GO
ALTER TABLE [dbo].[tblInlineBlockUsage]
    ADD CONSTRAINT [FK_tblInlineBlockUsage_tblWorkContent] FOREIGN KEY ([fkWorkContentID]) REFERENCES [dbo].[tblWorkContent] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblInlineBlockUsage_tblContentType]...';


GO
ALTER TABLE [dbo].[tblInlineBlockUsage]
    ADD CONSTRAINT [FK_tblInlineBlockUsage_tblContentType] FOREIGN KEY ([fkContentTypeID]) REFERENCES [dbo].[tblContentType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblInlineBlockUsage_tblContent]...';


GO
ALTER TABLE [dbo].[tblInlineBlockUsage]
    ADD CONSTRAINT [FK_tblInlineBlockUsage_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentAccess_tblContent]...';


GO
ALTER TABLE [dbo].[tblContentAccess]
    ADD CONSTRAINT [FK_tblContentAccess_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblXFormData_tblBigTableIdentity]...';


GO
ALTER TABLE [dbo].[tblXFormData]
    ADD CONSTRAINT [FK_tblXFormData_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContent_tblContent]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [FK_tblWorkContent_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContent_tblFrame]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [FK_tblWorkContent_tblFrame] FOREIGN KEY ([fkFrameID]) REFERENCES [dbo].[tblFrame] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContent_tblLanguageBranch]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [FK_tblWorkContent_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContent_tblWorkContent2]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [FK_tblWorkContent_tblWorkContent2] FOREIGN KEY ([fkMasterVersionID]) REFERENCES [dbo].[tblWorkContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblWorkContent_tblContentVariation]...';


GO
ALTER TABLE [dbo].[tblWorkContent]
    ADD CONSTRAINT [FK_tblWorkContent_tblContentVariation] FOREIGN KEY ([fkVariationID]) REFERENCES [dbo].[tblContentVariation] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ChangeNotificationConnection_ChangeNotificationProcessor]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationConnection]
    ADD CONSTRAINT [FK_ChangeNotificationConnection_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblProjectItem_tblProject]...';


GO
ALTER TABLE [dbo].[tblProjectItem]
    ADD CONSTRAINT [FK_tblProjectItem_tblProject] FOREIGN KEY ([fkProjectID]) REFERENCES [dbo].[tblProject] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentTypeToContentType_tblContentType1]...';


GO
ALTER TABLE [dbo].[tblContentTypeToContentType]
    ADD CONSTRAINT [FK_tblContentTypeToContentType_tblContentType1] FOREIGN KEY ([fkContentTypeChildID]) REFERENCES [dbo].[tblContentType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentTypeToContentType_tblContentType]...';


GO
ALTER TABLE [dbo].[tblContentTypeToContentType]
    ADD CONSTRAINT [FK_tblContentTypeToContentType_tblContentType] FOREIGN KEY ([fkContentTypeParentID]) REFERENCES [dbo].[tblContentType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[fk_tblScheduledItemLog_tblScheduledItem]...';


GO
ALTER TABLE [dbo].[tblScheduledItemLog]
    ADD CONSTRAINT [fk_tblScheduledItemLog_tblScheduledItem] FOREIGN KEY ([fkScheduledItemId]) REFERENCES [dbo].[tblScheduledItem] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblLanguageBranch_FallbackLanguageBranch]...';


GO
ALTER TABLE [dbo].[tblLanguageBranch]
    ADD CONSTRAINT [FK_tblLanguageBranch_FallbackLanguageBranch] FOREIGN KEY ([fkFallbackBranchId]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ChangeNotification_ChangeNotificationString_ChangeNotificationProcessor]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationQueuedString]
    ADD CONSTRAINT [FK_ChangeNotification_ChangeNotificationString_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ChangeNotification_ChangeNotificationString_ChangeNotificationConnection]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationQueuedString]
    ADD CONSTRAINT [FK_ChangeNotification_ChangeNotificationString_ChangeNotificationConnection] FOREIGN KEY ([ConnectionId]) REFERENCES [dbo].[tblChangeNotificationConnection] ([ConnectionId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblActivityLogAssociation_tblActivityLog]...';


GO
ALTER TABLE [dbo].[tblActivityLogAssociation]
    ADD CONSTRAINT [FK_tblActivityLogAssociation_tblActivityLog] FOREIGN KEY ([To]) REFERENCES [dbo].[tblActivityLog] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentBinding_tblContentBindingDefinition]...';


GO
ALTER TABLE [dbo].[tblContentBinding]
    ADD CONSTRAINT [FK_tblContentBinding_tblContentBindingDefinition] FOREIGN KEY ([fkBindingId]) REFERENCES [dbo].[tblContentBindingDefinition] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentBinding_tblContent]...';


GO
ALTER TABLE [dbo].[tblContentBinding]
    ADD CONSTRAINT [FK_tblContentBinding_tblContent] FOREIGN KEY ([fkContentId]) REFERENCES [dbo].[tblContent] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentBinding_tblWorkContent]...';


GO
ALTER TABLE [dbo].[tblContentBinding]
    ADD CONSTRAINT [FK_tblContentBinding_tblWorkContent] FOREIGN KEY ([fkWorkId]) REFERENCES [dbo].[tblWorkContent] ([pkID]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContentSource_tblContentType]...';


GO
ALTER TABLE [dbo].[tblContentSource]
    ADD CONSTRAINT [FK_tblContentSource_tblContentType] FOREIGN KEY ([ContentTypeGuid]) REFERENCES [dbo].[tblContentType] ([ContentTypeGUID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblCategory_tblCategory]...';


GO
ALTER TABLE [dbo].[tblCategory]
    ADD CONSTRAINT [FK_tblCategory_tblCategory] FOREIGN KEY ([fkParentID]) REFERENCES [dbo].[tblCategory] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContent_tblContent]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [FK_tblContent_tblContent] FOREIGN KEY ([fkParentID]) REFERENCES [dbo].[tblContent] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContent_tblLanguageBranch]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [FK_tblContent_tblLanguageBranch] FOREIGN KEY ([fkMasterLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_tblContent_tblContentType]...';


GO
ALTER TABLE [dbo].[tblContent]
    ADD CONSTRAINT [FK_tblContent_tblContentType] FOREIGN KEY ([fkContentTypeID]) REFERENCES [dbo].[tblContentType] ([pkID]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ChangeNotification_ChangeNotificationInt_ChangeNotificationConnection]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationQueuedInt]
    ADD CONSTRAINT [FK_ChangeNotification_ChangeNotificationInt_ChangeNotificationConnection] FOREIGN KEY ([ConnectionId]) REFERENCES [dbo].[tblChangeNotificationConnection] ([ConnectionId]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ChangeNotification_ChangeNotificationInt_ChangeNotificationProcessor]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationQueuedInt]
    ADD CONSTRAINT [FK_ChangeNotification_ChangeNotificationInt_ChangeNotificationProcessor] FOREIGN KEY ([ProcessorId]) REFERENCES [dbo].[tblChangeNotificationProcessor] ([ProcessorId]);


GO
PRINT N'Creating Check Constraint [dbo].[CH_tblIndexRequestLog]...';


GO
ALTER TABLE [dbo].[tblIndexRequestLog]
    ADD CONSTRAINT [CH_tblIndexRequestLog] CHECK ([Row]>=1);


GO
PRINT N'Creating Check Constraint [dbo].[CK_tblDisplayTemplate_OneTypeShouldBeSet]...';


GO
ALTER TABLE [dbo].[tblDisplayTemplate]
    ADD CONSTRAINT [CK_tblDisplayTemplate_OneTypeShouldBeSet] CHECK ((CASE WHEN [BaseType] IS NULL THEN 0 ELSE 1 END +
        CASE WHEN [NodeType] IS NULL THEN 0 ELSE 1 END +
        CASE WHEN [ContentTypeID] IS NULL THEN 0 ELSE 1 END) = 1);


GO
PRINT N'Creating Check Constraint [dbo].[CH_tblVisitorGroupStatistic]...';


GO
ALTER TABLE [dbo].[tblVisitorGroupStatistic]
    ADD CONSTRAINT [CH_tblVisitorGroupStatistic] CHECK ([Row]>=1);


GO
PRINT N'Creating Check Constraint [dbo].[CH_tblBigTableReference_Index]...';


GO
ALTER TABLE [dbo].[tblBigTableReference]
    ADD CONSTRAINT [CH_tblBigTableReference_Index] CHECK ([Index]>=-1);


GO
PRINT N'Creating Check Constraint [dbo].[CH_tblSystemBigTable]...';


GO
ALTER TABLE [dbo].[tblSystemBigTable]
    ADD CONSTRAINT [CH_tblSystemBigTable] CHECK ([Row]>=1);


GO
PRINT N'Creating Check Constraint [dbo].[CK_ChangeNotificationProcessor_ProcessorStatus]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationProcessor]
    ADD CONSTRAINT [CK_ChangeNotificationProcessor_ProcessorStatus] CHECK ([ProcessorStatus]='valid' OR [ProcessorStatus]='recovering' OR [ProcessorStatus]='invalid');


GO
PRINT N'Creating Check Constraint [dbo].[CK_ChangeNotificationProcessor_ChangeNotificationDataType]...';


GO
ALTER TABLE [dbo].[tblChangeNotificationProcessor]
    ADD CONSTRAINT [CK_ChangeNotificationProcessor_ChangeNotificationDataType] CHECK ([ChangeNotificationDataType]='Guid' OR [ChangeNotificationDataType]='String' OR [ChangeNotificationDataType]='Int');


GO
PRINT N'Creating Check Constraint [dbo].[CH_tblBigTable]...';


GO
ALTER TABLE [dbo].[tblBigTable]
    ADD CONSTRAINT [CH_tblBigTable] CHECK ([Row]>=1);


GO
PRINT N'Creating Check Constraint [dbo].[CK_tblScheduledItem]...';


GO
ALTER TABLE [dbo].[tblScheduledItem]
    ADD CONSTRAINT [CK_tblScheduledItem] CHECK ([DatePart] = 'yy' or ([DatePart] = 'mm' or ([DatePart] = 'wk' or ([DatePart] = 'dd' or ([DatePart] = 'hh' or ([DatePart] = 'mi' or ([DatePart] = 'ss' or [DatePart] = 'ms')))))));


GO
PRINT N'Creating Check Constraint [dbo].[CH_tblTaskInformation]...';


GO
ALTER TABLE [dbo].[tblTaskInformation]
    ADD CONSTRAINT [CH_tblTaskInformation] CHECK ([Row]>=1);


GO
PRINT N'Creating Check Constraint [dbo].[CH_tblXFormData]...';


GO
ALTER TABLE [dbo].[tblXFormData]
    ADD CONSTRAINT [CH_tblXFormData] CHECK (([Row]>=(1)));


GO
PRINT N'Creating View [dbo].[tblProperty]...';


GO

CREATE VIEW [dbo].[tblProperty]
AS
SELECT
	[pkID],
	[fkPropertyDefinitionID] AS fkPageDefinitionID,
	[fkContentID] AS fkPageID,
	[fkLanguageBranchID],
	[ScopeName],
	[guid],
	[Boolean],
	[Number],
	[FloatNumber],
	[ContentType] AS PageType,
	[ContentLink] AS PageLink,
	[Date],
	[String],
	[LongString],
	[LongStringLength],
	[LinkGuid],
    [ListIndex],
    [BranchSpecificScope]
FROM    dbo.tblContentProperty
GO
PRINT N'Creating View [dbo].[tblCategoryPage]...';


GO
CREATE VIEW [dbo].[tblCategoryPage]
AS
SELECT  [fkContentID] AS fkPageID,
		[fkCategoryID],
		[CategoryType],
		[fkLanguageBranchID]
FROM    dbo.tblContentCategory
GO
PRINT N'Creating View [dbo].[tblWorkPage]...';


GO
CREATE VIEW [dbo].[tblWorkPage]
AS
SELECT
	[pkID],
    [fkContentID] AS fkPageID,
    [fkMasterVersionID],
    [ContentLinkGUID] AS PageLinkGUID,
    [fkFrameID],
    [ArchiveContentGUID] as ArchivePageGUID,
    [ChangedByName],
    [NewStatusByName],
    [Name],
    [URLSegment],
    [LinkURL],
	[BlobUri],
	[ThumbnailUri],
    [ExternalURL],
    [VisibleInMenu],
    [LinkType],
    [Created],
    [Saved],
    [StartPublish],
    [StopPublish],
    [ChildOrderRule],
    [PeerOrder],
    CASE WHEN Status = 3 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS ReadyToPublish,
    [ChangedOnPublish],
    CASE WHEN Status IN (4, 5) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasBeenPublished,
    CASE WHEN Status = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Rejected,
    CASE WHEN Status = 6 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS DelayedPublish,
    [RejectComment],
    [fkLanguageBranchID],
	[CommonDraft]
FROM    dbo.tblWorkContent
GO
PRINT N'Creating View [dbo].[tblPageTypeDefault]...';


GO
CREATE VIEW [dbo].[tblPageTypeDefault]
AS
SELECT
	[pkID],
	[fkContentTypeID] AS fkPageTypeID,
	[fkContentLinkID] AS fkPageLinkID,
	[fkFrameID],
	[fkArchiveContentID] AS fkArchivePageID,
	[Name],
	[VisibleInMenu],
	[StartPublishOffsetValue],
	[StartPublishOffsetType],
	[StopPublishOffsetValue],
	[StopPublishOffsetType],
	[ChildOrderRule],
	[PeerOrder],
	[StartPublishOffset],
	[StopPublishOffset]
FROM    dbo.tblContentTypeDefault
GO
PRINT N'Creating View [dbo].[tblPageTypeToPageType]...';


GO
CREATE VIEW [dbo].[tblPageTypeToPageType]
AS
SELECT
	[fkContentTypeParentID] AS fkPageTypeParentID,
	[fkContentTypeChildID] AS fkPageTypeChildID,
	[Access],
	[Availability],
	[Allow]
FROM    dbo.tblContentTypeToContentType
GO
PRINT N'Creating View [dbo].[tblWorkProperty]...';


GO
CREATE VIEW [dbo].[tblWorkProperty]
AS
SELECT
	[pkID],
	[fkPropertyDefinitionID] AS fkPageDefinitionID,
	[fkWorkContentID] AS fkWorkPageID,
	[ScopeName],
    ListIndex,
    [BranchSpecificScope],
	[Boolean],
	[Number],
	[FloatNumber],
	[ContentType] AS PageType,
	[ContentLink] AS PageLink,
	[Date],
	[String],
	[LongString],
	[LinkGuid]
FROM    dbo.tblWorkContentProperty
GO
PRINT N'Creating View [dbo].[tblPageDefinition]...';


GO
CREATE VIEW [dbo].[tblPageDefinition]
AS
SELECT  [pkID],
		[fkContentTypeID] AS fkPageTypeID,
		[fkPropertyDefinitionTypeID] AS fkPageDefinitionTypeID,
		[FieldOrder],
		[Name],
		[Property],
        [IsList],
		[Required],
		[Advanced],
		[IndexingType],
		[EditCaption],
		[HelpText],
		[ObjectProgID],
		[DefaultValueType],
		[LongStringSettings],
		[SettingsID],
		[LanguageSpecific],
		[DisplayEditUI],
		[ExistsOnModel],
        [EditorHint],
        [ImageDescriptor],
        [Saved]
FROM    dbo.tblPropertyDefinition
GO
PRINT N'Creating View [dbo].[completeActivityLog]...';


GO

CREATE VIEW [dbo].[completeActivityLog]
	AS 
SELECT [pkID], [LogData], [ChangeDate], [Type], [Action], [ChangedBy], [Deleted] FROM [tblActivityArchive]
UNION ALL
SELECT [pkID], [LogData], [ChangeDate], [Type], [Action], [ChangedBy], [Deleted] FROM [tblActivityLog]
GO
PRINT N'Creating View [dbo].[tblPageLanguageSetting]...';


GO
CREATE VIEW [dbo].[tblPageLanguageSetting]
AS
SELECT
		[fkContentID] AS fkPageID,
		[fkLanguageBranchID],
		[fkReplacementBranchID],
    	[LanguageBranchFallback],
    	[Active]
FROM    dbo.tblContentLanguageSetting
GO
PRINT N'Creating View [dbo].[tblWorkCategory]...';


GO
CREATE VIEW [dbo].[tblWorkCategory]
AS
SELECT
	[fkWorkContentID] AS fkWorkPageID,
	[fkCategoryID],
	[CategoryType]
FROM    dbo.tblWorkContentCategory
GO
PRINT N'Creating View [dbo].[tblPage]...';


GO
CREATE VIEW [dbo].[tblPage]
AS
SELECT  [pkID],
		[fkContentTypeID] AS fkPageTypeID,
		[fkParentID],
		[ArchiveContentGUID] AS ArchivePageGUID,
		[CreatorName],
		[ContentGUID] AS PageGUID,
		[VisibleInMenu],
		[Deleted],
		CAST (0 AS BIT) AS PendingPublish,
		[ChildOrderRule],
		[PeerOrder],
		[ContentAssetsID],
		[ContentOwnerID],
		NULL as PublishedVersion,
		[fkMasterLanguageBranchID],
		[ContentPath] AS PagePath,
		[ContentType],
		[DeletedBy],
		[DeletedDate]
FROM    dbo.tblContent
GO
PRINT N'Creating View [dbo].[tblPageType]...';


GO
CREATE VIEW [dbo].[tblPageType]
AS
SELECT
  [pkID],
  [ContentTypeGUID] AS PageTypeGUID,
  [Created],
  [DefaultMvcController],
  [ModelType],
  [Name],
  [DisplayName],
  [Description],
  [IdString],
  [Available],
  [SortOrder],
  [MetaDataInherit],
  [MetaDataDefault],
  [WorkflowEditFields],
  [ACL],
  [ContentType]
FROM    dbo.tblContentType
GO
PRINT N'Creating View [dbo].[tblPropertyDefault]...';


GO
CREATE VIEW [dbo].[tblPropertyDefault]
AS
SELECT
	[pkID],
	[fkPropertyDefinitionID] AS fkPageDefinitionID,
	[Boolean],
	[Number],
	[FloatNumber],
	[ContentType] AS PageType,
	[ContentLink] AS PageLink,
	[Date],
	[String],
	[LongString],
	[LinkGuid]
FROM    dbo.tblPropertyDefinitionDefault
GO
PRINT N'Creating View [dbo].[tblPageLanguage]...';


GO
CREATE VIEW [dbo].[tblPageLanguage]
AS
SELECT
	[fkContentID] AS fkPageID,
	[fkLanguageBranchID],
	[ContentLinkGUID] AS PageLinkGUID,
	[fkFrameID],
	[CreatorName],
    [ChangedByName],
    [ContentGUID] AS PageGUID,
    [Name],
    [URLSegment],
    [LinkURL],
	[BlobUri],
	[ThumbnailUri],
    [ExternalURL],
    [AutomaticLink],
    [FetchData],
    CASE WHEN Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PendingPublish,
    [Created],
    [Changed],
    [Saved],
    [StartPublish],
    [StopPublish],
    [Version],
	[Status]

FROM    dbo.tblContentLanguage
GO
PRINT N'Creating Function [dbo].[ConvertScopeName]...';


GO
CREATE FUNCTION [dbo].[ConvertScopeName]
(
	@ScopeName nvarchar(450),
	@OldDefinitionID int,
	@NewDefinitionID int	
)
RETURNS nvarchar(450)
AS
BEGIN
	DECLARE @ConvertedScopeName nvarchar(450)

	set @ConvertedScopeName = REPLACE(@ScopeName, 
						'.' + CAST(@OldDefinitionID as varchar) + '.', 
						'.'+ CAST(@NewDefinitionID as varchar) +'.')
	RETURN @ConvertedScopeName
END
GO
PRINT N'Creating Function [dbo].[GetRootScope]...';


GO
CREATE FUNCTION dbo.GetRootScope
(
	@ScopeName NVARCHAR(450)
)
RETURNS NVARCHAR(450)
AS
BEGIN

IF @ScopeName IS NULL
    RETURN NULL

DECLARE @DotIndex INT
DECLARE @BracketIndex INT
DECLARE @ColonIndex INT
DECLARE @RootScope NVARCHAR(450)

-- Start position is 1 based and not 0 based
SELECT @DotIndex = CHARINDEX('.', @ScopeName, 2)
SELECT @BracketIndex = CHARINDEX('(', @ScopeName, 2)
SELECT @ColonIndex = CHARINDEX(':', @ScopeName, 2)

RETURN CASE 
    WHEN @DotIndex > 0 AND (@BracketIndex = 0 OR @DotIndex < @BracketIndex) AND (@ColonIndex = 0 OR @DotIndex < @ColonIndex) THEN
        LEFT(@ScopeName, @DotIndex)
    WHEN @BracketIndex > 0 AND (@DotIndex = 0 OR @BracketIndex < @DotIndex) AND (@ColonIndex = 0 OR @BracketIndex < @ColonIndex) THEN
        LEFT(@ScopeName, @BracketIndex)
    WHEN @ColonIndex > 0 AND (@DotIndex = 0 OR @ColonIndex < @DotIndex) AND (@BracketIndex = 0 OR @ColonIndex < @BracketIndex) THEN
        LEFT(@ScopeName, @ColonIndex)
    ELSE
        NULL
    END
END
GO
PRINT N'Creating Function [dbo].[ConvertIndexedScopeName]...';


GO
CREATE FUNCTION [dbo].[ConvertIndexedScopeName]
(
	@ScopeName nvarchar(450),
	@OldDefinitionID int,
	@NewDefinitionID int,
    @ScopeDelimiter char
)
RETURNS nvarchar(450)
AS
BEGIN
	DECLARE @ConvertedScopeName nvarchar(450)

	set @ConvertedScopeName = REPLACE(@ScopeName, 
						'.' + CAST(@OldDefinitionID as varchar) + @ScopeDelimiter, 
						'.'+ CAST(@NewDefinitionID as varchar) + @ScopeDelimiter)
	RETURN @ConvertedScopeName
END
GO
PRINT N'Creating Function [dbo].[BigTableDateTimeSubtract]...';


GO
create FUNCTION dbo.BigTableDateTimeSubtract
(
	@DateTime1 DateTime2,
	@DateTime2 DateTime2
)
RETURNS BigInt
AS
BEGIN

declare @Return BigInt

Select @Return = (Convert(BigInt, 
	DATEDIFF(day, @DateTime1, @DateTime2)) * 86400000) + 
	(DATEDIFF(millisecond, 
		DATEADD(day, 
			DATEDIFF(day, @DateTime1, @DateTime2)
		, @DateTime1)
	, @DateTime2
	)
)

return @Return
END
GO
PRINT N'Creating Function [dbo].[GetScopedProperties]...';


GO
CREATE FUNCTION [dbo].[GetScopedProperties] 
(
	@ContentTypeID int
)
RETURNS @ScopedPropertiesTable TABLE 
(
	ScopeName nvarchar(450)
)
AS
BEGIN
	WITH ScopedProperties(ContentTypeID, PropertyDefinitionID, Scope, Level)
	AS
	(
		--Top level statement
		SELECT T1.pkID as ContentTypeID, tblPropertyDefinition.pkID as PropertyDefinitionID, 
            Scope = CASE WHEN IsList = 1 THEN
                Cast('.' + CAST(tblPropertyDefinition.pkID as VARCHAR) + '(' as varchar)
            ELSE
                Cast('.' + CAST(tblPropertyDefinition.pkID as VARCHAR) + '.' as varchar)
            END,
            0 as Level
		FROM tblPropertyDefinition
		INNER JOIN tblContentType AS T1 ON T1.pkID=tblPropertyDefinition.fkContentTypeID
		INNER JOIN tblContentType ON tblPropertyDefinition.ItemTypeID = tblContentType.ContentTypeGUID
		WHERE tblContentType.pkID = @ContentTypeID
		UNION ALL
		
		--Recursive statement
		SELECT T1.pkID as ContentTypeID, tblPropertyDefinition.pkID as PropertyDefinitionID, 
            Scope = CASE WHEN IsList = 1 THEN
                Cast('.' + CAST(tblPropertyDefinition.pkID as VARCHAR) + '(0)' + Scope as varchar )
            ELSE
                Cast('.' + CAST(tblPropertyDefinition.pkID as VARCHAR) + Scope as varchar)
            END,
            ScopedProperties.Level+1 as Level
		FROM tblPropertyDefinition
		INNER JOIN tblContentType AS T1 ON T1.pkID=tblPropertyDefinition.fkContentTypeID
		INNER JOIN tblContentType ON tblPropertyDefinition.ItemTypeID = tblContentType.ContentTypeGUID
		INNER JOIN ScopedProperties ON ScopedProperties.ContentTypeID = tblContentType.pkID
	)

	INSERT INTO @ScopedPropertiesTable(ScopeName) SELECT Scope from ScopedProperties;
	
	RETURN 
END
GO
PRINT N'Creating Function [dbo].[GetListPropertiesOverThreshold]...';


GO
CREATE FUNCTION [dbo].[GetListPropertiesOverThreshold] 
(
	@ContentLanguages ContentLanguageTable READONLY,
    @Threshold        int
)
RETURNS @ScopedPropertiesTable TABLE 
(
    ContentID int,
	ScopeName nvarchar(450)
)
AS
BEGIN
    DECLARE @DelayedScopes Table(Iterator INT IDENTITY(1, 1), ContentID int, ScopeName nvarchar(450));
	INSERT INTO @DelayedScopes(ContentID, ScopeName) SELECT
    prop.fkContentID as ContentID,
    left(ScopeName, len(ScopeName) - charindex('(', reverse(ScopeName)) + 1) as ScopeName
    from tblContentProperty as prop
    INNER JOIN @ContentLanguages cl on prop.fkContentID = cl.ContentID
    INNER JOIN tblPropertyDefinition as propdef on prop.fkPropertyDefinitionID = propdef.pkID
    AND prop.ListIndex IS NOT NULL
    AND COALESCE(prop.LongStringLength, 0) > @Threshold
    AND (prop.fkLanguageBranchID = cl.LanguageID OR prop.BranchSpecificScope = 0)
    ORDER BY LEN(ScopeName) ASC

    DECLARE @MaxIterator int;
    DECLARE @Iterator int;
    DECLARE @ContentID int;
    DECLARE @ScopeName nvarchar(400);
    SELECT @MaxIterator = MAX(Iterator), @Iterator = 1 FROM @DelayedScopes;
    WHILE @Iterator <= @MaxIterator
    BEGIN
       SELECT @ScopeName = ScopeName, @ContentID = ContentID FROM @DelayedScopes WHERE Iterator = @Iterator
       IF NOT EXISTS (SELECT TOP 1 ContentID FROM @ScopedPropertiesTable WHERE ContentID = @ContentID AND @ScopeName LIKE ScopeName + '%')
       BEGIN
            INSERT INTO @ScopedPropertiesTable(ContentID, ScopeName) VALUES(@ContentID, @ScopeName)
       END
       SET @Iterator = @Iterator + 1 
    END

	RETURN 
END
GO
PRINT N'Creating Function [dbo].[GetScopesForInlineBlocks]...';


GO
CREATE FUNCTION [dbo].[GetScopesForInlineBlocks] 
(
	@PropertyDefinitionID int
)
RETURNS @ScopedPropertiesTable TABLE 
(
	ScopeName nvarchar(450)
)
AS
BEGIN
    WITH ScopeNames(ScopeName, fkPropertyDefinitionID, Level) AS (
      SELECT ScopeName,
      fkPropertyDefinitionID,
      0 AS Level
      FROM tblInlineBlockUsage
      WHERE fkPropertyDefinitionID = @PropertyDefinitionID
      UNION ALL
      SELECT subEntries.ScopeName, subEntries.fkPropertyDefinitionID, s.Level + 1 as Level
      FROM tblInlineBlockUsage subEntries INNER JOIN
      ScopeNames s ON subEntries.fkParentPropertyDefinitionID = s.fkPropertyDefinitionID
      WHERE s.Level <= 20
      -- There is a theoretic possibility to nest areas in a way that is cyclic therefore we break at 20 levels, in reality should there never be such deep "real" inlineblock hierarchies 
     )
    INSERT INTO @ScopedPropertiesTable
    SELECT DISTINCT ScopeName FROM ScopeNames

    RETURN
END
GO
PRINT N'Creating Function [dbo].[GetScopesForDefinition]...';


GO
CREATE FUNCTION [dbo].[GetScopesForDefinition] 
(
	@PropertyDefinitionID int
)
RETURNS @ScopedPropertiesTable TABLE 
(
	ScopeName nvarchar(450)
)
AS
BEGIN
    INSERT INTO @ScopedPropertiesTable SELECT * FROM dbo.GetScopesForInlineBlocks(@PropertyDefinitionID)
    
	--Get blocktype if property is block property
	DECLARE @ContentTypeID INT;
	SET @ContentTypeID = (SELECT tblContentType.pkID FROM 
		tblPropertyDefinition
		INNER JOIN tblContentType ON tblPropertyDefinition.ItemTypeID = tblContentType.ContentTypeGUID
		WHERE tblPropertyDefinition.pkID = @PropertyDefinitionID);
		
	IF (@ContentTypeID IS NOT NULL)
	BEGIN
		INSERT INTO @ScopedPropertiesTable
		SELECT DISTINCT Property.ScopeName FROM
			tblWorkContentProperty as Property WITH(INDEX(IDX_tblWorkContentProperty_ScopeName))
			INNER JOIN dbo.GetScopedProperties(@ContentTypeID) as ScopedProperties ON 
				Property.ScopeName LIKE (ScopedProperties.ScopeName + '%')
				WHERE
                    ScopedProperties.ScopeName LIKE ('%.' + CAST(@PropertyDefinitionID as VARCHAR)+ '.')
                OR
                    ScopedProperties.ScopeName LIKE ('%.' + CAST(@PropertyDefinitionID as VARCHAR)+ '(')
	END
	
	RETURN 
END
GO
PRINT N'Creating Procedure [dbo].[EntityGetGuidByIdFromIdentity]...';


GO
CREATE PROCEDURE dbo.EntityGetGuidByIdFromIdentity
@intObjectTypeID int,
@intObjectID int
AS
BEGIN
	SELECT Guid FROM tblBigTableIdentity INNER JOIN tblBigTableStoreConfig 
		ON tblBigTableIdentity.StoreName = tblBigTableStoreConfig.StoreName
		WHERE tblBigTableIdentity.pkId = @intObjectID AND
			tblBigTableStoreConfig.EntityTypeId = @intObjectTypeID
END
GO
PRINT N'Creating Procedure [dbo].[editSetCommonDraftVersion]...';


GO
CREATE PROCEDURE [dbo].[editSetCommonDraftVersion]
(
	@WorkContentID INT,
	@Force BIT
)
AS
BEGIN
   SET NOCOUNT ON
	SET XACT_ABORT ON

	DECLARE  @ContentLink INT
	DECLARE  @LangID INT
	DECLARE  @CommonDraft INT
    DECLARE  @VariationID INT
	
	-- Find the ContentLink and Language for the Page Work ID 
	SELECT
        @ContentLink = fkContentID,
        @LangID = fkLanguageBranchID,
        @CommonDraft = CommonDraft,
        @VariationID = fkVariationID
    FROM tblWorkContent WHERE
        pkID = @WorkContentID
	
	
	-- If the force flag or there is a common draft which is published we will reset the common draft
	if (@Force = 1 OR EXISTS(SELECT * FROM tblWorkContent WITH(NOLOCK)
        WHERE fkContentID = @ContentLink AND
        Status=4 AND
        fkLanguageBranchID = @LangID
        AND CommonDraft = 1 AND
        ((@VariationID IS NULL AND fkVariationID IS NULL) OR @VariationID = fkVariationID)))
	BEGIN 	
		-- We should remove the old common draft from other content version repect to language
		UPDATE 
			tblWorkContent
		SET
			CommonDraft = 0
		FROM  tblWorkContent WITH(INDEX(IDX_tblWorkContent_fkContentID))
		WHERE
			fkContentID = @ContentLink AND
            fkLanguageBranchID  = @LangID AND
            ((@VariationID IS NULL AND fkVariationID IS NULL) OR @VariationID = fkVariationID)
	END
	-- If the force flag or there is no common draft for the page wirh respect to language
	IF (@Force = 1 OR NOT EXISTS(SELECT * from tblWorkContent WITH(NOLOCK) WHERE
        fkContentID = @ContentLink AND
        fkLanguageBranchID = @LangID AND
        CommonDraft = 1 AND
        ((@VariationID IS NULL AND fkVariationID IS NULL) OR @VariationID = fkVariationID)))
	BEGIN
		UPDATE 
			tblWorkContent
		SET
			CommonDraft = 1
		WHERE
			pkID = @WorkContentID
	END	
		
	IF (@@ROWCOUNT = 0)
		RETURN 1

	RETURN 0
END
GO
PRINT N'Creating Procedure [dbo].[netContentAclDelete]...';


GO
CREATE PROCEDURE dbo.netContentAclDelete
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	DELETE FROM tblContentAccess WHERE fkContentID=@ContentID AND Name=@Name AND IsRole=@IsRole
END
GO
PRINT N'Creating Procedure [dbo].[netBlobListVersionsForUri]...';


GO
CREATE PROCEDURE [dbo].[netBlobListVersionsForUri]
	@BlobUris dbo.StringParameterTable READONLY
AS
BEGIN
    SELECT pkID, fkContentID, BlobUri FROM tblWorkContent INNER JOIN  @BlobUris AS Uris ON tblWorkContent.BlobUri = Uris.String
    ORDER BY(BlobUri)
END
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentitySetMetadata]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentitySetMetadata]
	@ContentGuid uniqueidentifier,
	@Metadata NVARCHAR(MAX),
    @Saved datetime2
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE
        tblMappedIdentity
    SET
        Metadata = @Metadata,
        Saved = @Saved
    WHERE
        ContentGuid = @ContentGuid

    SELECT pkID AS ContentId, Provider, ProviderUniqueId, ContentGuid, ExistingContentId, ExistingCustomProvider, Metadata, Saved
	FROM tblMappedIdentity WHERE ContentGuid = @ContentGuid
END
GO
PRINT N'Creating Procedure [dbo].[DateTimeConversion_MakeTableBlocks]...';


GO
CREATE PROCEDURE [dbo].[DateTimeConversion_MakeTableBlocks]
(
	@TableName NVARCHAR(MAX), 
	@DateTimeColumn NVARCHAR(MAX),
	@StoreName NVARCHAR(MAX), 
	@BlockSize INT, 
	@Print INT)
AS
BEGIN	
	-- Format
	SET @TableName = REPLACE(REPLACE(REPLACE(@TableName,'[',''),']',''),'dbo.','')
	SET @DateTimeColumn = REPLACE(REPLACE(@DateTimeColumn,']',''),'[','')

	-- CHECK tblBigTableReference
	IF (@StoreName IS NOT NULL)
	BEGIN
		DECLARE @BigTableReferenceCount INT
		SELECT @BigTableReferenceCount = COUNT(*) FROM tblBigTableReference r
		JOIN tblBigTableIdentity i ON r.pkId = i.pkId WHERE i.StoreName = @StoreName AND DateTimeValue IS NOT NULL

		IF(@BigTableReferenceCount > 0)
		BEGIN
			DECLARE @BigTableReferenceSql NVARCHAR(MAX) = 
				'UPDATE tbl SET tbl.[DateTimeValue] = CAST([DateTimeValue] AS DATETIME2) + dtc.OffSet FROM tblBigTableReference tbl ' +
				'INNER JOIN [dbo].[tblDateTimeConversion_Offset] dtc ON tbl.[DateTimeValue] >= dtc.IntervalStart AND tbl.[DateTimeValue] < dtc.IntervalEnd ' +
				'INNER JOIN [dbo].[tblBigTableIdentity] bti ON bti.StoreName = ''' + @StoreName + ''' AND tbl.pkId = bti.pkId ' +
				'WHERE tbl.[DateTimeValue] IS NOT NULL '
			INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, [Sql], BlockRank,BlockCount) 
			SELECT TableName = 'tblBigTableReference', ColName = 'DateTimeValue', @StoreName, [Sql] = @BigTableReferenceSql , BlockRank = 0, BlockCount = @BigTableReferenceCount
		END
	END

	-- Get primary keys
	DECLARE @Keys TABLE(Data NVARCHAR(100)) 
	INSERT INTO @Keys
	SELECT i.COLUMN_NAME
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE i
	WHERE OBJECTPROPERTY(OBJECT_ID(i.CONSTRAINT_NAME), 'IsPrimaryKey') = 1
	AND i.TABLE_NAME = @TableName

	IF ((SELECT COUNT(*) FROM @Keys) = 0 )
	BEGIN
		INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, [Sql],Converted,BlockRank,BlockCount) 
		SELECT TableName = @TableName, ColName = @DateTimeColumn, @StoreName, [Sql] = NULL, Converted = 1, BlockRank = -1, BlockCount = 0 
		RETURN		
	END

	-- Get total number of primary keys
	DECLARE @TotalPrimaryKeys INT  
	SELECT @TotalPrimaryKeys = COUNT(*) FROM @Keys

	-- Get number of integer primary keys
	DECLARE @IntegerPrimaryKeys INT  
	SELECT @IntegerPrimaryKeys = COUNT(*)
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE i
	JOIN INFORMATION_SCHEMA.COLUMNS c on i.COLUMN_NAME = c.COLUMN_NAME AND i.TABLE_NAME = c.TABLE_NAME
	WHERE OBJECTPROPERTY(OBJECT_ID(i.CONSTRAINT_NAME), 'IsPrimaryKey') = 1 AND c.DATA_TYPE IN ('bigint','int')
	AND i.TABLE_NAME = @TableName

	-- Non integer primary keys handling
	IF (@TotalPrimaryKeys > @IntegerPrimaryKeys)
	BEGIN
		DECLARE @NonIntegerSql NVARCHAR(MAX) = 'UPDATE tbl SET tbl.[' + @DateTimeColumn + '] = CAST('+ @DateTimeColumn +' AS DATETIME2) + dtc.OffSet FROM ' + @TableName + ' tbl INNER JOIN [dbo].[tblDateTimeConversion_Offset] dtc ON tbl.[' + @DateTimeColumn + '] >= dtc.IntervalStart AND tbl.[' + @DateTimeColumn + '] < dtc.IntervalEnd WHERE tbl.[' + @DateTimeColumn + '] IS NOT NULL '
		INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, Sql, BlockRank,BlockCount) 
		SELECT TableName = @TableName, ColName = @DateTimeColumn, @StoreName, Sql = @NonIntegerSql , BlockRank = -2, BlockCount = 0
		RETURN 
	END

	DECLARE @storeCondition NVARCHAR(MAX) = CASE WHEN @StoreName IS NULL THEN ' ' ELSE ' AND storeName = ''' + @StoreName + ''' ' END 	 

	-- Zero count handling
	DECLARE @sSQL nvarchar(500) = N'SELECT @retvalOUT = COUNT(*) FROM (SELECT TOP ' + CAST((@BlockSize + 1) AS NVARCHAR(10)) + ' * FROM ' + @TableName + ' WHERE [' + @DateTimeColumn + '] IS NOT NULL ' + @storeCondition + ') X'  
	DECLARE @ParmDefinition nvarchar(500) = N'@retvalOUT int OUTPUT'
	DECLARE @retval int   
	EXEC sp_executesql @sSQL, @ParmDefinition, @retvalOUT=@retval OUTPUT
	IF (@retval = 0)
	BEGIN
		INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, Sql,Converted,BlockRank,BlockCount) 
		SELECT TableName = @TableName, ColName = @DateTimeColumn, @StoreName, Sql = NULL, Converted = 1, BlockRank = 0, BlockCount = 0 
		RETURN
	END

	-- Create formatted list of keys for use in queries

	DECLARE @Values_List NVARCHAR(MAX) = ''
	SELECT @Values_List = @Values_List + '[' + Data + '], ' FROM @Keys
	SET @Values_List = Substring(@Values_List, 1, len(@Values_List) - 1)

	DECLARE @Values_List2 NVARCHAR(MAX) = ''
	SELECT @Values_List2 = @Values_List2 + 'tbl.[' + Data + '], ' FROM @Keys
	SET @Values_List2 = Substring(@Values_List2, 1, len(@Values_List2) - 1)

	DECLARE @Values_RowId NVARCHAR(MAX) = ''
	SELECT @Values_RowId = @Values_RowId + ' REPLACE(STR([' + Data + '], 16), '' '' , ''0'') +' FROM @Keys
	SET @Values_RowId = Substring(@Values_RowId, 1, len(@Values_RowId) - 1)

	DECLARE @Values_RowId2 NVARCHAR(MAX) = ''
	SELECT @Values_RowId2 = @Values_RowId2 + ' REPLACE(STR(tbl.[' + Data + '], 16), '''' '''' , ''''0'''') +' FROM @Keys
	SET @Values_RowId2 = Substring(@Values_RowId2, 1, len(@Values_RowId2) - 1)
	
	DECLARE @Values_MinMaxList NVARCHAR(MAX) = ''
	SELECT @Values_MinMaxList = @Values_MinMaxList + ' [Min' + Data + '], [Max' + Data + '], ' FROM @Keys
	SET @Values_MinMaxList = Substring(@Values_MinMaxList, 1, len(@Values_MinMaxList) - 1)
	
	DECLARE @Values_MinMaxSet NVARCHAR(MAX) = ''
	SELECT @Values_MinMaxSet = @Values_MinMaxSet + ' [Min' + Data + '] = MIN(' + Data + '), [Max' + Data + '] = MAX(' + Data + '),' FROM @Keys
	SET @Values_MinMaxSet = Substring(@Values_MinMaxSet, 1, len(@Values_MinMaxSet) - 1)
	
	DECLARE @Values_Declare NVARCHAR(MAX) = ''
	SELECT @Values_Declare = @Values_Declare + ' [Min' + Data + '] INT NOT NULL, ' + ' [Max' + Data + '] INT NOT NULL, ' FROM @Keys
	
	DECLARE @Values_Condition NVARCHAR(MAX) = ''
	SELECT @Values_Condition = ' [Min' + @Values_Condition + Data + ',' FROM @Keys
	SET @Values_Condition = Substring(@Values_Condition, 1, len(@Values_Condition) - 1)

	DECLARE @Values_Declare2 NVARCHAR(MAX) = ''
	SELECT @Values_Declare2 = @Values_Declare2 + ' [' + Data + '] INT NOT NULL, ' FROM @Keys

	DECLARE @Values_Condition2 NVARCHAR(MAX) = ''
	SELECT @Values_Condition2 = @Values_Condition2 + ' tbl.['+Data+'] = t.['+Data+'] AND' FROM @Keys
	SET @Values_Condition2 = Substring(@Values_Condition2, 1, len(@Values_Condition2) - 3)
	
	DECLARE @SQL NVARCHAR(MAX) = ''
		+ 'DECLARE @DATA AS TABLE( '
		+ '	[MIN] DATETIME2 NULL, '
		+ '	[MAX] DATETIME2 NULL, '
		+ '	BlockRank INT NOT NULL, ' 
		+ '	BlockCount INT NOT NULL, '
		+ @Values_Declare
		+ '	IntervalStart VARCHAR(50) NULL, '
		+ '	IntervalEnd	VARCHAR(50) NULL, '
		+ '	ConditionSql NVARCHAR(MAX) NULL, '
		+ '	UpdateSql NVARCHAR(MAX) NULL, '
		+ '	Converted BIT NOT NULL DEFAULT 0 '
		+ ') '
		+ ' '
		+ 'DECLARE @BLOCK AS TABLE([MIN] DATETIME2 NULL, [MAX] DATETIME2 NULL, BlockRank INT NOT NULL, ' + @Values_Declare + 'BlockCount INT NOT NULL) '
		+ 'DECLARE @BLOCKROW1000 AS TABLE(BlockRank INT NOT NULL, RowId NVARCHAR(' + CAST(@IntegerPrimaryKeys * 16 AS NVARCHAR(10)) + ') NOT NULL) '
		+ ' '
		+ 'INSERT INTO @BLOCK '
		+ 'SELECT [MIN] = MIN(DT), [MAX] = MAX(DT), BlockRank = ([RANK] - 1) / ' + CAST((@BlockSize) AS NVARCHAR(10)) + ', ' + @Values_MinMaxSet + ', BlockCount = COUNT(*) '
		+ 'FROM ( '
		+ '    SELECT DT = [' + @DateTimeColumn + '], [Rank] = DENSE_RANK() OVER (ORDER BY ' + @Values_List + '), ' + @Values_List + ' '
		+ '    FROM ' + @TableName + ' WITH(NOLOCK) '
		+ '    WHERE [' + @DateTimeColumn + '] IS NOT NULL ' + @storeCondition
		+ '    ) AS RowNr '
		+ 'GROUP BY ((([Rank]) - 1) / ' + CAST((@BlockSize) AS NVARCHAR(10)) + ') '
		+ ' '
		+ 'INSERT INTO @BLOCKROW1000 '
		+ 'SELECT BlockRank = (DENSE_RANK() OVER (ORDER BY [RowID]) - 1), RowID FROM ( '
		+ '    SELECT RowID = ' + @Values_RowId + ' '
		+ '    FROM ( '
		+ '        SELECT ' + @Values_List + ', DENSE_RANK() OVER (ORDER BY ' + @Values_List + ') AS rownum '
		+ '	       FROM ' + @TableName + ' WITH(NOLOCK) '
		+ '        WHERE [' + @DateTimeColumn + '] IS NOT NULL ' + @storeCondition
		+ '        ) AS RowNr '
		+ '    WHERE RowNr.rownum % ' + CAST((@BlockSize) AS NVARCHAR(10)) + ' = 0   '  
		+ '    ) AS Row1000 '
		+ ' '
		+ 'INSERT INTO @DATA '
		+ 'SELECT [MIN], [MAX], Block.BlockRank, BlockCount, ' + @Values_MinMaxList + ', IntervalStart = NULL, IntervalEnd = RowID, ConditionSql = NULL, UpdateSql = NULL, Converted = 0 '
		+ 'FROM @BLOCK Block '
		+ 'LEFT JOIN @BLOCKROW1000	BlockRow1000 '
		+ 'ON Block.BlockRank = BlockRow1000.BlockRank '
		+ 'ORDER BY Block.BlockRank   '
		+ ' '
		+ 'UPDATE d1 SET d1.IntervalStart = d2.IntervalEnd FROM @DATA d1 JOIN @DATA d2 ON d1.BlockRank = d2.BlockRank + 1 '
		+ 'UPDATE @DATA SET IntervalStart = ''' + REPLICATE('0', 16 * @IntegerPrimaryKeys) + ''' WHERE BlockRank = (SELECT MIN(BlockRank) from @DATA) '
		+ 'UPDATE @DATA SET IntervalEnd = ''' + REPLICATE('9', 16 * @IntegerPrimaryKeys) + ''' WHERE BlockRank = (SELECT MAX(BlockRank) from @DATA) '
		+ 'UPDATE @Data SET ConditionSql = '' [' + @DateTimeColumn + '] IS NOT NULL ' + REPLACE(@storeCondition,'''','''''') + ' '' '
	SELECT @SQL = @SQL + ' + '' AND tbl.['+Data+'] >= ''+CAST([Min'+Data+'] AS NVARCHAR(20))+'' AND tbl.['+Data+'] <= ''+CAST([Max'+Data+'] AS NVARCHAR(20))+'' '' ' FROM @Keys v

	IF (@TotalPrimaryKeys>1)
		SET @SQL = @SQL +' + '' AND '+ @Values_RowId2 + ' > '''''' + IntervalStart + '''''' AND ' + @Values_RowId2 + ' <= '''''' + IntervalEnd + '''''' '' '

	DECLARE @UPDATESQL NVARCHAR(MAX) ='
		DECLARE @OffsetTEMP AS TABLE( [IntervalStart] DATETIME2 NOT NULL,[IntervalEnd] DATETIME2 NOT NULL, [Offset] FLOAT NOT NULL) 
		DECLARE @MIN DATETIME2 = ''''[[MIN]]'''', @MAX DATETIME2 = ''''[[MAX]]'''' 
		INSERT INTO @OffsetTEMP 
		SELECT c.IntervalStart, c.IntervalEnd, c.Offset 
		FROM tblDateTimeConversion_Offset c WITH (NOLOCK)  
		WHERE c.IntervalStart-1 >= @MIN AND c.IntervalEnd+1 <= @MAX OR @MIN between c.IntervalStart-1 and c.IntervalEnd+1 OR @MAX between c.IntervalStart-1 and c.IntervalEnd+1
	
		DECLARE @'+@TableName+'TEMP AS TABLE('+@Values_Declare2+' [' + @DateTimeColumn + '] DATETIME2 NOT NULL,PRIMARY KEY('+@Values_List+')) 
		INSERT INTO @'+@TableName+'TEMP 
		SELECT '+@Values_List2+', [' + @DateTimeColumn + '] = tbl.[' + @DateTimeColumn + '] + CAST(c.OffSet AS DATETIME2)  
		FROM  @OffsetTEMP c
		JOIN ['+@TableName+'] tbl WITH(NOLOCK) ON tbl.[' + @DateTimeColumn + ']>=c.IntervalStart AND tbl.[' + @DateTimeColumn + ']<c.IntervalEnd 
		WHERE [[CONDITION]] 
		OPTION (LOOP JOIN) 
	
		DECLARE @StartTimeStamp DATETIME2 = SYSDATETIME() 
	
		UPDATE tbl 
		SET tbl.[' + @DateTimeColumn + '] = t.[' + @DateTimeColumn + '] 
		FROM @'+@TableName+'TEMP t 
		JOIN ['+@TableName+'] tbl WITH(ROWLOCK) ON '+@Values_Condition2 + '
		OPTION (LOOP JOIN) 
	
		DECLARE @EndTimeStamp DATETIME2 = SYSDATETIME() 
		SET @UpdateTimeRETURN = DATEDIFF(MS,@StartTimeStamp,@EndTimeStamp) '

	SET @SQL = @SQL 
		+ 'DECLARE @UpdateSql NVARCHAR(MAX) '
		+ 'SET @UpdateSql = ''' + @UPDATESQL + ' '' '
		+ 'UPDATE @Data SET UpdateSql = @UpdateSql '
		+ 'INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, Sql,Priority,BlockRank,BlockCount) SELECT TableName = ''' + @TableName + ''', ColName = ''' + @DateTimeColumn + ''', StoreName= ' + COALESCE('''' + @StoreName + '''', 'NULL') + ', Sql = REPLACE(REPLACE(REPLACE(UpdateSql,''[[CONDITION]]'',ConditionSql),''[[MIN]]'',[MIN]),''[[MAX]]'',[MAX]), Priority = BlockRank, BlockRank = d.BlockRank,BlockCount=d.BlockCount FROM @DATA d '

	EXEC (@SQL)

	UPDATE tbl 
	SET [Priority] = f.MaxRank-tbl.BlockRank + 1
	FROM tblDateTimeConversion_Block tbl 
	JOIN (SELECT * FROM (
		SELECT TableName, MaxRank = MAX(BlockRank) 
		FROM tblDateTimeConversion_Block 
		WHERE Converted = 0 and [Sql] IS NOT NULL 
		GROUP BY TableName) x 
	WHERE MaxRank >= 0) f ON f.TableName = tbl.TableName 
	WHERE tbl.TableName = @TableName AND tbl.ColName = @DateTimeColumn 
END
GO
PRINT N'Creating Procedure [dbo].[netContentAclList]...';


GO
CREATE PROCEDURE dbo.netContentAclList
(
	@ContentID INT
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT 
		Name,
		IsRole, 
		AccessMask
	FROM 
		tblContentAccess
	WHERE 
		fkContentID=@ContentID
	ORDER BY
		IsRole DESC,
		Name
END
GO
PRINT N'Creating Procedure [dbo].[netURLSegmentListPages]...';


GO
CREATE PROCEDURE [dbo].[netURLSegmentListPages]
(
	@URLSegment	NCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON

	IF (LEN(@URLSegment) = 0)
	BEGIN
		set @URLSegment = NULL
	END 

	SELECT DISTINCT fkPageID as "PageID"
	FROM tblPageLanguage
	WHERE URLSegment = @URLSegment
	OR (@URLSegment = NULL AND URLSegment = '' OR URLSegment IS NULL)

END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogAssociatedGetLowest]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogAssociatedGetLowest]
(
	@AssociatedItem		[nvarchar](255)
)

AS            
BEGIN
	SELECT MIN(pkID)
		FROM
		(SELECT pkID
			FROM [tblActivityLog]
			WHERE 
				RelatedItem = @AssociatedItem
				AND
				Deleted = 0
		UNION
			SELECT pkID
			FROM [tblActivityLog] 
			INNER JOIN [tblActivityLogAssociation] TAR ON pkID = TAR.[To]
			WHERE 
				TAR.[From] = @AssociatedItem 
				AND
				Deleted = 0) AS RESULT
END
GO
PRINT N'Creating Procedure [dbo].[netPageLanguageSettingListTree]...';


GO
CREATE PROCEDURE dbo.netPageLanguageSettingListTree
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT
	    fkPageID,
        RTRIM(Branch.LanguageID) as LanguageBranch,
        RTRIM(ReplacementBranch.LanguageID) as ReplacementBranch,
        LanguageBranchFallback,
        Active
	FROM 
	    tblPageLanguageSetting
	INNER JOIN 
	    tblLanguageBranch AS Branch 
	ON 
	    Branch.pkID = tblPageLanguageSetting.fkLanguageBranchID
	LEFT JOIN 
	    tblLanguageBranch AS ReplacementBranch 
	ON 
	    ReplacementBranch.pkID = tblPageLanguageSetting.fkReplacementBranchID
	ORDER BY 
	    fkPageID ASC
END
GO
PRINT N'Creating Procedure [dbo].[sp_GetDateTimeKind]...';


GO
CREATE PROCEDURE [dbo].[sp_GetDateTimeKind]
AS
	-- 0 === Unspecified  
	-- 1 === Local time 
	-- 2 === UTC time 
	RETURN 2
GO
PRINT N'Creating Procedure [dbo].[netNotificationSubscriptionListByUser]...';


GO
CREATE PROCEDURE [dbo].[netNotificationSubscriptionListByUser]
	@UserName [nvarchar](255)
AS
BEGIN 
	SELECT [pkID], [UserName], [SubscriptionKey] FROM [dbo].[tblNotificationSubscription] WHERE Active = 1 AND UserName = @UserName
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalDelete]...';


GO
CREATE PROCEDURE [dbo].[netApprovalDelete](
	@ApprovalIDs [dbo].[IDTable] READONLY)
AS
BEGIN
	DELETE approval FROM [dbo].[tblApproval] approval 
	JOIN @ApprovalIDs ids ON approval.pkID = ids.ID
END
GO
PRINT N'Creating Procedure [dbo].[BigTableDeleteItem]...';


GO
CREATE PROCEDURE [dbo].[BigTableDeleteItem]
@StoreId BIGINT = NULL,
@ExternalId uniqueidentifier = NULL
AS
BEGIN
	IF @StoreId IS NULL
	BEGIN
		SELECT @StoreId = pkId FROM tblBigTableIdentity WHERE [Guid] = @ExternalId
	END
	IF @StoreId IS NULL RAISERROR(N'No object exists for the unique identifier passed', 1, 1)

	DECLARE @deletes AS BigTableDeleteItemInternalTable;
	INSERT INTO @deletes(Id, NestLevel, ObjectPath) VALUES(@StoreId, 1, '/' + CAST(@StoreId AS varchar) + '/')

	EXEC sp_executesql N'BigTableDeleteItemInternal @deletes', N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationSubscriptionSubscribe]...';


GO
CREATE PROCEDURE [dbo].[netNotificationSubscriptionSubscribe]
	@UserName [nvarchar](255),
	@SubscriptionKey [nvarchar](255)
AS
BEGIN
	DECLARE @key [nvarchar](256) = @SubscriptionKey + CASE SUBSTRING(@SubscriptionKey, LEN(@SubscriptionKey), 1) WHEN N'/' THEN N'' ELSE N'/' END

	DECLARE @SubscriptionCount INT 
	SELECT @SubscriptionCount = COUNT(*) FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName AND SubscriptionKey = @key AND Active = 1
	IF (@SubscriptionCount > 0)
	BEGIN
		SELECT 0
		RETURN
	END
	SELECT @SubscriptionCount = COUNT(*) FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName AND SubscriptionKey = @key AND Active = 0
	IF (@SubscriptionCount > 0)
		UPDATE [dbo].[tblNotificationSubscription] SET Active = 1 WHERE UserName = @UserName AND SubscriptionKey = @key
	ELSE 
		INSERT INTO [dbo].[tblNotificationSubscription](UserName, SubscriptionKey) VALUES (@UserName, @key)	
	SELECT 1
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalAdd]...';


GO
CREATE PROCEDURE [dbo].[netApprovalAdd](
	@StartedBy NVARCHAR(255),
	@Started DATETIME2,
	@Approvals [dbo].[AddApprovalTable] READONLY)
AS
BEGIN
    DELETE t FROM [dbo].[tblApproval] t  WITH (HOLDLOCK)
	JOIN @Approvals a ON t.ApprovalKey = a.ApprovalKey

	DECLARE @StepCounts AS TABLE(VersionID INT, StepCount INT, RequireCommentOnApprove BIT, RequireCommentOnReject BIT, RequireCommentOnStart BIT)

	INSERT INTO @StepCounts
	SELECT VersionID, COUNT(*) AS StepCount, RequireCommentOnApprove, RequireCommentOnReject, RequireCommentOnStart FROM (
		SELECT DISTINCT adv.pkID AS VersionID, ads.pkID AS StepID, adv.RequireCommentOnApprove, adv.RequireCommentOnReject, adv.RequireCommentOnStart FROM [dbo].[tblApprovalDefinitionVersion] adv
		JOIN [dbo].[tblApprovalDefinitionStep] ads ON adv.pkID = ads.fkApprovalDefinitionVersionID
		JOIN @Approvals approvals ON approvals.ApprovalDefinitionVersionID = adv.pkID
	) X	GROUP BY VersionID, RequireCommentOnApprove, RequireCommentOnReject, RequireCommentOnStart

	INSERT INTO [dbo].[tblApproval]([fkApprovalDefinitionVersionID], [ApprovalKey], [fkLanguageBranchID], [ActiveStepIndex], [ActiveStepStarted], [StepCount], [StartedBy], [Started], [Completed], [ApprovalStatus], [RequireCommentOnApprove], [RequireCommentOnReject], [RequireCommentOnStart])
	SELECT a.ApprovalDefinitionVersionID, a.ApprovalKey, a.LanguageBranchID, 0, @Started, sc.StepCount, @StartedBy, @Started, NULL, 0, sc.RequireCommentOnApprove, sc.RequireCommentOnReject, sc.RequireCommentOnStart FROM @Approvals a
	JOIN @StepCounts sc ON a.ApprovalDefinitionVersionID = sc.VersionID

	SELECT t.ApprovalKey, t.pkID AS ApprovalID, t.StepCount, t.RequireCommentOnApprove, t.RequireCommentOnReject, t.RequireCommentOnStart FROM [dbo].[tblApproval] t
	JOIN @Approvals a ON t.ApprovalKey = a.ApprovalKey
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogAssociationDeleteRelated]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogAssociationDeleteRelated]
(
	@AssociatedItem	[nvarchar](255),
	@RelatedItem	[nvarchar](255)
)
AS            
BEGIN
	DECLARE @RelatedItemCompare NVARCHAR(256) = CASE RIGHT(@RelatedItem, 1) WHEN '/' THEN LEFT(@RelatedItem, LEN(@RelatedItem) - 1) ELSE @RelatedItem END
	DECLARE @RelatedItemLike NVARCHAR(256) = @RelatedItemCompare + '%'
	DECLARE @RelatedItemLength INT = LEN(@RelatedItemLike)

	DELETE FROM [tblActivityLogAssociation] 
	FROM [tblActivityLogAssociation] AS TCLA INNER JOIN [tblActivityLog] AS TCL ON TCLA.[To] = TCL.pkID
	WHERE (TCLA.[From] = @AssociatedItem AND TCL.[RelatedItem] LIKE @RelatedItemLike AND (TCL.[RelatedItem] = @RelatedItemCompare OR SUBSTRING(TCL.[RelatedItem], @RelatedItemLength, 1) = '/'))
	OR (TCLA.[From] LIKE @RelatedItemLike AND TCL.[RelatedItem] = @AssociatedItem AND (TCLA.[From] = @RelatedItemCompare OR SUBSTRING(TCLA.[From], @RelatedItemLength, 1) = '/'))
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalDefinitionVersionList]...';


GO
CREATE PROCEDURE [dbo].[netApprovalDefinitionVersionList](
	@ApprovalDefinitionID INT)
AS
BEGIN
	SELECT DISTINCT [definition].* FROM [dbo].[tblApprovalDefinition] [definition] 
	JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON [definition].pkID = [version].fkApprovalDefinitionID
	WHERE [definition].pkID = @ApprovalDefinitionID
	
	SELECT * FROM [dbo].[tblApprovalDefinitionVersion] WHERE fkApprovalDefinitionID = @ApprovalDefinitionID

	SELECT step.* FROM [dbo].[tblApprovalDefinitionStep] step
	JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON step.fkApprovalDefinitionVersionID = [version].pkID
	WHERE [version].fkApprovalDefinitionID = @ApprovalDefinitionID
	
	SELECT reviewer.* FROM [dbo].[tblApprovalDefinitionReviewer] reviewer
	JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON reviewer.fkApprovalDefinitionVersionID = [version].pkID
	WHERE [version].fkApprovalDefinitionID = @ApprovalDefinitionID
END
GO
PRINT N'Creating Procedure [dbo].[netPagesChangedAfter]...';


GO
CREATE PROCEDURE dbo.netPagesChangedAfter
( 
	@RootID INT,
	@ChangedAfter DATETIME2,
	@MaxHits INT,
	@StopPublish DATETIME2
)
AS
BEGIN
	SET NOCOUNT ON
    SET @MaxHits = @MaxHits + 1 -- Return one more to determine if there are more pages to fetch (gets MaxHits + 1)
    SET ROWCOUNT @MaxHits
    
	SELECT 
	    tblContentLanguage.fkContentID AS PageID,
		RTRIM(tblLanguageBranch.LanguageID) AS LanguageID
	FROM
		tblContentLanguage
	INNER JOIN
		tblTree
	ON
		tblContentLanguage.fkContentID = tblTree.fkChildID AND (tblTree.fkParentID = @RootID OR (tblTree.fkChildID = @RootID AND tblTree.NestingLevel = 1))
	INNER JOIN
		tblLanguageBranch
	ON
		tblContentLanguage.fkLanguageBranchID = tblLanguageBranch.pkID
	WHERE
		(tblContentLanguage.Changed > @ChangedAfter OR tblContentLanguage.StartPublish > @ChangedAfter) AND
		(tblContentLanguage.StopPublish is NULL OR tblContentLanguage.StopPublish > @StopPublish) AND
		tblContentLanguage.Status = 4
	ORDER BY
		tblTree.NestingLevel,
		tblContentLanguage.fkContentID,
		tblContentLanguage.Changed DESC
		
	SET ROWCOUNT 0
END
GO
PRINT N'Creating Procedure [dbo].[BigTableSaveReference]...';


GO
CREATE PROCEDURE [dbo].[BigTableSaveReference]
	@Id bigint,
	@Type int,
	@PropertyName nvarchar(75),
	@CollectionType nvarchar(2000) = NULL,
	@ElementType nvarchar(2000) = NULL,
	@ElementStoreName nvarchar(375) = null,
	@IsKey bit,
	@Index int,
	@BooleanValue bit = NULL,
	@IntegerValue int = NULL,
	@LongValue bigint = NULL,
	@DateTimeValue datetime2 = NULL,
	@GuidValue uniqueidentifier = NULL,
	@FloatValue float = NULL,	
	@StringValue nvarchar(max) = NULL,
	@BinaryValue varbinary(max) = NULL,
	@RefIdValue bigint = NULL,
	@ExternalIdValue bigint = NULL,
	@DecimalValue decimal(18, 3) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if not exists(select * from tblBigTableReference where pkId = @Id and PropertyName = @PropertyName and IsKey = @IsKey and [Index] = @Index)
	begin
		-- insert
		insert into tblBigTableReference
		values
		(
			@Id,
			@Type,
			@PropertyName,
			@CollectionType,
			@ElementType,
			@ElementStoreName,
			@IsKey,
			@Index,
			@BooleanValue,
			@IntegerValue,
			@LongValue,
			@DateTimeValue,
			@GuidValue,
			@FloatValue,
			@StringValue,
			@BinaryValue,
			@RefIdValue,
			@ExternalIdValue,
			@DecimalValue
		)
	end
	else
	begin
		-- update
		update tblBigTableReference
		set
		CollectionType = @CollectionType,
		ElementType = @ElementType,
		ElementStoreName  = @ElementStoreName,
		BooleanValue = @BooleanValue,
		IntegerValue = @IntegerValue,
		LongValue = @LongValue,
		DateTimeValue = @DateTimeValue,
		GuidValue = @GuidValue,
		FloatValue = @FloatValue,
		StringValue = @StringValue,
		BinaryValue = @BinaryValue,
		RefIdValue = @RefIdValue,
		ExternalIdValue = @ExternalIdValue,
		DecimalValue = @DecimalValue
		where
		pkId = @Id and PropertyName = @PropertyName and IsKey = @IsKey and [Index] = @Index
	end   
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalDefinitionVersionDelete]...';


GO
CREATE PROCEDURE [dbo].[netApprovalDefinitionVersionDelete](
	@ApprovalDefinitionVersionID INT)
AS
BEGIN
	DECLARE @ApprovalDefinitionID INT 
	DECLARE @CurrentApprovalDefinitionVersionID INT 

	SELECT @CurrentApprovalDefinitionVersionID = [definition].fkCurrentApprovalDefinitionVersionID, @ApprovalDefinitionID = [definition].pkID
	FROM [dbo].[tblApprovalDefinition] [definition]
	JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON [definition].pkID = [version].fkApprovalDefinitionID
	WHERE [version].pkID = @ApprovalDefinitionVersionID

	IF NOT EXISTS(SELECT 1 FROM [dbo].[tblApproval] WHERE fkApprovalDefinitionVersionID = @ApprovalDefinitionVersionID AND ApprovalStatus = 0)
	BEGIN
		DELETE FROM [dbo].[tblApproval] WHERE fkApprovalDefinitionVersionID = @ApprovalDefinitionVersionID AND ApprovalStatus != 0 
		IF @ApprovalDefinitionVersionID = @CurrentApprovalDefinitionVersionID  
		BEGIN
			IF EXISTS(SELECT pkID FROM [dbo].[tblApprovalDefinitionVersion] WHERE fkApprovalDefinitionID = @ApprovalDefinitionID AND pkID != @ApprovalDefinitionVersionID)
			BEGIN
				UPDATE [dbo].[tblApprovalDefinition] SET fkCurrentApprovalDefinitionVersionID = NULL WHERE pkID = @ApprovalDefinitionID
				DELETE FROM [dbo].[tblApprovalDefinitionVersion] WHERE pkID = @ApprovalDefinitionVersionID
			END ELSE BEGIN 
				DELETE FROM [dbo].[tblApprovalDefinition] WHERE pkID = @ApprovalDefinitionID		
			END
		END ELSE BEGIN
			DELETE FROM [dbo].[tblApprovalDefinitionVersion] WHERE pkID = @ApprovalDefinitionVersionID
		END
	END
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalDefinitionDelete]...';


GO
CREATE PROCEDURE [dbo].[netApprovalDefinitionDelete](
	@ApprovalDefinitionIDs [dbo].[IDTable] READONLY)
AS
BEGIN
	DECLARE @IDStatus TABLE (ID INT, [Status] INT)
	INSERT INTO @IDStatus
	SELECT a.pkID,a.ApprovalStatus FROM [dbo].[tblApproval] a 
	JOIN [dbo].[tblApprovalDefinitionVersion] v ON a.fkApprovalDefinitionVersionID = v.pkID 
	JOIN @ApprovalDefinitionIDs ids ON v.fkApprovalDefinitionID = ids.ID

	IF NOT EXISTS(SELECT 1 FROM @IDStatus i WHERE i.[Status] = 0)  
	BEGIN 
		DELETE a FROM [dbo].[tblApproval] a 
		JOIN @IDStatus i ON a.pkID = i.ID
		WHERE i.[Status] != 0  

		DELETE [definition] FROM [dbo].[tblApprovalDefinition] [definition]
		JOIN @ApprovalDefinitionIDs ids ON [definition].pkID = ids.ID
	END
END
GO
PRINT N'Creating Procedure [dbo].[DateTimeConversion_InitDateTimeOffsets]...';


GO
CREATE PROCEDURE [dbo].[DateTimeConversion_InitDateTimeOffsets]
(@DateTimeOffsets [dbo].[DateTimeConversion_DateTimeOffset] READONLY)
AS
BEGIN
	IF OBJECT_ID('[dbo].[tblDateTimeConversion_Offset]', 'U') IS NOT NULL
		DROP TABLE [dbo].[tblDateTimeConversion_Offset]

	CREATE TABLE [dbo].[tblDateTimeConversion_Offset](
		[pkID] [INT] IDENTITY(1,1) NOT NULL,
		[IntervalStart] [DATETIME2] NOT NULL, 
		[IntervalEnd] [DATETIME2] NOT NULL,
		[Offset] DECIMAL(24,20) NOT NULL,
		CONSTRAINT [PK_tblDateTimeConversion_Offset] PRIMARY KEY  CLUSTERED
		(
			[pkID]
		)
	)
	INSERT INTO [dbo].[tblDateTimeConversion_Offset](IntervalStart, IntervalEnd, Offset)
	SELECT  tbl.IntervalStart,tbl.IntervalEnd,-CAST(tbl.Offset AS DECIMAL(24,20))/24/60 FROM @DateTimeOffsets tbl

	CREATE UNIQUE INDEX IDX_DateTimeConversion_Interval1 ON [dbo].[tblDateTimeConversion_Offset](IntervalStart ASC, IntervalEnd ASC) 
	CREATE UNIQUE INDEX IDX_DateTimeConversion_Interval2 ON [dbo].[tblDateTimeConversion_Offset](IntervalStart DESC, IntervalEnd DESC) 
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessagesDelete]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessagesDelete]
	@MessageIDs dbo.IDTable READONLY
AS
BEGIN
	DELETE M
	FROM [tblNotificationMessage] AS M INNER JOIN @MessageIDs AS IDS ON M.pkID = IDS.ID
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationCloseConnection]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationCloseConnection]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        select @processorId = p.ProcessorId, @processorStatus = p.ProcessorStatus
        from tblChangeNotificationConnection c
        join tblChangeNotificationProcessor p on c.ProcessorId = p.ProcessorId
        where c.ConnectionId = @connectionId

        update tblChangeNotificationQueuedInt set ConnectionId = null where ConnectionId = @connectionId
        update tblChangeNotificationQueuedGuid set ConnectionId = null where ConnectionId = @connectionId
        update tblChangeNotificationQueuedString set ConnectionId = null where ConnectionId = @connectionId
        delete from tblChangeNotificationConnection where ConnectionId = @connectionId

        if (@processorStatus != 'valid' and not exists (select 1 from tblChangeNotificationConnection where ProcessorId = @processorId))
        begin
            -- if there are no connections to the queue and it is not in a valid state, remove it from persistent storage.
            delete from tblChangeNotificationQueuedInt where ProcessorId = @processorId
            delete from tblChangeNotificationQueuedGuid where ProcessorId = @processorId
            delete from tblChangeNotificationQueuedString where ProcessorId = @processorId
            delete from tblChangeNotificationProcessor where ProcessorId = @processorId
        end

        commit transaction

        select @connectionId as ConnectionId
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netActivityLogCommentSave]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogCommentSave]
(
	@Id			BIGINT = 0 OUTPUT,
	@EntryId	BIGINT, 
    @Author		NVARCHAR(255) = NULL, 
    @Created	DATETIME2, 
    @LastUpdated DATETIME2, 
    @Message	NVARCHAR(max)
)
AS            
BEGIN
	IF (@Id = 0)
	BEGIN
		INSERT INTO [tblActivityLogComment] VALUES(@EntryId, @Author, @Created, @Created, @Message)
		SET @Id = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE [tblActivityLogComment] SET
			[EntryId] = @EntryId,
			[Author] = @Author,
			[LastUpdated] = @LastUpdated,
			[Message] = @Message
		WHERE pkID = @Id
	END
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogAssociatedAllList]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogAssociatedAllList]
(
	@Associations	dbo.StringParameterTable READONLY,
	@StartIndex			BIGINT = NULL,
	@MaxCount			INT = NULL
)
AS            
BEGIN
	DECLARE @Compare AS TABLE(String NVARCHAR(256), CompareString NVARCHAR(257), StringLen INT)
	INSERT INTO @Compare SELECT String, String + '%', LEN(String) FROM (SELECT String = CASE RIGHT(String, 1) WHEN '/' THEN LEFT(String,LEN(String) - 1) ELSE String END FROM @Associations WHERE String IS NOT NULL) X

	DECLARE @MatchAllCount INT = (SELECT COUNT(*) FROM @Compare)

	DECLARE @Ids AS TABLE([ID] [bigint] NOT NULL)
	
	INSERT INTO @Ids
	SELECT pkID FROM (
		SELECT pkID, [From] AS Value, StringLen
			FROM [tblActivityLog]
			JOIN tblActivityLogAssociation ON pkID = [To]
			JOIN @Compare ON [From] LIKE CompareString
			WHERE Deleted = 0
		UNION 
		SELECT pkID, RelatedItem AS Value, StringLen
			FROM [tblActivityLog]
			JOIN @Compare ON RelatedItem LIKE CompareString
			WHERE Deleted = 0
	) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	GROUP BY pkID
	HAVING COUNT(pkID) = @MatchAllCount

	DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)

	SELECT TOP(@MaxCount) [pkID], [Action], [Type], [ChangeDate], [ChangedBy], [LogData], [RelatedItem], [Deleted], @TotalCount AS 'TotalCount'
	FROM [tblActivityLog] al
	JOIN @Ids ids ON al.[pkID] = ids.[ID]
	WHERE [pkID] <= @StartIndex
	ORDER BY [pkID] DESC
END
GO
PRINT N'Creating Procedure [dbo].[netCreatePath]...';


GO
CREATE PROCEDURE dbo.netCreatePath
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RootPage INT

	UPDATE tblPage SET PagePath=''
	SELECT @RootPage=pkID FROM tblPage WHERE fkParentID IS NULL AND PagePath = ''
	UPDATE tblPage SET PagePath='.' WHERE pkID=@RootPage

	WHILE (1 = 1)
	BEGIN

		UPDATE CHILD SET CHILD.PagePath = PARENT.PagePath + CONVERT(VARCHAR, PARENT.pkID) + '.'
		FROM tblPage CHILD INNER JOIN tblPage PARENT ON CHILD.fkParentID = PARENT.pkID
		WHERE CHILD.PagePath = '' AND PARENT.PagePath <> ''

		IF (@@ROWCOUNT = 0)
			BREAK	

	END	

END
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessageList]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessageList]
	@Recipient NVARCHAR(255) = NULL,
	@Channel NVARCHAR(50) = NULL,
	@Category NVARCHAR(255) = NULL,
	@Read BIT = NULL,
	@Sent BIT = NULL,
	@StartIndex	INT,
	@MaxCount	INT
AS
BEGIN
	DECLARE @Ids AS TABLE([RowNr] [int] IDENTITY(0,1), [ID] [bigint] NOT NULL)

	INSERT INTO @Ids
	SELECT pkID
	FROM [tblNotificationMessage]
	WHERE
		((@Recipient IS NULL) OR (@Recipient = Recipient))
		AND
		((@Channel IS NULL) OR (@Channel = Channel))
		AND
		((@Category IS NULL) OR (Category LIKE @Category + '%'))
		AND
		(@Read IS NULL OR 
			((@Read = 1 AND [Read] IS NOT NULL) OR
			(@Read = 0 AND [Read] IS NULL)))
		AND
		(@Sent IS NULL OR 
			((@Sent = 1 AND [Sent] IS NOT NULL) OR
			(@Sent = 0 AND [Sent] IS NULL)))
	ORDER BY Saved DESC

	DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)
 
	SELECT TOP(@MaxCount) pkID AS ID, [Recipient], [Sender], [Channel], [Type], [Subject], [Content], [Sent], [SendAt], [Saved], [Read], [Category], @TotalCount AS 'TotalCount'
	FROM [tblNotificationMessage] nm
	JOIN @Ids ids ON nm.[pkID] = ids.[ID]
	WHERE ids.RowNr >= @StartIndex
	ORDER BY nm.[Saved] DESC, nm.[pkID] DESC
END
GO
PRINT N'Creating Procedure [dbo].[netPageLanguageSettingUpdate]...';


GO
CREATE PROCEDURE dbo.netPageLanguageSettingUpdate
(
	@PageID				INT,
	@LanguageBranch		NCHAR(17),
	@ReplacementBranch	NCHAR(17) = NULL,
	@LanguageBranchFallback NVARCHAR(1000) = NULL,
	@Active				BIT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @LangBranchID INT
	DECLARE @ReplacementBranchID INT

	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @LanguageBranch
	IF @LangBranchID IS NULL
	BEGIN
		RAISERROR('Language branch "%s" is not defined',16,1, @LanguageBranch)
		RETURN 0
	END

	IF NOT @ReplacementBranch IS NULL
	BEGIN
		SELECT @ReplacementBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @ReplacementBranch
		IF @ReplacementBranchID IS NULL
		BEGIN
			RAISERROR('Replacement language branch "%s" is not defined',16,1, @ReplacementBranch)
			RETURN 0
		END
	END
	
	IF EXISTS(SELECT * FROM tblPageLanguageSetting WHERE fkPageID=@PageID AND fkLanguageBranchID=@LangBranchID)
		UPDATE tblPageLanguageSetting SET
			fkReplacementBranchID	= @ReplacementBranchID,
			LanguageBranchFallback  = @LanguageBranchFallback,
			Active					= @Active
		WHERE fkPageID=@PageID AND fkLanguageBranchID=@LangBranchID

	ELSE
		INSERT INTO tblPageLanguageSetting(
				fkPageID,
				fkLanguageBranchID,
				fkReplacementBranchID,
				LanguageBranchFallback,
				Active)
		VALUES(
				@PageID, 
				@LangBranchID,
				@ReplacementBranchID,
				@LanguageBranchFallback,
				@Active
			)
		
	RETURN 0
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationEnqueueInt]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationEnqueueInt]
    @processorId uniqueidentifier,
    @items ChangeNotificationIntTable readonly
as
begin
    begin try
        begin transaction

        declare @processorStatus nvarchar(30)
        select @processorStatus = ProcessorStatus
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId

        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            declare @queueOrder int
            update tblChangeNotificationProcessor
            set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1, LastConsistentDbUtc = case when @processorStatus = 'valid' and NextQueueOrderValue = 0 then SYSUTCDATETIME() else LastConsistentDbUtc end
            where ProcessorId = @processorId

            -- insert values from @items, avoiding any values which are already in the queue and not in an outstanding batch.
            insert into tblChangeNotificationQueuedInt (ProcessorId, QueueOrder, ConnectionId, Value)
            select @processorId, @queueOrder, null, i.Value
            from @items i
            left outer join tblChangeNotificationQueuedInt q
                on q.ProcessorId = @processorId
                and q.ConnectionId is null
                and i.Value = q.Value
            where q.ProcessorId is null
        end

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationEnqueueGuid]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationEnqueueGuid]
    @processorId uniqueidentifier,
    @items ChangeNotificationGuidTable readonly
as
begin
    begin try
        begin transaction

        declare @processorStatus nvarchar(30)
        select @processorStatus = ProcessorStatus
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId

        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            declare @queueOrder int
            update tblChangeNotificationProcessor
            set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1, LastConsistentDbUtc = case when @processorStatus = 'valid' and NextQueueOrderValue = 0 then SYSUTCDATETIME() else LastConsistentDbUtc end
            where ProcessorId = @processorId

            -- insert values from @items, avoiding any values which are already in the queue and not in an outstanding batch.
            insert into tblChangeNotificationQueuedGuid (ProcessorId, QueueOrder, ConnectionId, Value)
            select @processorId, @queueOrder, null, i.Value
            from @items i
            left outer join tblChangeNotificationQueuedGuid q
                on q.ProcessorId = @processorId
                and q.ConnectionId is null
                and i.Value = q.Value
            where q.ProcessorId is null
        end

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentityForProvider]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentityForProvider]
	@Provider NVARCHAR(255),
    @Saved datetime2 = NULL
AS
BEGIN
	SET NOCOUNT ON;

    IF @Saved IS NULL
    BEGIN
	    SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider, MI.Metadata, MI.Saved
	    FROM tblMappedIdentity AS MI
	    WHERE MI.Provider = @Provider
    END
    ELSE
    BEGIN
        SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider, MI.Metadata, MI.Saved
	    FROM tblMappedIdentity AS MI
	    WHERE MI.Provider = @Provider AND MI.Saved > @Saved
    END
END
GO
PRINT N'Creating Procedure [dbo].[netPageLanguageSettingList]...';


GO
CREATE PROCEDURE dbo.netPageLanguageSettingList
@PageID INT
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT	fkPageID,
			RTRIM(Branch.LanguageID) as LanguageBranch,
			RTRIM(ReplacementBranch.LanguageID) as ReplacementBranch,
			LanguageBranchFallback,
			Active
	FROM tblPageLanguageSetting
	INNER JOIN tblLanguageBranch AS Branch ON Branch.pkID = tblPageLanguageSetting.fkLanguageBranchID
	LEFT JOIN tblLanguageBranch AS ReplacementBranch ON ReplacementBranch.pkID = tblPageLanguageSetting.fkReplacementBranchID
	WHERE fkPageID=@PageID
END
GO
PRINT N'Creating Procedure [dbo].[netFrameUpdate]...';


GO
CREATE PROCEDURE dbo.netFrameUpdate
(
	@FrameID			INT,
	@FrameName			NVARCHAR(100),
	@FrameDescription		NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON

	UPDATE 
		tblFrame 
	SET 
		FrameName='target="' + @FrameName + '"', 
		FrameDescription=@FrameDescription
	WHERE
		pkID=@FrameID

	RETURN 0
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalListByQuery]...';


GO
CREATE PROCEDURE [dbo].[netApprovalListByQuery](
	@StartIndex INT,
	@MaxCount INT,
	@Username NVARCHAR(255) = NULL,
	@Roles dbo.StringParameterTable READONLY,
	@StartedBy NVARCHAR(255) = NULL,
	@LanguageBranchID INT = NULL,
	@ApprovalKey NVARCHAR(255) = NULL,
	@DefinitionID INT = NULL,
	@DefinitionVersionID INT = NULL,
	@Status INT = NULL,
	@OnlyActiveSteps BIT = 0,
	@UserDecision BIT = NULL,
	@UserDecisionApproved BIT = NULL,
	@PrintQuery BIT = 0)
AS
BEGIN
	DECLARE @JoinApprovalDefinitionVersion BIT = 0
	DECLARE @JoinApprovalDefinitionReviewer BIT = 0
	DECLARE @JoinApprovalStepDecision BIT = 0

	DECLARE @InvariantLanguageBranchID INT = NULL

	DECLARE @Wheres AS TABLE([String] NVARCHAR(MAX))

	IF @LanguageBranchID IS NOT NULL 
	BEGIN
		SELECT @InvariantLanguageBranchID = [pkID] FROM [dbo].[tblLanguageBranch] WHERE LanguageID = ''
		IF @LanguageBranchID = @InvariantLanguageBranchID
			SET @LanguageBranchID = NULL
		ELSE 
			INSERT INTO @Wheres SELECT '[approval].fkLanguageBranchID IN (@LanguageBranchID, @InvariantLanguageBranchID)'	
	END

	IF @Status IS NOT NULL 
		INSERT INTO @Wheres SELECT '[approval].ApprovalStatus = @Status'

	IF @StartedBy IS NOT NULL 
		INSERT INTO @Wheres SELECT '[approval].StartedBy = @StartedBy'

	IF @DefinitionVersionID IS NOT NULL 
		INSERT INTO @Wheres SELECT '[approval].fkApprovalDefinitionVersionID = @DefinitionVersionID'

	IF @ApprovalKey IS NOT NULL 
		INSERT INTO @Wheres SELECT '[approval].ApprovalKey LIKE @ApprovalKey + ''%''' 

	IF @DefinitionID IS NOT NULL 
	BEGIN
		SET @JoinApprovalDefinitionVersion = 1
		INSERT INTO @Wheres SELECT '[version].fkApprovalDefinitionID = @DefinitionID'
	END

	DECLARE @DecisionComparison NVARCHAR(MAX) = ''
	IF @UserDecision IS NULL OR @UserDecision = 1 
	BEGIN
		SET @DecisionComparison
			= CASE WHEN @Username IS NOT NULL THEN 'AND [decision].Username = @Username ' ELSE '' END   
			+ CASE WHEN @OnlyActiveSteps = 1 THEN 'AND [approval].ActiveStepIndex = [decision].StepIndex ' ELSE '' END   
			+ CASE WHEN @UserDecisionApproved IS NOT NULL THEN 'AND [decision].Approve = @UserDecisionApproved ' ELSE '' END   
		IF @DecisionComparison != '' OR @UserDecision = 1 
		BEGIN
			SET @JoinApprovalStepDecision = 1
			SET @DecisionComparison = '[decision].pkID IS NOT NULL AND [decision].DecisionScope != 4 ' + @DecisionComparison 
		END
	END

	DECLARE @DeclarationComparison NVARCHAR(MAX) = ''
	DECLARE @RoleCount INT = (SELECT COUNT(*) FROM @Roles)
	IF (@Username IS NOT NULL OR @RoleCount > 0) AND (@UserDecision IS NULL OR @UserDecision = 0) 
	BEGIN
		SET @JoinApprovalDefinitionVersion = 1
		SET @JoinApprovalDefinitionReviewer = 1
		
		DECLARE @ReviewerConditionUser NVARCHAR(100) = '[reviewer].[ReviewerType] = 0 AND [reviewer].Username = @Username'
		DECLARE @ReviewerConditionRoles NVARCHAR(100) = CASE @RoleCount WHEN 0 THEN '' WHEN 1 THEN '[reviewer].[ReviewerType] = 1 AND [reviewer].Username = @Role' ELSE '[reviewer].[ReviewerType] = 1 AND [reviewer].Username IN (SELECT [String] FROM @Roles)' END
			
		IF @Username IS NULL
			SET @DeclarationComparison = @ReviewerConditionRoles
		ELSE IF @RoleCount = 0 
			SET @DeclarationComparison = @ReviewerConditionUser
		ELSE
			SET @DeclarationComparison = '((' + @ReviewerConditionUser + ') OR (' + @ReviewerConditionRoles + '))'
	
		SET @DeclarationComparison = @DeclarationComparison
			+ CASE WHEN @OnlyActiveSteps = 1 THEN ' AND [approval].ActiveStepIndex = [step].StepIndex' ELSE '' END   
			+ CASE WHEN @LanguageBranchID IS NOT NULL THEN ' AND (([approval].fkLanguageBranchID = @InvariantLanguageBranchID) OR ([reviewer].fkLanguageBranchID IN (@LanguageBranchID, @InvariantLanguageBranchID )))' ELSE '' END   
	END

	IF @DecisionComparison != '' AND @DeclarationComparison != ''
		INSERT INTO @Wheres SELECT '((' + @DecisionComparison + ') OR (' + @DeclarationComparison + '))'
	ELSE IF @DecisionComparison != ''
		INSERT INTO @Wheres SELECT @DecisionComparison
	ELSE IF @DeclarationComparison != ''
		INSERT INTO @Wheres SELECT @DeclarationComparison
	
	DECLARE @WhereSql NVARCHAR(MAX) 
	SELECT @WhereSql = COALESCE(@WhereSql + CHAR(13) + 'AND ', '') + [String] FROM @Wheres

	DECLARE @SelectSql NVARCHAR(MAX) = 'SELECT DISTINCT [approval].pkID, [approval].[Started] FROM [dbo].[tblApproval] [approval]' + CHAR(13)
		+ CASE WHEN @JoinApprovalDefinitionVersion = 1 THEN 'JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON [approval].fkApprovalDefinitionVersionID = [version].pkID' + CHAR(13) ELSE '' END   
		+ CASE WHEN @JoinApprovalDefinitionReviewer = 1 THEN 'JOIN [dbo].[tblApprovalDefinitionStep] [step] ON [step].fkApprovalDefinitionVersionID = [version].pkID' + CHAR(13) ELSE '' END   
		+ CASE WHEN @JoinApprovalDefinitionReviewer = 1 THEN 'JOIN [dbo].[tblApprovalDefinitionReviewer] [reviewer] ON [reviewer].fkApprovalDefinitionStepID = [step].pkID' + CHAR(13) ELSE '' END   
		+ CASE WHEN @JoinApprovalStepDecision = 1 THEN 'LEFT JOIN [dbo].[tblApprovalStepDecision] [decision] ON [approval].pkID = [decision].fkApprovalID' + CHAR(13) ELSE '' END   

	DECLARE @Sql NVARCHAR(MAX) = @SelectSql 
	IF @WhereSql IS NOT NULL
		SET @Sql += 'WHERE ' + @WhereSql + CHAR(13)

	SET @Sql += 'ORDER BY [Started] DESC'

	SET @Sql = '
DECLARE @Ids AS TABLE([RowNr] [INT] IDENTITY(0,1), [ID] [INT] NOT NULL, [Started] DATETIME2)

INSERT INTO @Ids
' + @Sql + '

DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)

SELECT TOP(@MaxCount) [approval].*, @TotalCount AS ''TotalCount''
FROM [dbo].[tblApproval] [approval]
JOIN @Ids ids ON [approval].[pkID] = ids.[ID]
WHERE ids.RowNr >= @StartIndex
ORDER BY [approval].[Started] DESC'

	IF @RoleCount = 1
		SET @Sql = CHAR(13) + 'DECLARE @Role NVARCHAR(255) = (SELECT [String] FROM @Roles)' + @Sql

	IF @PrintQuery = 1 
	BEGIN
		PRINT @Sql
	END ELSE BEGIN
		EXEC sp_executesql @Sql, 
			N'@Username NVARCHAR(255),@Roles dbo.StringParameterTable READONLY, @StartIndex INT, @MaxCount INT, @StartedBy NVARCHAR(255), @ApprovalKey NVARCHAR(255), @LanguageBranchID INT, @InvariantLanguageBranchID INT, @Status INT, @DefinitionVersionID INT, @DefinitionID INT, @UserDecisionApproved INT', 
			@Username = @Username, @Roles = @Roles, @StartIndex = @StartIndex, @MaxCount = @MaxCount, @StartedBy = @StartedBy, @ApprovalKey = @ApprovalKey, @LanguageBranchID = @LanguageBranchID, @InvariantLanguageBranchID = @InvariantLanguageBranchID, @Status = @Status, @DefinitionVersionID = @DefinitionVersionID, @DefinitionID = @DefinitionID, @UserDecisionApproved = @UserDecisionApproved
	END
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessagesSent]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessagesSent]
	@MessageIDs dbo.IDTable READONLY,
	@Sent DATETIME2
AS
BEGIN
	UPDATE M SET Sent = @Sent
	FROM [tblNotificationMessage] AS M INNER JOIN @MessageIDs AS IDS ON M.pkID = IDS.ID
END
GO
PRINT N'Creating Procedure [dbo].[EntityTypeGetIDByName]...';


GO
CREATE PROCEDURE dbo.EntityTypeGetIDByName
@strObjectType varchar(400)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intID int
	SELECT @intID = intID FROM dbo.tblEntityType WHERE strName = @strObjectType

	IF @intID IS NULL
	BEGIN
		INSERT INTO dbo.tblEntityType (strName) VALUES(@strObjectType)

		SET @intID = SCOPE_IDENTITY()
	END

	SELECT @intID
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogCommentListMany]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogCommentListMany]
(
	@EntryIds AS LongParameterTable READONLY
)
AS            
BEGIN
	SELECT alc.* FROM [tblActivityLogComment] alc
	JOIN @EntryIds ids ON alc.EntryId = ids.Id
	ORDER BY alc.pkID DESC
END
GO
PRINT N'Creating Procedure [dbo].[admDatabaseStatistics]...';


GO
CREATE PROCEDURE [dbo].[admDatabaseStatistics]
AS
BEGIN
	SET NOCOUNT ON
	SELECT
		(SELECT Count(*) FROM tblPage) AS PageCount
END
GO
PRINT N'Creating Procedure [dbo].[netFindContentCoreDataByContentGuidBatch]...';


GO
CREATE PROCEDURE [dbo].[netFindContentCoreDataByContentGuidBatch]
	@ContentGuids AS GuidParameterTable READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

        --- *** use NOLOCK since this may be called during page save if debugging. The code should not be written so this happens, it's to make it work in the debugger ***
	SELECT P.pkID as ID, P.fkContentTypeID as ContentTypeID, P.fkParentID as ParentID, P.ContentGUID, PL.LinkURL, P.Deleted, CASE WHEN Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PendingPublish, PL.Created, PL.Changed, PL.Saved, PL.StartPublish, PL.StopPublish, P.ContentAssetsID, P.fkMasterLanguageBranchID as MasterLanguageBranchID, PL.ContentLinkGUID as ContentLinkID, PL.AutomaticLink, PL.FetchData, P.ContentType
	FROM tblContent AS P WITH (NOLOCK)
    INNER JOIN @ContentGuids as ParamGuids on P.ContentGUID = ParamGuids.Id	
	LEFT JOIN tblContentLanguage AS PL ON PL.fkContentID=P.pkID
	WHERE P.fkMasterLanguageBranchID=PL.fkLanguageBranchID OR P.fkMasterLanguageBranchID IS NULL
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationAccessConnectionWorker]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationAccessConnectionWorker]
    @connectionId uniqueidentifier,
    @expectedChangeNotificationDataType nvarchar(30) = null
as
begin
    declare @processorId uniqueidentifier
    declare @queuedDataType nvarchar(30)
    declare @processorStatus nvarchar(30)
    declare @nextQueueOrderValue int
    declare @lastConsistentDbUtc datetime2
    declare @isOpen bit

    select @processorId = p.ProcessorId, @queuedDataType = p.ChangeNotificationDataType, @processorStatus = p.ProcessorStatus, @nextQueueOrderValue = p.NextQueueOrderValue, @lastConsistentDbUtc = p.LastConsistentDbUtc, @isOpen = c.IsOpen
    from tblChangeNotificationProcessor p
    join tblChangeNotificationConnection c on p.ProcessorId = c.ProcessorId
    where c.ConnectionId = @connectionId

    if (@processorId is null)
    begin
        set @processorStatus = 'closed'
    end
    else if (@expectedChangeNotificationDataType is not null and @expectedChangeNotificationDataType != @queuedDataType)
    begin
        set @processorStatus = 'type_mismatch'
    end
    else if (@processorStatus = 'invalid' or @isOpen = 1)
    begin
        -- the queue is invalid, or the current connection is valid.
        -- all pending connection requests may be considered open.
        update tblChangeNotificationConnection
        set IsOpen = 1
        where ProcessorId = @processorId and IsOpen = 0

        if (@processorStatus = 'valid' and @nextQueueOrderValue = 0)
        begin
            set @lastConsistentDbUtc = SYSUTCDATETIME()
        end
    end
    else if (@isOpen = 0 and @processorStatus != 'invalid')
    begin
        set @processorStatus = 'opening'
    end

    update tblChangeNotificationConnection
    set LastActivityDbUtc = SYSUTCDATETIME()
    where ConnectionId = @connectionId

    select @processorId as ProcessorId,  @processorStatus as ProcessorStatus, @lastConsistentDbUtc
end
GO
PRINT N'Creating Procedure [dbo].[BigTableDeleteItemInternal]...';


GO
CREATE PROCEDURE [dbo].[BigTableDeleteItemInternal]
@TVP BigTableDeleteItemInternalTable READONLY,
@forceDelete bit = 0
AS
BEGIN
	DECLARE @deletes AS BigTableDeleteItemInternalTable
	INSERT INTO @deletes SELECT * FROM @TVP

	DECLARE @nestLevel int
	SET @nestLevel = 1
	WHILE @@ROWCOUNT > 0
	BEGIN
		SET @nestLevel = @nestLevel + 1
		-- insert all items contained in the ones matching the _previous_ nestlevel and give them _this_ nestLevel
		-- exclude those items that are also referred by some other item not already in @deletes
		-- IMPORTANT: Make sure that this insert is the last statement that can affect @@ROWCOUNT in the while-loop
		INSERT INTO @deletes(Id, NestLevel, ObjectPath)
		SELECT DISTINCT RefIdValue, @nestLevel, deletes.ObjectPath + '/' + CAST(RefIdValue AS VARCHAR) + '/'
		FROM tblBigTableReference R1
		INNER JOIN @deletes deletes ON deletes.Id=R1.pkId
		WHERE deletes.NestLevel=@nestLevel-1
		AND RefIdValue NOT IN(SELECT Id FROM @deletes)
	END 
	DELETE @deletes FROM @deletes deletes
	INNER JOIN 
	(
		SELECT innerDelete.Id
		FROM @deletes as innerDelete
		INNER JOIN tblBigTableReference ON tblBigTableReference.RefIdValue=innerDelete.Id
		WHERE NOT EXISTS(SELECT * FROM @deletes deletes WHERE deletes.Id=tblBigTableReference.pkId)
	) ReferencedObjects ON deletes.ObjectPath LIKE '%/' + CAST(ReferencedObjects.Id AS VARCHAR) + '/%'
	WHERE @forceDelete = 0 OR deletes.NestLevel > 1

	-- Go through each big table and create sql to delete any rows associated with the item being deleted
	DECLARE @sql NVARCHAR(MAX) = ''
	DECLARE @tableName NVARCHAR(128)
	DECLARE tableNameCursor CURSOR READ_ONLY 
	
	FOR SELECT DISTINCT TableName FROM tblBigTableStoreConfig WHERE TableName IS NOT NULL				
	OPEN tableNameCursor
	FETCH NEXT FROM tableNameCursor INTO @tableName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = @sql + 'DELETE t1 FROM ' + @tableName  +  ' t1 JOIN @deletes t2 ON t1.pkId = t2.Id;' + CHAR(13)
		FETCH NEXT FROM tableNameCursor INTO @tableName
	END
	CLOSE tableNameCursor
	DEALLOCATE tableNameCursor 			

	BEGIN TRAN
    DELETE t1 FROM tblBigTableReference t1 JOIN @deletes t2 ON t1.RefIdValue = t2.Id
    DELETE t1 FROM tblBigTableReference t1 JOIN @deletes t2 ON t1.pkId = t2.Id
    EXEC sp_executesql @sql, N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
    DELETE t1 FROM tblBigTableIdentity t1 JOIN @deletes t2 ON t1.pkId = t2.Id	 
	COMMIT TRAN
END
GO
PRINT N'Creating Procedure [dbo].[BigTableDeleteAll]...';


GO
CREATE PROCEDURE [dbo].[BigTableDeleteAll]
@ViewName nvarchar(4000)
AS
BEGIN
	DECLARE @deletes AS BigTableDeleteItemInternalTable;
	INSERT INTO @deletes(Id, NestLevel, ObjectPath)
	EXEC ('SELECT [StoreId], 1, ''/'' + CAST([StoreId] AS VARCHAR) + ''/'' FROM ' + @ViewName)

	EXEC sp_executesql N'BigTableDeleteItemInternal @deletes, 1', N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogAssociatedList]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogAssociatedList]
(
	@MatchAll			dbo.StringParameterTable READONLY,
	@MatchAny			dbo.StringParameterTable READONLY,
	@StartIndex			BIGINT = NULL,
	@MaxCount			INT = NULL
)
AS            
BEGIN
	DECLARE @CompareMatchAll AS TABLE(String NVARCHAR(256), CompareString NVARCHAR(257), StringLen INT)
	INSERT INTO @CompareMatchAll SELECT String, String + '%', LEN(String) FROM (SELECT String = CASE RIGHT(String, 1) WHEN '/' THEN LEFT(String,LEN(String) - 1) ELSE String END FROM @MatchAll WHERE String IS NOT NULL) X

	DECLARE @CompareMatchAny AS TABLE(String NVARCHAR(256), CompareString NVARCHAR(257), StringLen INT)
	INSERT INTO @CompareMatchAny SELECT String, String + '%', LEN(String) FROM (SELECT String = CASE RIGHT(String, 1) WHEN '/' THEN LEFT(String,LEN(String) - 1) ELSE String END FROM @MatchAny WHERE String IS NOT NULL) X

	DECLARE @MatchAllCount INT = (SELECT COUNT(*) FROM @CompareMatchAll)

	DECLARE @IdsAll AS TABLE([ID] [bigint] NOT NULL)

	INSERT INTO @IdsAll
	SELECT pkID	FROM (
		SELECT pkID, [From] AS Value, StringLen
			FROM [tblActivityLog]
			JOIN tblActivityLogAssociation ON pkID = [To]
			JOIN @CompareMatchAll ON [From] LIKE CompareString
			WHERE Deleted = 0
		UNION 
		SELECT pkID, RelatedItem AS Value, StringLen
			FROM [tblActivityLog]
			JOIN @CompareMatchAll ON RelatedItem LIKE CompareString
			WHERE Deleted = 0
	) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	GROUP BY pkID
	HAVING COUNT(pkID) = @MatchAllCount

	DECLARE @Ids AS TABLE([ID] [bigint] NOT NULL)

	INSERT INTO @Ids
		SELECT pkID FROM (
			SELECT pkID, [From] AS Value, StringLen
			FROM @IdsAll ids
			JOIN [tblActivityLog] ON pkID = ids.ID
			JOIN tblActivityLogAssociation ON pkID = [To]
			JOIN @CompareMatchAny ON [From] LIKE CompareString
			WHERE Deleted = 0
		) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	UNION
		SELECT pkID FROM (
			SELECT pkID, RelatedItem AS Value, StringLen
			FROM @IdsAll ids
			JOIN [tblActivityLog] ON pkID = ids.ID
			JOIN @CompareMatchAny ON RelatedItem LIKE CompareString
			WHERE Deleted = 0
		) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'

	DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)

	SELECT TOP(@MaxCount) [pkID], [Action], [Type], [ChangeDate], [ChangedBy], [LogData], [RelatedItem], [Deleted], @TotalCount AS 'TotalCount'
	FROM [tblActivityLog] al
	JOIN @Ids ids ON al.[pkID] = ids.[ID]
	WHERE [pkID] <= @StartIndex
	ORDER BY [pkID] DESC
END
GO
PRINT N'Creating Procedure [dbo].[netActvitiyLogList]...';


GO
CREATE PROCEDURE [dbo].[netActvitiyLogList]
(
	@from 	                 DATETIME2 = NULL,
	@to	                     DATETIME2 = NULL,
	@type 					 [nvarchar](255) = NULL,
	@action 				 INT = NULL,
	@changedBy				 [nvarchar](255) = NULL,
	@startSequence			 BIGINT = NULL,
	@maxRows				 BIGINT,
	@archived				 BIT = 0,
	@deleted				 BIT = 0,
	@order					 INT = 0
)
AS
BEGIN
	DECLARE @paramList NVARCHAR(4000)
	DECLARE @sql NVARCHAR(MAX) 

	SET @sql = 'SELECT TOP(@maxRows) [pkID], [LogData], [ChangeDate], [Type], [Action], [ChangedBy], [Deleted]'

	IF @archived = 0
		SET @sql += ', [RelatedItem] FROM dbo.[tblActivityLog]' + CHAR(13);
	ELSE
		SET @sql += ', '''' AS [RelatedItem] FROM [completeActivityLog]' + CHAR(13);

	-- WHERE
	SET @sql += 'WHERE 1=1';

	IF @startSequence IS NOT NULL
		SET @sql += ' AND pkID ' + CASE @order WHEN 0 THEN '<=' ELSE '>=' END + ' @startSequence'

	IF @from IS NOT NULL
		SET @sql += ' AND [ChangeDate] >= @from'

	IF @to IS NOT NULL
		SET @sql += ' AND [ChangeDate] <= @to'

	IF @type IS NOT NULL
		SET @sql += ' AND [Type] = @type'

	IF @action IS NOT NULL
		SET @sql += ' AND [Action] = @action'

	IF @changedBy IS NOT NULL
		SET @sql += ' AND [ChangedBy] = @changedBy'

	IF @deleted = 0
		SET @sql += ' AND [Deleted] = 0'

	-- ORDER BY
	SET @sql += CHAR(13) + 'ORDER BY pkID ' + CASE @order WHEN 0 THEN 'DESC' ELSE 'ASC' END

	SET @paramList = '@from 	        DATETIME2,
					  @to				DATETIME2,
					  @type 			NVARCHAR(255),
					  @action 			INT,
					  @changedBy		NVARCHAR(255),
					  @startSequence	BIGINT,
					  @maxRows			BIGINT,
					  @deleted			BIT'

	EXEC sp_executesql @sql, @paramList, @from, @to, @type, @action, @changedBy, @startSequence, @maxRows, @deleted

END
GO
PRINT N'Creating Procedure [dbo].[sp_DatabaseVersion]...';


GO

CREATE PROCEDURE [dbo].[sp_DatabaseVersion]
AS
    RETURN 21001
GO
PRINT N'Creating Procedure [dbo].[netActivityLogCommentDelete]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogCommentDelete]
(
	@Id  BIGINT
)
AS            
BEGIN
	DELETE FROM [tblActivityLogComment] WHERE [pkID] = @Id
END
GO
PRINT N'Creating Procedure [dbo].[netFrameInsert]...';


GO
CREATE PROCEDURE dbo.netFrameInsert
(
	@FrameID		INTEGER OUTPUT,
	@FrameName		NVARCHAR(100),
	@FrameDescription	NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO tblFrame
		(FrameName,
		FrameDescription)
	VALUES
		('target="' + @FrameName + '"', 
		@FrameDescription)

	SET @FrameID =  SCOPE_IDENTITY() 

	RETURN 0
END
GO
PRINT N'Creating Procedure [dbo].[sp_FxDatabaseVersion]...';


GO
CREATE PROCEDURE dbo.sp_FxDatabaseVersion
AS
	RETURN 7000 --Note used since 7.5.500
GO
PRINT N'Creating Procedure [dbo].[netSiteDefinitionSave]...';


GO
CREATE PROCEDURE [dbo].[netSiteDefinitionSave]
(
	@UniqueId uniqueidentifier = NULL OUTPUT,
	@Name nvarchar(255),
	@SiteUrl varchar(MAX),
	@StartPage varchar(255),
	@SiteAssetsRoot varchar(255) = NULL,
	@Hosts dbo.HostDefinitionTable READONLY,
    @UserName nvarchar(255),
	@Saved datetime2
)
AS
BEGIN
	DECLARE @SiteID int
	
	IF (@UniqueId IS NULL OR @UniqueId = CAST(0x0 AS uniqueidentifier))
		SET @UniqueId = NEWID()
	ELSE -- If UniqueId is set we must first check if it has been saved before
		SELECT @SiteID = pkID FROM tblSiteDefinition WHERE UniqueId = @UniqueId

	IF (@SiteID IS NULL) 
	BEGIN
		INSERT INTO tblSiteDefinition 
		(
			UniqueId,
			Name,
			SiteUrl,
			StartPage,
			SiteAssetsRoot,
            SavedBy,
            Saved
		) 
		VALUES
		(
			@UniqueId,
			@Name,
			@SiteUrl,
			@StartPage,
			@SiteAssetsRoot,
            @UserName,
            @Saved
		)
		SET @SiteID = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE tblSiteDefinition SET 
			UniqueId=@UniqueId,
			Name = @Name,
			SiteUrl = @SiteUrl,
			StartPage = @StartPage,
			SiteAssetsRoot = @SiteAssetsRoot,
            SavedBy = @UserName,
            Saved = @Saved
		WHERE 
			pkID = @SiteID
		
	END

	-- Site hosts
	MERGE tblHostDefinition AS Target
    USING @Hosts AS Source
    ON (Target.Name = Source.Name AND Target.fkSiteID=@SiteID)
    WHEN MATCHED THEN 
        UPDATE SET fkSiteID = @SiteID, Name = Source.Name, Type = Source.Type, Language = Source.Language, Https = Source.Https
	WHEN NOT MATCHED BY Source AND Target.fkSiteID = @SiteID THEN
		DELETE
	WHEN NOT MATCHED BY Target THEN
		INSERT (fkSiteID, Name, Type, Language, Https)
		VALUES (@SiteID, Source.Name, Source.Type, Source.Language, Source.Https);

END
GO
PRINT N'Creating Procedure [dbo].[netContentAclChildDelete]...';


GO
CREATE PROCEDURE dbo.netContentAclChildDelete
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID	INT
)
AS
BEGIN
    SET NOCOUNT ON
 
    IF (@Name IS NULL)
    BEGIN
        DELETE FROM 
           tblContentAccess
        WHERE EXISTS(SELECT * FROM tblTree WHERE fkParentID=@ContentID AND fkChildID=tblContentAccess.fkContentID)
            
        RETURN
    END

    DELETE FROM 
       tblContentAccess
    WHERE Name=@Name
		AND IsRole=@IsRole
		AND EXISTS(SELECT * FROM tblTree WHERE fkParentID=@ContentID AND fkChildID=tblContentAccess.fkContentID)
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogCommentList]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogCommentList]
(
	@EntryId	[bigint]
)

AS            
BEGIN
	SELECT * FROM [tblActivityLogComment]
		WHERE [EntryId] = @EntryId
	ORDER BY pkID DESC
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationDequeueString]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationDequeueString]
    @connectionId uniqueidentifier,
    @maxItems int
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'String'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        if (@processorStatus = 'valid')
        begin
            if exists (select 1 from tblChangeNotificationQueuedString where ConnectionId = @connectionId)
            begin
                raiserror('A batch is already pending for the specified queue connection.', 16, 1)
            end

            declare @result table (Value nvarchar(450) collate Latin1_General_BIN2)

            insert into @result (Value)
            select top (@maxItems) Value
            from tblChangeNotificationQueuedString
			where ProcessorId = @processorId
			  and ConnectionId is null
			order by QueueOrder

            update tblChangeNotificationQueuedString
            set ConnectionId = @connectionId
            where ProcessorId = @processorId
              and Value in (select Value from @result)

            select Value from @result
        end

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netBlobPendingDeleteList]...';


GO
CREATE PROCEDURE [dbo].[netBlobPendingDeleteList]
    @MaxCount INT = 500
AS
BEGIN
	SELECT TOP(@MaxCount) pkID, BlobUri, fkContentId AS ContentId, Provider FROM tblBlobPendingDelete
END
GO
PRINT N'Creating Procedure [dbo].[DateTimeConversion_GetFieldNames]...';


GO
CREATE PROCEDURE [dbo].[DateTimeConversion_GetFieldNames]
AS 
BEGIN 
	SELECT '** TABLENAME **','** DATETIME COLUMNNAME (OPTIONAL) **', '** STORENAME (OPTIONAL) **'

	-- TABLES
	UNION SELECT 'tblContent', NULL, NULL
	UNION SELECT 'tblContentLanguage', NULL, NULL
	UNION SELECT 'tblContentProperty', NULL, NULL
	UNION SELECT 'tblContentSoftlink', NULL, NULL
	UNION SELECT 'tblContentType', NULL, NULL
	UNION SELECT 'tblPlugIn', NULL, NULL
	UNION SELECT 'tblProject', NULL, NULL
	UNION SELECT 'tblPropertyDefinitionDefault', 'Date', NULL
	UNION SELECT 'tblTask', NULL, NULL
	UNION SELECT 'tblWorkContent', NULL, NULL
	UNION SELECT 'tblWorkContentProperty', NULL, NULL
	UNION SELECT 'tblXFormData', 'DatePosted', NULL

	-- STORES
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Personalization.VisitorGroups.Criteria.ViewedCategoriesModel'
	UNION SELECT 'tblIndexRequestLog', NULL, 'EPiServer.Search.Data.IndexRequestQueueItem'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiContentRestoreStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.ApplicationModules.Security.SiteSecret'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Core.PropertySettings.PropertySettingsContainer'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Core.PropertySettings.PropertySettingsGlobals'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Core.PropertySettings.PropertySettingsWrapper'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Editor.TinyMCE.TinyMCESettings'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Editor.TinyMCE.ToolbarRow'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Licensing.StoredLicense'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.MirroringService.MirroringData'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Shell.Profile.ProfileData'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Shell.Storage.PersonalizedViewSettingsStorage'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Util.BlobCleanupJobState'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Util.ContentAssetsCleanupJobState'
	UNION SELECT 'tblSystemBigTable', NULL, 'GadgetStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'VisitorGroup'
	UNION SELECT 'tblSystemBigTable', NULL, 'VisitorGroupCriterion'
	UNION SELECT 'tblSystemBigTable', NULL, 'XFormFolders'

	-- OBSOLETE STORES
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Web.HostDefinition'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Web.SiteDefinition'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardContainerStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardLayoutPartStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardTabLayoutStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'DashboardTabStore'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Events.Remote.EventSecret'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.Licensing.SiteLicenseData'
	UNION SELECT 'tblSystemBigTable', NULL, 'EPiServer.TaskManager.TaskManagerDynamicData'
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Core.IndexingInformation'
	UNION SELECT 'tblBigTable', NULL, 'EPiServer.Shell.Search.SearchProviderSetting'
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogCommentLoad]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogCommentLoad]
(
	@Id	[bigint]
)

AS            
BEGIN
	SELECT * FROM [tblActivityLogComment]
		WHERE pkID = @Id
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogTruncate]...';


GO

CREATE PROCEDURE [dbo].[netActivityLogTruncate]
(
	@Archive BIT,
	@MaxRows BIGINT,
	@BeforeEntry BIGINT = NULL,
	@CreatedBefore DATETIME2 = NULL,
	@PreservedRelation NVARCHAR(255) = NULL
)
AS
BEGIN
	DECLARE @paramList NVARCHAR(4000)
	DECLARE @sql NVARCHAR(MAX) 
	DECLARE @PreservedRelationLike NVARCHAR(256) = @PreservedRelation

	SET @sql = 'DELETE TOP(@MaxRows) L'

	IF (@Archive != 0)
		SET @sql += ' OUTPUT DELETED.[pkID], DELETED.[LogData], DELETED.[ChangeDate], DELETED.[Type], DELETED.[Action], DELETED.[ChangedBy], DELETED.Deleted
				INTO [dbo].[tblActivityArchive]([pkID], [LogData], [ChangeDate], [Type], [Action], [ChangedBy], [Deleted])'

	SET @sql += ' FROM [dbo].[tblActivityLog] AS L'

	IF (@PreservedRelation IS NOT NULL)
		SET @sql += ' LEFT OUTER JOIN [dbo].[tblActivityLogAssociation] AS A ON L.pkID = A.[To]'

	SET @sql += ' WHERE 1=1'

	IF (@BeforeEntry IS NOT NULL)
		SET @sql += ' AND L.[pkID] < @BeforeEntry'

	IF (@CreatedBefore IS NOT NULL)
		SET @sql += ' AND L.[ChangeDate] < @CreatedBefore'

	IF (@PreservedRelation IS NOT NULL)
	BEGIN
		SET @PreservedRelationLike += '%'
		SET @sql += ' AND ((A.[From] IS NULL OR A.[From] NOT LIKE @PreservedRelationLike) AND (L.RelatedItem IS NULL OR L.RelatedItem NOT LIKE @PreservedRelationLike))'
	END

	SET @paramList = '@MaxRows BIGINT,
                      @BeforeEntry BIGINT,
	                  @CreatedBefore DATETIME2,
                      @PreservedRelationLike NVARCHAR(255)'

	EXEC sp_executesql @sql, @paramList, @MaxRows, @BeforeEntry, @CreatedBefore, @PreservedRelationLike

	RETURN @@ROWCOUNT
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalList]...';


GO
CREATE PROCEDURE [dbo].[netApprovalList](
	@ApprovalIDs [dbo].[IDTable] READONLY)
AS
BEGIN
	SELECT approval.* FROM [dbo].[tblApproval] approval 
	JOIN @ApprovalIDs ids ON approval.pkID = ids.ID
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationSetInvalidWorker]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationSetInvalidWorker]
    @processorId uniqueidentifier,
    @inactiveConnectionTimeoutSeconds int
as
begin
    delete from tblChangeNotificationQueuedInt where ProcessorId = @processorId
    delete from tblChangeNotificationQueuedGuid where ProcessorId = @processorId
    delete from tblChangeNotificationQueuedString where ProcessorId = @processorId

    update tblChangeNotificationProcessor
    set ProcessorStatus = 'invalid', NextQueueOrderValue = 0, LastConsistentDbUtc = null
    where ProcessorId = @processorId

    delete from tblChangeNotificationConnection
    where ProcessorId = @processorId and LastActivityDbUtc < DATEADD(second, -@inactiveConnectionTimeoutSeconds, SYSUTCDATETIME())

    update tblChangeNotificationConnection
    set IsOpen = 1
    where ProcessorId = @processorId and IsOpen = 0
end
GO
PRINT N'Creating Procedure [dbo].[EntityGetIdByGuidFromIdentity]...';


GO
CREATE PROCEDURE dbo.EntityGetIdByGuidFromIdentity
@uniqueID uniqueidentifier
AS
BEGIN
	SELECT tblBigTableStoreConfig.EntityTypeId as EntityTypeId, tblBigTableIdentity.pkId as ObjectId  
		FROM tblBigTableIdentity INNER JOIN tblBigTableStoreConfig 
		ON tblBigTableIdentity.StoreName = tblBigTableStoreConfig.StoreName
		WHERE tblBigTableIdentity.Guid = @uniqueID
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationGetStatus]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationGetStatus]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @lastConsistentDbUtc datetime2
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus, @lastConsistentDbUtc = LastConsistentDbUtc
        from @processorStatusTable

        declare @queuedDataType nvarchar(30)
        select @queuedDataType = ChangeNotificationDataType
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId

        declare @queuedItemCount int
        if (@processorStatus = 'closed')
        begin
            set @queuedItemCount = 0
        end
        else if (@queuedDataType = 'Int')
        begin
            select @queuedItemCount = COUNT(*)
            from tblChangeNotificationQueuedInt
            where ProcessorId = @processorId and ConnectionId is null
        end
        else if (@queuedDataType = 'Guid')
        begin
            select @queuedItemCount = COUNT(*)
            from tblChangeNotificationQueuedGuid
            where ProcessorId = @processorId and ConnectionId is null
        end
        else if (@queuedDataType = 'String')
        begin
            select @queuedItemCount = COUNT(*)
            from tblChangeNotificationQueuedString
            where ProcessorId = @processorId and ConnectionId is null
        end

        select
            @processorStatus as ProcessorStatus,
            @queuedItemCount as QueuedItemCount,
            case when @processorStatus = 'valid' and @queuedItemCount = 0 then SYSUTCDATETIME() else @lastConsistentDbUtc end as LastConsistentDbUtc

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netApprovalDefinitionVersionGet]...';


GO
CREATE PROCEDURE [dbo].[netApprovalDefinitionVersionGet](
	@ApprovalDefinitionVersionID INT)
AS
BEGIN
	SELECT [definition].* FROM [dbo].[tblApprovalDefinition] [definition] 
	JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON [definition].pkID = [version].fkApprovalDefinitionID
	WHERE [version].pkID = @ApprovalDefinitionVersionID
	
	SELECT * FROM [dbo].[tblApprovalDefinitionVersion] WHERE pkID = @ApprovalDefinitionVersionID

	SELECT * FROM [dbo].[tblApprovalDefinitionStep] WHERE fkApprovalDefinitionVersionID = @ApprovalDefinitionVersionID ORDER BY StepIndex ASC

	SELECT * FROM [dbo].[tblApprovalDefinitionReviewer] WHERE fkApprovalDefinitionVersionID = @ApprovalDefinitionVersionID
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogAssociationSave]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogAssociationSave]
(
	@AssociatedItem	[nvarchar](255),
	@ChangeLogID  BIGINT
)


AS            
BEGIN
	INSERT INTO [tblActivityLogAssociation] VALUES(@AssociatedItem, @ChangeLogID)
END
GO
PRINT N'Creating Procedure [dbo].[netPermissionDeleteMembership]...';


GO
CREATE PROCEDURE [dbo].[netPermissionDeleteMembership]
(
	@Name	NVARCHAR(255) = NULL,
	@IsRole int = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	IF(@Name IS NOT NULL AND @IsRole IS NOT NULL)
	BEGIN
		DELETE
		FROM
			tblUserPermission
		WHERE
			Name=@Name 
			AND 
			IsRole=@IsRole
    END
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogTruncateArchive]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogTruncateArchive]
(
	@MaxRows BIGINT,
	@CreatedBefore DATETIME2
)
AS
BEGIN	

	DELETE TOP(@MaxRows) 
	FROM [tblActivityArchive] 
	WHERE ChangeDate < @CreatedBefore

	RETURN @@ROWCOUNT
END
GO
PRINT N'Creating Procedure [dbo].[netPageChangeMasterLanguage]...';


GO
CREATE PROCEDURE [dbo].[netPageChangeMasterLanguage]
(
	@PageID						INT,
	@NewMasterLanguageBranchID	INT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @OldMasterLanguageBranchID INT;
	DECLARE @LastNewMasterLanguageVersion INT;
	DECLARE @LastOldMasterLanguageVersion INT;
	SET @OldMasterLanguageBranchID = (SELECT fkMasterLanguageBranchID FROM tblPage WHERE pkID = @PageID);

	IF(@NewMasterLanguageBranchID = @OldMasterLanguageBranchID)
		RETURN -1;

	SET @LastNewMasterLanguageVersion = (SELECT [Version] FROM tblPageLanguage WHERE fkPageID = @PageID AND fkLanguageBranchID = @NewMasterLanguageBranchID AND PendingPublish = 0)
	IF (@LastNewMasterLanguageVersion IS NULL)
		RETURN -1;
	SET @LastOldMasterLanguageVersion = (SELECT PublishedVersion FROM tblPage WHERE pkID = @PageID)
	IF (@LastOldMasterLanguageVersion IS NULL)
		RETURN -1
	
	--Do the actual change of master language branch
	UPDATE
		tblPage
	SET
		tblPage.fkMasterLanguageBranchID = @NewMasterLanguageBranchID
	WHERE
		pkID = @PageID

	--Update tblProperty for common properties
	UPDATE
		tblProperty
	SET
		fkLanguageBranchID = @NewMasterLanguageBranchID
	FROM
		tblProperty
	INNER JOIN
		tblPageDefinition
	ON
		tblProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		LanguageSpecific < 3
	AND
		fkPageID = @PageID

	--Update tblCategoryPage for builtin and common categories
	UPDATE
		tblCategoryPage
	SET
		fkLanguageBranchID = @NewMasterLanguageBranchID
	FROM
		tblCategoryPage
	LEFT JOIN
		tblPageDefinition
	ON
		tblCategoryPage.CategoryType = tblPageDefinition.pkID
	WHERE
		(LanguageSpecific < 3
	OR
		LanguageSpecific IS NULL)
	AND
		fkPageID = @PageID

	--Move work categories and properties between the last versions of the languages
	UPDATE
		tblWorkProperty
	SET
		fkWorkPageID = @LastNewMasterLanguageVersion
	FROM
		tblWorkProperty
	INNER JOIN
		tblPageDefinition
	ON
		tblWorkProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		LanguageSpecific < 3
	AND
		fkWorkPageID = @LastOldMasterLanguageVersion

	UPDATE
		tblWorkCategory
	SET
		fkWorkPageID = @LastNewMasterLanguageVersion
	FROM
		tblWorkCategory
	LEFT JOIN
		tblPageDefinition
	ON
		tblWorkCategory.CategoryType = tblPageDefinition.pkID
	WHERE
		(LanguageSpecific < 3
	OR
		LanguageSpecific IS NULL)
	AND
		fkWorkPageID = @LastOldMasterLanguageVersion


	--Remove any remaining common properties for old master language versions
	DELETE FROM
		tblWorkProperty
	FROM
		tblWorkProperty
	INNER JOIN
		tblPageDefinition
	ON
		tblWorkProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		LanguageSpecific < 3
	AND
		fkWorkPageID IN (SELECT pkID FROM tblWorkPage WHERE fkPageID = @PageID AND fkLanguageBranchID = @OldMasterLanguageBranchID)

	--Remove any remaining common categories for old master language versions
	DELETE FROM
		tblWorkCategory
	FROM
		tblWorkCategory
	LEFT JOIN
		tblPageDefinition
	ON
		tblWorkCategory.CategoryType = tblPageDefinition.pkID
	WHERE
		(LanguageSpecific < 3
	OR
		LanguageSpecific IS NULL)
	AND
		fkWorkPageID IN (SELECT pkID FROM tblWorkPage WHERE fkPageID = @PageID AND fkLanguageBranchID = @OldMasterLanguageBranchID)

	RETURN 0
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationTrySetValid]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationTrySetValid]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        declare @result bit

        if (@processorStatus = 'recovering')
        begin
            update tblChangeNotificationProcessor
            set ProcessorStatus = 'valid'
            where ProcessorId = @processorId

            set @result = 1
        end
        else
        begin
            set @result = 0
        end

        commit transaction

        select @result as StateChanged
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netNotificationSubscriptionClearUser]...';


GO
CREATE PROCEDURE [dbo].[netNotificationSubscriptionClearUser]
	@UserName [nvarchar](255)
AS
BEGIN
	DELETE FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName
END
GO
PRINT N'Creating Procedure [dbo].[DateTimeConversion_RunBlocks]...';


GO
CREATE PROCEDURE [dbo].[DateTimeConversion_RunBlocks]
(@Print INT = NULL)
AS
BEGIN
	DECLARE @pkId INT
	DECLARE @tblName nvarchar(128)
	DECLARE @colName nvarchar(128)
	DECLARE @storeName NVARCHAR(375)
	DECLARE @sql nvarchar(MAX)
	DECLARE cur CURSOR LOCAL FOR SELECT pkId, TableName,ColName,[Sql], StoreName FROM [tblDateTimeConversion_Block] WHERE Converted = 0 AND [Sql] IS NOT NULL ORDER BY [Priority]	
	DECLARE @StartTime DATETIME2
	DECLARE @EndTime DATETIME2
	DECLARE @TotalCount INT
	SELECT @TotalCount = COUNT(*) FROM [tblDateTimeConversion_Block] WHERE Converted = 0 AND [Sql] IS NOT NULL 
	IF (@TotalCount = 0)
		RETURN
	OPEN cur
	FETCH NEXT FROM cur INTO @pkId, @tblName, @colName, @sql, @storeName
	DECLARE @loops INT = 0
	DECLARE @UpdateTime INT
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @loops = @loops + 1
		DECLARE @store NVARCHAR(500) = CASE WHEN @storeName IS NULL THEN '' ELSE ', STORENAME: ' + @storeName END 	 
		IF @Print IS NOT NULL PRINT CAST(@loops AS NVARCHAR(8)) + ' / ' + CAST(@TotalCount AS NVARCHAR(8)) + ' - PKID: ' + CAST(@pkId AS NVARCHAR(10)) +', TABLE: '+@tblName+', COLUMN: '+@colName + @store + ', TIMESTAMP: ' + CONVERT( VARCHAR(24), GETDATE(), 121)
		IF @Print IS NOT NULL PRINT '			SQL: ' + @sql
		BEGIN TRANSACTION [Transaction]
		BEGIN TRY
			SET @StartTime = GETDATE()
			EXEC sp_executesql @sql, N'@UpdateTimeRETURN int OUTPUT', @UpdateTimeRETURN = @UpdateTime OUTPUT				
			SET @EndTime = GETDATE()
			UPDATE [tblDateTimeConversion_Block] SET Converted = 1, StartTime = @StartTime, EndTime = @EndTime, UpdateTime = @UpdateTime WHERE pkID = @pkId
			IF @Print IS NOT NULL PRINT 'COMMIT'
			COMMIT TRANSACTION [Transaction]
		END TRY
		BEGIN CATCH
			IF @Print IS NOT NULL PRINT 'ROLLBACK: ' + ERROR_MESSAGE() 
			ROLLBACK TRANSACTION [Transaction]
		END CATCH  
		FETCH NEXT FROM cur INTO @pkId, @tblName, @colName, @sql, @storeName
	END	
	CLOSE cur
	DEALLOCATE cur
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalStepDecisionAdd]...';


GO
CREATE PROCEDURE [dbo].[netApprovalStepDecisionAdd](
	@ApprovalID INT,
	@StepIndex INT,
	@Approve BIT,
	@DecisionScope INT,
	@Username NVARCHAR(255),
	@DecisionTimeStamp DATETIME2,
	@Comment NVARCHAR(MAX) = NULL
)
AS
BEGIN
	INSERT INTO [dbo].[tblApprovalStepDecision] ([fkApprovalID], [StepIndex], [Approve], [DecisionScope], [Username], [DecisionTimeStamp], [Comment]) 
	VALUES (@ApprovalID, @StepIndex, @Approve, @DecisionScope, @Username, @DecisionTimeStamp, @Comment)
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalDefinitionGetCurrentVersion]...';


GO
CREATE PROCEDURE [dbo].[netApprovalDefinitionGetCurrentVersion](
	@ApprovalDefinitionIDs [dbo].[IDTable] READONLY,
	@ApprovalDefinitionKeys [dbo].[StringParameterTable] READONLY)
AS
BEGIN
	DECLARE @ApprovalDefinitionVersionIDs [dbo].[IDTable]

	IF EXISTS(select 1 from @ApprovalDefinitionIDs)  
		INSERT INTO @ApprovalDefinitionVersionIDs
		SELECT fkCurrentApprovalDefinitionVersionID 
		FROM [dbo].[tblApprovalDefinition] 
		JOIN @ApprovalDefinitionIDs ids ON ids.ID = pkID
	ELSE
		INSERT INTO @ApprovalDefinitionVersionIDs
		SELECT fkCurrentApprovalDefinitionVersionID 
		FROM [dbo].[tblApprovalDefinition] 
		JOIN @ApprovalDefinitionKeys keys ON keys.String = ApprovalDefinitionKey
	
	SELECT DISTINCT [definition].* FROM [dbo].[tblApprovalDefinition] [definition] 
	JOIN @ApprovalDefinitionVersionIDs [versionid] ON [definition].fkCurrentApprovalDefinitionVersionID = versionid.ID 
	
	SELECT [version].* FROM [dbo].[tblApprovalDefinitionVersion] [version]
	JOIN @ApprovalDefinitionVersionIDs [versionid] ON [version].pkID = versionid.ID 

	SELECT step.* FROM [dbo].[tblApprovalDefinitionStep] step
	JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON step.fkApprovalDefinitionVersionID = [version].pkID
	JOIN @ApprovalDefinitionVersionIDs [versionid] ON [version].pkID = versionid.ID 
	
	SELECT reviewer.* FROM [dbo].[tblApprovalDefinitionReviewer] reviewer 
	JOIN [dbo].[tblApprovalDefinitionVersion] [version] ON reviewer.fkApprovalDefinitionVersionID = [version].pkID
	JOIN @ApprovalDefinitionVersionIDs [versionid] ON [version].pkID = versionid.ID 
END
GO
PRINT N'Creating Procedure [dbo].[EntitySetEntry]...';


GO
CREATE PROCEDURE dbo.EntitySetEntry
@intObjectTypeID int,
@intObjectID int,
@uniqueID uniqueidentifier
AS
BEGIN
	INSERT INTO tblEntityGuid
			(intObjectTypeID, intObjectID, unqID)
	VALUES
			(@intObjectTypeID, @intObjectID, @uniqueID)
END
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentityGetOrCreate]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentityGetOrCreate]
	@ExternalIds dbo.UriPartsTable READONLY,
	@CreateIfMissing BIT,
    @Saved datetime2
AS
BEGIN
	SET NOCOUNT ON;

	--Create first missing entries
	IF @CreateIfMissing = 1
	BEGIN
		MERGE tblMappedIdentity AS Target
		USING @ExternalIds AS Source
		ON (Target.Provider = Source.Host AND Target.ProviderUniqueId = Source.Path)
		WHEN NOT MATCHED BY Target THEN
			INSERT (Provider, ProviderUniqueId, Saved)
			VALUES (Source.Host, Source.Path, @Saved);
	END

	SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider, MI.Metadata, MI.Saved
	FROM tblMappedIdentity AS MI INNER JOIN @ExternalIds AS EI ON MI.ProviderUniqueId = EI.Path
	WHERE MI.Provider = EI.Host
END
GO
PRINT N'Creating Procedure [dbo].[netPageLanguageSettingDelete]...';


GO
CREATE PROCEDURE dbo.netPageLanguageSettingDelete
(
	@PageID			INT,
	@LanguageBranch	NCHAR(17)
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @LangBranchID INT
	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @LanguageBranch
	IF @LangBranchID IS NULL
	BEGIN
		RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		RETURN 0
	END

	DELETE FROM tblPageLanguageSetting WHERE fkPageID=@PageID AND fkLanguageBranchID=@LangBranchID
	
END
GO
PRINT N'Creating Procedure [dbo].[netQuickSearchByPath]...';


GO
CREATE PROCEDURE dbo.netQuickSearchByPath
(
	@Path	NVARCHAR(1000),
	@PageID	INT,
	@LanguageBranch	NCHAR(17) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Index INT
	DECLARE @LastIndex INT
	DECLARE @LinkURL NVARCHAR(255)
	DECLARE @Name NVARCHAR(255)
	DECLARE @LangBranchID NCHAR(17);

	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END


	SET @Index = CHARINDEX('/',@Path)
	SET @LastIndex = 0

	WHILE @Index > 0 OR @Index IS NULL
	BEGIN
		SET @Name = SUBSTRING(@Path,@LastIndex,@Index-@LastIndex)

		SELECT TOP 1 @PageID=pkID,@LinkURL=tblPageLanguage.LinkURL
		FROM tblPageLanguage
		LEFT JOIN tblPage AS tblPage ON tblPage.pkID=tblPageLanguage.fkPageID
		WHERE tblPageLanguage.Name LIKE @Name AND (tblPage.fkParentID=@PageID OR @PageID IS NULL)
		AND (tblPageLanguage.fkLanguageBranchID=@LangBranchID OR @LangBranchID=-1)

		IF @@ROWCOUNT=0
		BEGIN
			SET @Index=0
			SET @LinkURL = NULL
		END
		ELSE
		BEGIN
			SET @LastIndex = @Index + 1
			SET @Index = CHARINDEX('/',@Path,@LastIndex+1)
		END
	END	

	SELECT @LinkURL
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessagesTruncate]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessagesTruncate]
(	
	@OlderThan	DATETIME2,
	@MaxRows BIGINT = NULL
)
AS
BEGIN
	IF (@MaxRows IS NOT NULL)
	BEGIN
		DELETE TOP(@MaxRows) FROM [tblNotificationMessage]
		WHERE Saved < @OlderThan
	END
	ELSE
	BEGIN
		DELETE FROM [tblNotificationMessage] 
		WHERE Saved < @OlderThan
	END

	SELECT @@ROWCOUNT

END
GO
PRINT N'Creating Procedure [dbo].[BigTableDeleteExcessReferences]...';


GO
CREATE PROCEDURE [dbo].[BigTableDeleteExcessReferences]
	@Id bigint,
	@PropertyName nvarchar(75),
	@StartIndex int
AS
BEGIN
BEGIN TRAN
	IF @StartIndex > -1
	BEGIN
		-- Creates temporary store with id's of references that has no other reference
		DECLARE @deletes AS BigTableDeleteItemInternalTable;
		
		INSERT INTO @deletes(Id, NestLevel, ObjectPath)
        SELECT DISTINCT R1.RefIdValue, 1, '/' + CAST(R1.RefIdValue AS VARCHAR) + '/' FROM tblBigTableReference AS R1
        LEFT OUTER JOIN tblBigTableReference AS R2 ON R1.RefIdValue = R2.pkId
        WHERE R1.pkId = @Id AND R1.PropertyName = @PropertyName AND R1.[Index] >= @StartIndex AND R2.RefIdValue IS NULL

		DELETE FROM @deletes WHERE Id IS NULL --Avoid filtering on NULL above to minimize deadlock risk

		-- Remove reference on main store
		DELETE FROM tblBigTableReference WHERE pkId = @Id and PropertyName = @PropertyName and [Index] >= @StartIndex
		
		IF((select count(*) from @deletes) > 0)
		BEGIN
			EXEC sp_executesql N'BigTableDeleteItemInternal @deletes', N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
		END

	END
	ELSE
		-- Remove reference on main store
		DELETE FROM tblBigTableReference WHERE pkId = @Id and PropertyName = @PropertyName and [Index] >= @StartIndex
COMMIT TRAN

END
GO
PRINT N'Creating Procedure [dbo].[netApprovalListByKeys]...';


GO
CREATE PROCEDURE [dbo].[netApprovalListByKeys](
	@ApprovalKeys [dbo].[StringParameterTable] READONLY)
AS
BEGIN
	DECLARE @Count INT = (SELECT COUNT(*) FROM @ApprovalKeys)

	IF (@Count = 1)
	BEGIN
		DECLARE @ApprovalKey NVARCHAR(255) = (SELECT TOP 1 String + '%' FROM @ApprovalKeys) 
		SELECT approval.* FROM [dbo].[tblApproval] approval 
		WHERE approval.ApprovalKey LIKE @ApprovalKey
	END ELSE BEGIN
		SELECT approval.* FROM [dbo].[tblApproval] approval 
		JOIN @ApprovalKeys keys ON approval.ApprovalKey LIKE keys.String + '%'
	END
END
GO
PRINT N'Creating Procedure [dbo].[netContentAclDeleteEntity]...';


GO
CREATE PROCEDURE dbo.netContentAclDeleteEntity
(
	@Name NVARCHAR(255),
	@IsRole INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	DELETE FROM tblContentAccess WHERE Name=@Name AND IsRole=@IsRole
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogEntrySave]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogEntrySave]
  (@LogData          [nvarchar](max) = NULL,
   @Type			 [nvarchar](255),
   @Action			 INTEGER = 0,
   @ChangedBy        [nvarchar](255),
   @RelatedItem		 [nvarchar](255),
   @Deleted			 [BIT] =  0,	
   @Id				 BIGINT = 0 OUTPUT,
   @ChangeDate       DATETIME2,
   @Associations	 dbo.StringParameterTable READONLY
)

AS            
BEGIN
	IF (@Id = 0)
	BEGIN
       INSERT INTO [tblActivityLog] VALUES(@LogData,
                                       @ChangeDate,
                                       @Type,
                                       @Action,
                                       @ChangedBy,
									   @RelatedItem, 
									   @Deleted)
		SET @Id = SCOPE_IDENTITY()

		INSERT INTO tblActivityLogAssociation([To], [From])
		SELECT @Id, Source.String
		FROM @Associations AS Source
	END
	ELSE
	BEGIN
		UPDATE [tblActivityLog] SET
			[LogData] = @LogData,
			[ChangeDate] = @ChangeDate,
			[Type] = @Type,
			[Action] = @Action,
			[ChangedBy] = @ChangedBy,
			[RelatedItem] = @RelatedItem,
			[Deleted] = @Deleted
		WHERE pkID = @Id

		MERGE tblActivityLogAssociation AS Target
		USING @Associations AS Source
		ON (Target.[To] = @Id AND Target.[From] = Source.String)
		WHEN NOT MATCHED BY Target THEN
			INSERT ([To], [From])
			VALUES (@Id, Source.String);
	END
END
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentityDelete]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentityDelete]
	@Provider NVARCHAR(255),
	@ProviderUniqueId NVARCHAR(2048)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @returnVal TABLE ([ContentGuid] [UNIQUEIDENTIFIER] NOT NULL)

	DELETE
	FROM tblMappedIdentity
    OUTPUT deleted.ContentGuid INTO @returnVal
	WHERE tblMappedIdentity.Provider = @Provider AND tblMappedIdentity.ProviderUniqueId = @ProviderUniqueId

    SELECT TOP 1 ContentGuid FROM @returnVal
END
GO
PRINT N'Creating Procedure [dbo].[netContentAclAdd]...';


GO
CREATE PROCEDURE dbo.netContentAclAdd
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID INT,
	@AccessMask INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	UPDATE 
	    tblContentAccess 
	SET 
	    AccessMask=@AccessMask
	WHERE 
	    fkContentID=@ContentID AND 
	    Name=@Name AND 
	    IsRole=@IsRole
	    
	IF (@@ROWCOUNT = 0)
	BEGIN
		-- Does not exist, create it
		INSERT INTO tblContentAccess 
		    (fkContentID, Name, IsRole, AccessMask) 
		VALUES 
		    (@ContentID, @Name, @IsRole, @AccessMask)
	END
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationSetInvalid]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationSetInvalid]
    @processorId uniqueidentifier,
    @inactiveConnectionTimeoutSeconds int
as
begin
    begin try
        begin transaction
        exec ChangeNotificationSetInvalidWorker @processorId, @inactiveConnectionTimeoutSeconds
        commit transaction
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessageGetForRecipients]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessageGetForRecipients]
	@ScheduledBefore DATETIME2 = NULL,
	@Recipients dbo.StringParameterTable READONLY
AS
BEGIN
	SELECT
		pkID AS ID, Recipient, Sender, Channel, [Type], [Subject], Content, Sent, SendAt, Saved, [Read], Category
		FROM
			[tblNotificationMessage] AS M INNER JOIN @Recipients AS R ON M.Recipient = R.String
		WHERE
			Sent IS NULL AND
			(SendAt IS NULL OR
			(@ScheduledBefore IS NOT NULL AND SendAt IS NOT NULL AND @ScheduledBefore > SendAt))
					
		ORDER BY Recipient
END
GO
PRINT N'Creating Procedure [dbo].[netPermissionRoles]...';


GO
CREATE PROCEDURE dbo.netPermissionRoles
(
	@Permission	NVARCHAR(150),
	@GroupName  NVARCHAR(150)
)
AS
BEGIN
    SET NOCOUNT ON
    SELECT
        Name,
        IsRole
    FROM
        tblUserPermission
    WHERE
        Permission=@Permission AND GroupName = @GroupName
    ORDER BY
        IsRole
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationEnqueueString]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationEnqueueString]
    @processorId uniqueidentifier,
    @items ChangeNotificationStringTable readonly
as
begin
    begin try
        begin transaction

        declare @processorStatus nvarchar(30)
        select @processorStatus = ProcessorStatus
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId

        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            declare @queueOrder int
            update tblChangeNotificationProcessor
            set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1, LastConsistentDbUtc = case when @processorStatus = 'valid' and NextQueueOrderValue = 0 then SYSUTCDATETIME() else LastConsistentDbUtc end
            where ProcessorId = @processorId

            -- insert values from @items, avoiding any values which are already in the queue and not in an outstanding batch.
            insert into tblChangeNotificationQueuedString (ProcessorId, QueueOrder, ConnectionId, Value)
            select @processorId, @queueOrder, null, i.Value
            from @items i
            left outer join tblChangeNotificationQueuedString q
                on q.ProcessorId = @processorId
                and q.ConnectionId is null
                and i.Value = q.Value
            where q.ProcessorId is null
        end

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netBlobPendingDeleteInsert]...';


GO
CREATE PROCEDURE [dbo].[netBlobPendingDeleteInsert]
    @BlobUri NVARCHAR(255),
    @ContentId INT,
    @Provider NVARCHAR(255)
AS
BEGIN
	INSERT INTO tblBlobPendingDelete(BlobUri, fkContentId, Provider) VALUES(@BlobUri, @ContentId, @Provider)
END
GO
PRINT N'Creating Procedure [dbo].[netPagePath]...';


GO
CREATE PROCEDURE  [dbo].[netPagePath]
(
	@PageID INT
)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT PagePath FROM tblPage where tblPage.pkID = @PageID
END
GO
PRINT N'Creating Procedure [dbo].[netFrameDelete]...';


GO
CREATE PROCEDURE dbo.netFrameDelete
(
	@FrameID		INT,
	@ReplaceFrameID	INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

		IF (NOT EXISTS(SELECT pkID FROM tblFrame WHERE pkID=@ReplaceFrameID))
			SET @ReplaceFrameID=NULL
		UPDATE tblWorkPage SET fkFrameID=@ReplaceFrameID WHERE fkFrameID=@FrameID
		UPDATE tblPageLanguage SET fkFrameID=@ReplaceFrameID WHERE fkFrameID=@FrameID
		DELETE FROM tblFrame WHERE pkID=@FrameID

	RETURN 0
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationSubscriptionClearSubscription]...';


GO
CREATE PROCEDURE [dbo].[netNotificationSubscriptionClearSubscription]
	@SubscriptionKey [nvarchar](255)
AS
BEGIN
	DECLARE @key [nvarchar](256) = @SubscriptionKey + CASE SUBSTRING(@SubscriptionKey, LEN(@SubscriptionKey), 1) WHEN N'/' THEN N'' ELSE N'/' END

	DELETE FROM [dbo].[tblNotificationSubscription] WHERE SubscriptionKey LIKE @key + '%'
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogAssociationDelete]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogAssociationDelete]
(
	@AssociatedItem	[nvarchar](255),
	@ChangeLogID  BIGINT = 0
)
AS            
BEGIN
	DELETE FROM [tblActivityLogAssociation] WHERE [From] = @AssociatedItem AND (@ChangeLogID = 0 OR @ChangeLogID = [To])
	DECLARE @RowCount INT = (SELECT @@ROWCOUNT)
	UPDATE [tblActivityLog] SET RelatedItem = NULL WHERE @ChangeLogID = 0 AND RelatedItem = @AssociatedItem
	SELECT @@ROWCOUNT + @RowCount
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationCompleteBatchInt]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationCompleteBatchInt]
    @connectionId uniqueidentifier,
    @success bit
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'Int'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            if (@success = 1)
            begin
                delete from tblChangeNotificationQueuedInt
                where ConnectionId = @connectionId

                if not exists (select 1 from tblChangeNotificationQueuedInt where ProcessorId = @processorId)
                begin
                    update tblChangeNotificationProcessor
                    set NextQueueOrderValue = 0, LastConsistentDbUtc = SYSUTCDATETIME()
                    where ProcessorId = @processorId
                end
            end
            else
            begin
                declare @queueOrder int
                update tblChangeNotificationProcessor
                set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1
                where ProcessorId = @processorId

                update tblChangeNotificationQueuedInt
                set QueueOrder = @queueOrder, ConnectionId = null
                where ConnectionId = @connectionId
            end
        end

        commit transaction
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netBlobPendingDeleteRemove]...';


GO
CREATE PROCEDURE [dbo].[netBlobPendingDeleteRemove]
    @ProcessedIds dbo.LongParameterTable READONLY
AS
BEGIN
	DELETE tblBlobPendingDelete FROM tblBlobPendingDelete AS Uris INNER JOIN @ProcessedIds AS Ids ON Uris.pkID = Ids.Id
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationSubscriptionUnsubscribe]...';


GO
CREATE PROCEDURE [dbo].[netNotificationSubscriptionUnsubscribe]
	@UserName [nvarchar](255),
	@SubscriptionKey [nvarchar](255)
AS
BEGIN
	DECLARE @key [nvarchar](256) = @SubscriptionKey + CASE SUBSTRING(@SubscriptionKey, LEN(@SubscriptionKey), 1) WHEN N'/' THEN N'' ELSE N'/' END

	DECLARE @SubscriptionCount INT = (SELECT COUNT(*) FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName AND SubscriptionKey = @key AND Active = 1)
	DECLARE @Result INT = CASE @SubscriptionCount WHEN 0 THEN 0 ELSE 1 END
	IF (@SubscriptionCount > 0)
		UPDATE [dbo].[tblNotificationSubscription] SET Active = 0 WHERE UserName = @UserName AND SubscriptionKey = @key
	SELECT @Result
END
GO
PRINT N'Creating Procedure [dbo].[netSiteConfigGet]...';


GO
CREATE PROCEDURE [dbo].[netSiteConfigGet]
	@SiteID VARCHAR(250) = NULL,
	@PropertyName VARCHAR(250)
AS
BEGIN
	IF @SiteID IS NULL
	BEGIN
		SELECT * FROM tblSiteConfig WHERE PropertyName = @PropertyName
	END
	ELSE
	BEGIN
		SELECT * FROM tblSiteConfig WHERE SiteID = @SiteID AND PropertyName = @PropertyName
	END
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogEntryLoad]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogEntryLoad]
(
   @Id				BIGINT
)

AS            
BEGIN
	SELECT * FROM [tblActivityLog]
	WHERE pkID = @Id
END
GO
PRINT N'Creating Procedure [dbo].[EntityGetIDByGuid]...';


GO
CREATE PROCEDURE dbo.EntityGetIDByGuid
@unqID uniqueidentifier
AS
BEGIN
	SELECT 
		intObjectTypeID, intObjectID
	FROM tblEntityGuid
	WHERE unqID = @unqID
END
GO
PRINT N'Creating Procedure [dbo].[netFindContentCoreDataByContentGuid]...';


GO
CREATE PROCEDURE [dbo].[netFindContentCoreDataByContentGuid]
	@ContentGuid UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

        --- *** use NOLOCK since this may be called during page save if debugging. The code should not be written so this happens, it's to make it work in the debugger ***
	SELECT TOP 1 P.pkID as ID, P.fkContentTypeID as ContentTypeID, P.fkParentID as ParentID, P.ContentGUID, PL.LinkURL, P.Deleted, CASE WHEN Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PendingPublish, PL.Created, PL.Changed, PL.Saved, PL.StartPublish, PL.StopPublish, P.ContentAssetsID, P.fkMasterLanguageBranchID as MasterLanguageBranchID, PL.ContentLinkGUID as ContentLinkID, PL.AutomaticLink, PL.FetchData, P.ContentType
	FROM tblContent AS P WITH (NOLOCK)
	LEFT JOIN tblContentLanguage AS PL ON PL.fkContentID=P.pkID
	WHERE P.ContentGUID = @ContentGuid AND (P.fkMasterLanguageBranchID=PL.fkLanguageBranchID OR P.fkMasterLanguageBranchID IS NULL)
END
GO
PRINT N'Creating Procedure [dbo].[DateTimeConversion_InitFieldNames]...';


GO
CREATE PROCEDURE [dbo].[DateTimeConversion_InitFieldNames]
AS
BEGIN
	IF OBJECT_ID('[dbo].[tblDateTimeConversion_FieldName]', 'U') IS NOT NULL
		DROP TABLE [dbo].[tblDateTimeConversion_FieldName]

	CREATE TABLE [dbo].[tblDateTimeConversion_FieldName](
		[pkID] [int] IDENTITY(1,1) NOT NULL,		
		[TableName] nvarchar(128) NOT NULL,
		[ColName] nvarchar(128) NOT NULL,
		[StoreName] NVARCHAR(375) NULL,
		CONSTRAINT [PK_DateTimeConversion_InitFieldNames] PRIMARY KEY  CLUSTERED
		(
			[pkID]
		)
	)

	DECLARE @FieldNames AS TABLE 
	(
		TableName NVARCHAR(128) NOT NULL,
		ColName NVARCHAR(128) NULL,
		StoreName NVARCHAR(375) NULL
	)

	INSERT INTO @FieldNames
	EXEC DateTimeConversion_GetFieldNames

	INSERT INTO @FieldNames
	SELECT TableName = c.name, ColName = a.name, f.StoreName  from 
		sys.columns a 
		INNER JOIN sys.types t ON a.user_type_id = t.user_type_id AND (t.name = 'datetime' OR t.name = 'datetime2')
		INNER JOIN sys.tables c ON a.object_id = c.object_id 
		INNER JOIN @FieldNames f ON c.object_id = OBJECT_ID(f.TableName)
	WHERE f.ColName IS NULL
	
	DELETE @FieldNames WHERE ColName IS NULL

	DECLARE @DateTimeKind INT
	EXEC @DateTimeKind = sp_GetDateTimeKind
	INSERT INTO [dbo].[tblDateTimeConversion_FieldName](TableName, ColName, StoreName)
	SELECT DISTINCT REPLACE(REPLACE(REPLACE(X.TableName,'[',''),']',''),'dbo.',''), ColName = REPLACE(REPLACE(X.ColName,']',''),'[',''), X.StoreName FROM (
		SELECT f.TableName, f.ColName, StoreName = NULL FROM @FieldNames f WHERE @DateTimeKind = 0 AND f.StoreName IS NULL
		UNION
		SELECT DISTINCT f.TableName, f.ColName, f.StoreName
		FROM sys.columns a 
		INNER JOIN sys.types t ON a.user_type_id = t.user_type_id AND (t.name = 'datetime' OR t.name = 'datetime2')
		INNER JOIN sys.tables c ON a.object_id = c.object_id 
		INNER JOIN tblBigTableStoreConfig i ON c.object_id = OBJECT_ID(i.TableName) AND i.DateTimeKind = 0
		INNER JOIN @FieldNames f ON c.object_id = OBJECT_ID(f.TableName) AND (a.name COLLATE database_default = f.ColName OR '['+a.name COLLATE database_default+']' = f.ColName) AND f.StoreName = i.StoreName
	) X
	INNER JOIN (
		SELECT TableId = c.object_id, ColName = a.name FROM sys.columns a 
		INNER JOIN sys.types t ON a.user_type_id = t.user_type_id AND (t.name = 'datetime' OR t.name = 'datetime2')
		INNER JOIN sys.tables c ON a.object_id = c.object_id
	) Y 
	ON Y.TableId = OBJECT_ID(X.TableName) AND (Y.ColName = X.ColName COLLATE database_default OR '['+Y.ColName +']' = X.ColName COLLATE database_default)
END
GO
PRINT N'Creating Procedure [dbo].[netFrameList]...';


GO
CREATE PROCEDURE dbo.netFrameList
AS
BEGIN
	SET NOCOUNT ON

	SELECT
		pkID AS FrameID, 
		CASE
			WHEN FrameName IS NULL THEN
				N''
			ELSE
				SUBSTRING(FrameName, 9, LEN(FrameName) - 9)
		END AS FrameName,
		FrameDescription,
		'' AS FrameDescriptionLocalized,
		CONVERT(INT, SystemFrame) AS SystemFrame
	FROM
		tblFrame
	ORDER BY
		SystemFrame DESC,
		FrameName
END
GO
PRINT N'Creating Procedure [dbo].[netFindContentCoreDataByID]...';


GO
CREATE PROCEDURE [dbo].[netFindContentCoreDataByID]
	@ContentID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

        --- *** use NOLOCK since this may be called during content save if debugging. The code should not be written so this happens, it's to make it work in the debugger ***
	SELECT TOP 1 P.pkID as ID, P.fkContentTypeID as ContentTypeID, P.fkParentID as ParentID, P.ContentGUID, PL.LinkURL, P.Deleted, CASE WHEN Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PendingPublish, PL.Created, PL.Changed, PL.Saved, PL.StartPublish, PL.StopPublish, P.ContentAssetsID, P.fkMasterLanguageBranchID as MasterLanguageBranchID, PL.ContentLinkGUID as ContentLinkID, PL.AutomaticLink, PL.FetchData, P.ContentType
	FROM tblContent AS P WITH (NOLOCK)
	LEFT JOIN tblContentLanguage AS PL ON PL.fkContentID = P.pkID
	WHERE P.pkID = @ContentID AND (P.fkMasterLanguageBranchID = PL.fkLanguageBranchID OR P.fkMasterLanguageBranchID IS NULL)
END
GO
PRINT N'Creating Procedure [dbo].[DateTimeConversion_Finalize]...';


GO
CREATE PROCEDURE [dbo].[DateTimeConversion_Finalize]
(@Print INT = NULL)
AS
BEGIN
	IF @Print IS NOT NULL PRINT 'UPDATE DateTimeKind'

	UPDATE tbl 
	SET DateTimeKind = 2
	FROM tblBigTableStoreConfig tbl
	JOIN tblDateTimeConversion_FieldName f ON tbl.StoreName = f.StoreName AND tbl.TableName = f.TableName 

	DECLARE @GetDateTimeKindSql NVARCHAR(MAX) = '
ALTER PROCEDURE [dbo].[sp_GetDateTimeKind]
AS
	-- 0 === Unspecified  
	-- 1 === Local time 
	-- 2 === UTC time 
	RETURN 2

'
	EXEC (@GetDateTimeKindSql)

	IF @Print IS NOT NULL PRINT 'FINISHED'
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalUpdate]...';


GO
CREATE PROCEDURE [dbo].[netApprovalUpdate](
	@ApprovalID INT,
	@ActiveStepIndex INT,
	@ActiveStepStarted DATETIME2,
	@Completed DATETIME2 = NULL,
	@ApprovalStatus INT,
	@CompletedComment NVARCHAR(MAX) = NULL,
	@CompletedBy NVARCHAR(255) = NULL)
AS
BEGIN
	UPDATE [dbo].[tblApproval] SET 
		[ActiveStepIndex] = @ActiveStepIndex,
		[ActiveStepStarted] = @ActiveStepStarted,
		[Completed] = @Completed,
		[ApprovalStatus] = @ApprovalStatus,
		[CompletedComment] = @CompletedComment,
		[CompletedBy] = @CompletedBy
	WHERE pkID = @ApprovalID
END
GO
PRINT N'Creating Procedure [dbo].[EntityTypeGetNameByID]...';


GO
CREATE PROCEDURE dbo.EntityTypeGetNameByID
@intObjectTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT strName FROM dbo.tblEntityType WHERE intID = @intObjectTypeID
END
GO
PRINT N'Creating Procedure [dbo].[netCategoryStringToTable]...';


GO
CREATE PROCEDURE dbo.netCategoryStringToTable
(
	@CategoryList	NVARCHAR(2000)
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE		@DotPos INT
	DECLARE		@Category NVARCHAR(255)

	DECLARE @CategoryResult TABLE(fkCategoryID INT)
	
	WHILE (DATALENGTH(@CategoryList) > 0)
	BEGIN
		SET @DotPos = CHARINDEX(N',', @CategoryList)
		IF @DotPos > 0
			SET @Category = LEFT(@CategoryList,@DotPos-1)
		ELSE
		BEGIN
			SET @Category = @CategoryList
			SET @CategoryList = NULL
		END
		IF LEN(@Category) > 0 AND @Category NOT LIKE '%[^0-9]%'
		    INSERT INTO @CategoryResult SELECT pkID FROM tblCategory WHERE pkID = CAST(@Category AS INT)
		ELSE
			INSERT INTO @CategoryResult SELECT pkID FROM tblCategory WHERE CategoryName = @Category
			
		IF (DATALENGTH(@CategoryList) > 0)
			SET @CategoryList = SUBSTRING(@CategoryList,@DotPos+1,255)
	END
	SELECT * FROM @CategoryResult
END
GO
PRINT N'Creating Procedure [dbo].[DateTimeConversion_InitBlocks]...';


GO
CREATE PROCEDURE [dbo].[DateTimeConversion_InitBlocks]
(@BlockSize INT, @Print INT = NULL)
AS
BEGIN
	IF OBJECT_ID('[dbo].[tblDateTimeConversion_Block]', 'U') IS NOT NULL
	BEGIN
		IF (SELECT COUNT(*) FROM [dbo].[tblDateTimeConversion_Block] WHERE Converted > 0 AND [Sql] IS NOT NULL) > 0 
			RETURN 
		ELSE 
			DROP TABLE [dbo].[tblDateTimeConversion_Block]
	END

	CREATE TABLE [dbo].[tblDateTimeConversion_Block](
		[pkID] [int] IDENTITY(1,1) NOT NULL,		
		[TableName] nvarchar(128) NOT NULL,
		[ColName] nvarchar(128) NOT NULL,
		[StoreName] NVARCHAR(375) NULL,
		[BlockRank] INT NOT NULL,
		[BlockCount] INT NOT NULL,
		[Sql] nvarchar(MAX) NULL,
		[Priority] INT NOT NULL DEFAULT 0,
		[Converted] BIT NOT NULL DEFAULT 0,
		[StartTime] DATETIME2 NULL,
		[EndTime] DATETIME2 NULL,
		[UpdateTime] INT NULL,
		[CallTime] AS (DATEDIFF(MS, StartTime,EndTime)),
		CONSTRAINT [PK_tblDateTimeConversion_Block] PRIMARY KEY  CLUSTERED
		(
			[pkID]
		)
	)

	DECLARE @tblName NVARCHAR(128)
	DECLARE @colName NVARCHAR(128)
	DECLARE @storeName NVARCHAR(375)

	DECLARE cur CURSOR LOCAL FOR SELECT TableName, ColName, StoreName FROM [dbo].[tblDateTimeConversion_FieldName]                                  
	DECLARE @TotalCount INT
	DECLARE @loops INT = 0
	SELECT @TotalCount = COUNT(*) FROM [dbo].[tblDateTimeConversion_FieldName]                                                           
	OPEN cur
	FETCH NEXT FROM cur INTO @tblName, @colName, @storeName
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @loops = @loops + 1
		DECLARE @store NVARCHAR(500) = CASE WHEN @storeName IS NULL THEN '' ELSE ', STORENAME: ' + @storeName END 	 
		IF @Print IS NOT NULL PRINT CAST(@loops AS NVARCHAR(8)) + ' / ' + CAST(@TotalCount AS NVARCHAR(8)) + ' - TABLE: '+@tblName+', COLUMN: '+@colName + @store +', TIMESTAMP: ' + CONVERT( VARCHAR(24), GETDATE(), 121)
		EXEC [dbo].[DateTimeConversion_MakeTableBlocks] @tblName, @colName, @storeName, @BlockSize, @Print		 
		FETCH NEXT FROM cur INTO @tblName, @colName, @storeName
	END	
	CLOSE cur
	DEALLOCATE cur
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalStepDecisionList]...';


GO
CREATE PROCEDURE [dbo].[netApprovalStepDecisionList](
	@ApprovalID INT,
	@StepIndex INT = NULL)
AS
BEGIN
	IF @StepIndex IS NULL
	BEGIN
		SELECT * FROM [dbo].[tblApprovalStepDecision] decision
		WHERE decision.fkApprovalID = @ApprovalID
		ORDER BY decision.StepIndex ASC
	END ELSE BEGIN
		SELECT * FROM [dbo].[tblApprovalStepDecision] decision
		WHERE decision.fkApprovalID = @ApprovalID AND decision.StepIndex = @StepIndex
	END
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogAssociatedAnyList]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogAssociatedAnyList]
(
	@Associations	 dbo.StringParameterTable READONLY,
	@StartIndex			BIGINT = NULL,
	@MaxCount			INT = NULL
)
AS            
BEGIN
	DECLARE @Compare AS TABLE(String NVARCHAR(256), CompareString NVARCHAR(257), StringLen INT)
	INSERT INTO @Compare SELECT String, String + '%', LEN(String) FROM (SELECT String = CASE RIGHT(String, 1) WHEN '/' THEN LEFT(String,LEN(String) - 1) ELSE String END FROM @Associations WHERE String IS NOT NULL) X

	DECLARE @Ids AS TABLE([ID] [bigint] NOT NULL)

	INSERT INTO @Ids
		SELECT pkID FROM (
			SELECT pkID, [From] AS Value, StringLen 
			FROM [tblActivityLog]
			JOIN tblActivityLogAssociation ON pkID = [To] 
			JOIN @Compare ON [From] LIKE CompareString
			WHERE Deleted = 0
		) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'
	UNION
		SELECT pkID FROM (
			SELECT pkID, RelatedItem AS Value, StringLen
			FROM [tblActivityLog]
			JOIN @Compare ON RelatedItem LIKE CompareString
			WHERE Deleted = 0
		) Matched WHERE LEN(Value) = StringLen OR SUBSTRING(Value, StringLen + 1, 1) = '/'

	DECLARE @TotalCount INT = (SELECT COUNT(*) FROM @Ids)

	SELECT TOP(@MaxCount) [pkID], [Action], [Type], [ChangeDate], [ChangedBy], [LogData], [RelatedItem], [Deleted], @TotalCount AS 'TotalCount'
	FROM [tblActivityLog] al
	JOIN @Ids ids ON al.[pkID] = ids.[ID]
	WHERE [pkID] <= @StartIndex
	ORDER BY [pkID] DESC
END
GO
PRINT N'Creating Procedure [dbo].[netSiteDefinitionList]...';


GO
CREATE PROCEDURE [dbo].[netSiteDefinitionList]
AS
BEGIN
	SELECT UniqueId, Name, SiteUrl, StartPage, SiteAssetsRoot, SavedBy, Saved FROM tblSiteDefinition

	SELECT site.[UniqueId] AS SiteId, host.[Name], host.[Type], host.[Language], host.[Https] 
	FROM tblHostDefinition host
	INNER JOIN tblSiteDefinition site ON site.pkID = host.fkSiteID

END
GO
PRINT N'Creating Procedure [dbo].[netSiteDefinitionDelete]...';


GO
CREATE PROCEDURE [dbo].[netSiteDefinitionDelete]
(
	@UniqueId		uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON

	DELETE FROM tblSiteDefinition WHERE UniqueId = @UniqueId
END
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentityListProviders]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentityListProviders]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT Provider
	FROM tblMappedIdentity 
END
GO
PRINT N'Creating Procedure [dbo].[netPermissionSave]...';


GO
CREATE PROCEDURE dbo.netPermissionSave
(
	@Name NVARCHAR(255) = NULL,
	@IsRole INT = NULL,
	@Permission NVARCHAR(150),
	@GroupName NVARCHAR(150),
	@ClearByName INT = NULL,
	@ClearByPermission INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (NOT @ClearByName IS NULL)
		DELETE FROM 
		    tblUserPermission 
		WHERE 
		    Name=@Name AND 
		IsRole=@IsRole
		
	IF (NOT @ClearByPermission IS NULL)
		DELETE FROM 
		    tblUserPermission 
		WHERE 
		    Permission=@Permission AND GroupName = @GroupName	

    IF ((@Name IS NULL) OR (@IsRole IS NULL))
        RETURN
        
	IF (NOT EXISTS(SELECT Name FROM tblUserPermission WHERE Name=@Name AND IsRole=@IsRole AND Permission=@Permission AND GroupName = @GroupName))
		INSERT INTO tblUserPermission 
		    (Name, 
		    IsRole, 
		    Permission,
			GroupName) 
		VALUES 
		    (@Name, 
		    @IsRole, 
		    @Permission,
			@GroupName)
END
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentityDeleteItems]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentityDeleteItems]
	@ContentGuids dbo.GuidParameterTable READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DELETE mi 
	FROM tblMappedIdentity mi
	INNER JOIN @ContentGuids cg ON mi.ContentGuid = cg.Id
END
GO
PRINT N'Creating Procedure [dbo].[netFindContentCoreDataByIDBatch]...';


GO
CREATE PROCEDURE [dbo].[netFindContentCoreDataByIDBatch]
	@ContentIDs AS IDTable READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

        --- *** use NOLOCK since this may be called during content save if debugging. The code should not be written so this happens, it's to make it work in the debugger ***
	SELECT P.pkID as ID, P.fkContentTypeID as ContentTypeID, P.fkParentID as ParentID, P.ContentGUID, PL.LinkURL, P.Deleted, CASE WHEN Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PendingPublish, PL.Created, PL.Changed, PL.Saved, PL.StartPublish, PL.StopPublish, P.ContentAssetsID, P.fkMasterLanguageBranchID as MasterLanguageBranchID, PL.ContentLinkGUID as ContentLinkID, PL.AutomaticLink, PL.FetchData, P.ContentType
	FROM tblContent AS P WITH (NOLOCK)
    INNER JOIN @ContentIDs as ParamIds on P.pkID = ParamIds.ID	
	LEFT JOIN tblContentLanguage AS PL ON PL.fkContentID = P.pkID
	WHERE P.fkMasterLanguageBranchID = PL.fkLanguageBranchID OR P.fkMasterLanguageBranchID IS NULL
END
GO
PRINT N'Creating Procedure [dbo].[netContentAclSetInherited]...';


GO
CREATE PROCEDURE dbo.netContentAclSetInherited
(
	@ContentID INT,
	@Recursive INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@Recursive = 1)
    BEGIN
        /* Remove all old ACEs for @ContentID and below */
        DELETE FROM 
           tblContentAccess
        WHERE 
            fkContentID IN (SELECT fkChildID FROM tblTree WHERE fkParentID=@ContentID) OR 
            fkContentID=@ContentID
        RETURN
    END
	ELSE
	BEGIN
		DELETE FROM tblContentAccess
		WHERE fkContentID = @ContentID
	END
END
GO
PRINT N'Creating Procedure [dbo].[netURLSegmentSet]...';


GO
CREATE PROCEDURE [dbo].[netURLSegmentSet]
(
	@URLSegment			NCHAR(255),
	@PageID				INT,
	@LanguageBranch		NCHAR(17) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @LangBranchID NCHAR(17);
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END

	UPDATE tblPageLanguage
	SET URLSegment = RTRIM(@URLSegment)
	WHERE fkPageID = @PageID
	AND (@LangBranchID=-1 OR fkLanguageBranchID=@LangBranchID)

	UPDATE tblWorkPage
	SET URLSegment = RTRIM(@URLSegment)
	WHERE fkPageID = @PageID
	AND (@LangBranchID=-1 OR fkLanguageBranchID=@LangBranchID)
END
GO
PRINT N'Creating Procedure [dbo].[netSiteConfigDelete]...';


GO
CREATE PROCEDURE [dbo].[netSiteConfigDelete]
	@SiteID VARCHAR(250),
	@PropertyName VARCHAR(250)
AS
BEGIN
	DELETE FROM tblSiteConfig WHERE SiteID = @SiteID AND PropertyName = @PropertyName
END
GO
PRINT N'Creating Procedure [dbo].[netUnmappedPropertyList]...';


GO
CREATE PROCEDURE [dbo].netUnmappedPropertyList
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT 
		tblProperty.LinkGuid as GuidID,
		tblProperty.fkPageID as PageID, 
		tblProperty.fkLanguageBranchID as LanguageBranchID,
		tblPageDefinition.Name as PropertyName,
		tblPageDefinition.fkPageTypeID as PageTypeID
		
	FROM
		tblProperty INNER JOIN tblPageDefinition on tblProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		tblProperty.LinkGuid IS NOT NULL AND
		tblProperty.PageLink IS NULL		
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationTrySetRecovering]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationTrySetRecovering]
    @connectionId uniqueidentifier,
    @inactiveConnectionTimeoutSeconds int
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        declare @result bit

        if (@processorStatus = 'invalid')
        begin
            delete from tblChangeNotificationConnection
            where ProcessorId = @processorId
              and LastActivityDbUtc < DATEADD(second, -@inactiveConnectionTimeoutSeconds, SYSUTCDATETIME())

            update tblChangeNotificationProcessor
            set ProcessorStatus = 'recovering'
            where ProcessorId = @processorId

            set @result = 1
        end
        else
        begin
            set @result = 0
        end

        commit transaction

        select @result as StateChanged
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessageInsert]...';


GO

CREATE PROCEDURE [dbo].[netNotificationMessageInsert]
	@Recipient NVARCHAR(255),
	@Sender NVARCHAR(255),
	@Channel NVARCHAR(50) = NULL,
	@Type NVARCHAR(50) = NULL,
	@Subject NVARCHAR(255) = NULL,
	@Content NVARCHAR(MAX) = NULL,
	@Saved DATETIME2,
	@Sent DATETIME2 = NULL,
	@SendAt DATETIME2 = NULL,
	@Category NVARCHAR(255) = NULL
AS
BEGIN
	INSERT INTO tblNotificationMessage(Recipient, Sender, Channel, Type, Subject, Content, SendAt, Saved, Sent ,Category)
	VALUES(@Recipient, @Sender, @Channel, @Type, @Subject, @Content, @SendAt, @Saved, @Sent, @Category)
	SELECT SCOPE_IDENTITY()
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationSubscriptionListByKey]...';


GO
CREATE PROCEDURE [dbo].[netNotificationSubscriptionListByKey]
	@SubscriptionKey [nvarchar](255),
	@SubscriptionKeyMatchMode INT = 0		-- Exact = 0, Before = 1, After = 2
AS
BEGIN 
	DECLARE @key [nvarchar](256) = @SubscriptionKey + CASE SUBSTRING(@SubscriptionKey, LEN(@SubscriptionKey), 1) WHEN N'/' THEN N'' ELSE N'/' END

	IF @SubscriptionKeyMatchMode = 1 
		SELECT [pkID], [UserName], [SubscriptionKey] FROM [dbo].[tblNotificationSubscription] WHERE Active = 1 AND (SubscriptionKey = @key OR @key LIKE SubscriptionKey + '%')
	ELSE IF @SubscriptionKeyMatchMode = 2 
		SELECT [pkID], [UserName], [SubscriptionKey] FROM [dbo].[tblNotificationSubscription] WHERE Active = 1 AND (SubscriptionKey = @key OR SubscriptionKey LIKE @key + '%')
	ELSE
		SELECT [pkID], [UserName], [SubscriptionKey] FROM [dbo].[tblNotificationSubscription] WHERE Active = 1 AND SubscriptionKey = @key
END
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentityGetByGuid]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentityGetByGuid]
	@ContentGuids dbo.GuidParameterTable READONLY
AS
BEGIN
	SET NOCOUNT ON;

	SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider, MI.Metadata, MI.Saved
	FROM tblMappedIdentity AS MI INNER JOIN @ContentGuids AS EI ON MI.ContentGuid = EI.Id
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessageGetRecipients]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessageGetRecipients]
	@Read BIT = NULL,
	@Sent BIT = NULL
AS 
BEGIN
	SELECT Distinct(Recipient) FROM tblNotificationMessage
	WHERE 
		(@Read IS NULL OR 
			((@Read = 1 AND [Read] IS NOT NULL) OR
			(@Read = 0 AND [Read] IS NULL)))
		AND
		(@Sent IS NULL OR 
			((@Sent = 1 AND [Sent] IS NOT NULL) OR
			(@Sent = 0 AND [Sent] IS NULL)))
END
GO
PRINT N'Creating Procedure [dbo].[netSiteConfigSet]...';


GO
CREATE PROCEDURE [dbo].[netSiteConfigSet]
	@SiteID VARCHAR(250),
	@PropertyName VARCHAR(250),
	@PropertyValue NVARCHAR(max)
AS
BEGIN
	DECLARE @Id AS INT
	SELECT @Id = pkID FROM tblSiteConfig WHERE SiteID = @SiteID AND PropertyName = @PropertyName

	IF @Id IS NOT NULL
	BEGIN
		-- Update
		UPDATE tblSiteConfig SET PropertyValue = @PropertyValue WHERE pkID = @Id
	END
	ELSE
	BEGIN
		INSERT INTO tblSiteConfig(SiteID, PropertyName, PropertyValue) VALUES(@SiteID, @PropertyName, @PropertyValue)
	END
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessagesRead]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessagesRead]
	@MessageIDs dbo.IDTable READONLY,
	@Read DATETIME2
AS
BEGIN
	UPDATE M SET [Read] = @Read
	FROM [tblNotificationMessage] AS M INNER JOIN @MessageIDs AS IDS ON M.pkID = IDS.ID
END
GO
PRINT N'Creating Procedure [dbo].[EntityGetGuidByID]...';


GO
CREATE PROCEDURE dbo.EntityGetGuidByID
@intObjectTypeID int,
@intObjectID int
AS
BEGIN
	SELECT unqID FROM tblEntityGuid WHERE intObjectTypeID = @intObjectTypeID AND intObjectID = @intObjectID
END
GO
PRINT N'Creating Procedure [dbo].[netApprovalDefinitionAddVersion]...';


GO
CREATE PROCEDURE [dbo].[netApprovalDefinitionAddVersion](
	@ApprovalDefinitionKey NVARCHAR (255),
	@SavedBy NVARCHAR (255),
	@Saved DATETIME2,
	@RequireCommentOnApprove BIT,
	@RequireCommentOnReject BIT,
	@RequireCommentOnStart BIT,
	@ApprovesNeeded INT,
	@SelfApprove BIT,
	@IsEnabled BIT,
	@Steps [dbo].[AddApprovalDefinitionStepTable] READONLY,
	@Reviewers [dbo].[AddApprovalDefinitionReviewerTable] READONLY,
	@ApprovalDefinitionID INT OUT,
	@ApprovalDefinitionVersionID INT OUT)
AS
BEGIN
	SELECT @ApprovalDefinitionID = NULL, @ApprovalDefinitionVersionID = NULL

	-- Get or create an ApprovalDefinition for the ApprovalDefinitionKey
	SELECT @ApprovalDefinitionID = pkID FROM [dbo].[tblApprovalDefinition] WHERE ApprovalDefinitionKey = @ApprovalDefinitionKey
	IF (@ApprovalDefinitionID IS NULL)
	BEGIN
		DECLARE @DefinitionIDTable [dbo].[IDTable]
		INSERT INTO [dbo].[tblApprovalDefinition]([ApprovalDefinitionKey]) OUTPUT inserted.pkID INTO @DefinitionIDTable VALUES (@ApprovalDefinitionKey)
		SELECT @ApprovalDefinitionID = ID FROM @DefinitionIDTable
	END

	-- Add a new ApprovalDefinitionVersion to the definition
	DECLARE @VersionIDTable [dbo].[IDTable]
	INSERT INTO [dbo].[tblApprovalDefinitionVersion]([fkApprovalDefinitionID], [SavedBy], [Saved], [RequireCommentOnApprove], [RequireCommentOnReject], [RequireCommentOnStart], [ApprovesNeeded], [SelfApprove], [IsEnabled]) 
	OUTPUT inserted.pkID 
	INTO @VersionIDTable 
	VALUES (@ApprovalDefinitionID, @SavedBy, @Saved, @RequireCommentOnApprove, @RequireCommentOnReject, @RequireCommentOnStart, @ApprovesNeeded, @SelfApprove, @IsEnabled)
	SELECT @ApprovalDefinitionVersionID = ID FROM @VersionIDTable

	-- Update the current version in the definition
	UPDATE [dbo].[tblApprovalDefinition]
	SET [fkCurrentApprovalDefinitionVersionID] = @ApprovalDefinitionVersionID
	WHERE pkID = @ApprovalDefinitionID

	-- Add steps
	DECLARE @StepTable TABLE (ID INT, StepIndex INT)
	INSERT INTO [dbo].[tblApprovalDefinitionStep]([fkApprovalDefinitionVersionID], [StepIndex], [StepName], [ApprovesNeeded], [SelfApprove])
	OUTPUT inserted.pkID, inserted.StepIndex INTO @StepTable
	SELECT @ApprovalDefinitionVersionID, StepIndex, StepName, ApprovesNeeded, SelfApprove FROM @Steps
	
	-- Add reviewers
	INSERT INTO [dbo].[tblApprovalDefinitionReviewer]([fkApprovalDefinitionStepID], [fkApprovalDefinitionVersionID], [Username], [fkLanguageBranchID], [ReviewerType])
	SELECT step.ID, @ApprovalDefinitionVersionID, reviewer.Username, reviewer.fkLanguageBranchID, reviewer.ReviewerType FROM @Reviewers reviewer
	JOIN @StepTable step ON reviewer.StepIndex = step.StepIndex

	-- Cleanup unused versions
	DELETE adv FROM [dbo].[tblApprovalDefinition] ad
	JOIN [dbo].[tblApprovalDefinitionVersion] adv ON ad.pkID = adv.fkApprovalDefinitionID
	LEFT JOIN [dbo].[tblApproval] a ON a.fkApprovalDefinitionVersionID = adv.pkID
	WHERE ad.pkID = @ApprovalDefinitionID AND ad.fkCurrentApprovalDefinitionVersionID != adv.pkID AND a.pkID IS NULL
END
GO
PRINT N'Creating Procedure [dbo].[netNotificationMessageGet]...';


GO
CREATE PROCEDURE [dbo].[netNotificationMessageGet]
	@Id	INT
AS
BEGIN
	SELECT
		pkID AS ID, Recipient, Sender, Channel, [Type], [Subject], Content, Sent, SendAt, Saved, [Read], Category
	FROM
		[tblNotificationMessage]
	WHERE pkID = @Id
END
GO
PRINT N'Creating Procedure [dbo].[netMappedIdentityGetById]...';


GO
CREATE PROCEDURE [dbo].[netMappedIdentityGetById]
	@InternalIds dbo.ContentReferenceTable READONLY
AS
BEGIN
	SET NOCOUNT ON;

	SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider, MI.Metadata, MI.Saved
	FROM tblMappedIdentity AS MI 
	INNER JOIN @InternalIds AS EI ON (MI.pkID = EI.ID AND MI.Provider = EI.Provider)
	UNION (SELECT MI2.pkID AS ContentId, MI2.Provider, MI2.ProviderUniqueId, MI2.ContentGuid, MI2.ExistingContentId, MI2.ExistingCustomProvider, MI2.Metadata, MI2.Saved
		FROM tblMappedIdentity AS MI2
		INNER JOIN @InternalIds AS EI2 ON (MI2.ExistingContentId = EI2.ID)
		WHERE ((MI2.ExistingCustomProvider = 1 AND MI2.Provider = EI2.Provider) OR (MI2.ExistingCustomProvider IS NULL AND EI2.Provider IS NULL)))
	END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogGetAssociations]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogGetAssociations]
(
	@Id	BIGINT
)
AS            
BEGIN
		SELECT RelatedItem AS Uri
			FROM [tblActivityLog] 
			WHERE 
				@Id = pkID AND
				RelatedItem IS NOT NULL 
		UNION
		SELECT [From] AS Uri
			FROM [tblActivityLogAssociation] 
			WHERE 
				[To] = @Id AND
				[From] IS NOT NULL 
END
GO
PRINT N'Creating Procedure [dbo].[netActivityLogEntryDelete]...';


GO
CREATE PROCEDURE [dbo].[netActivityLogEntryDelete]
(
   @Id	BIGINT
)

AS            
BEGIN
		UPDATE 
			[tblActivityLog]
		SET 
			[Deleted] = 1 
		WHERE 
			[pkID] = @Id  AND [Deleted] = 0

		EXEC netActivityLogGetAssociations @Id
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationDequeueInt]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationDequeueInt]
    @connectionId uniqueidentifier,
    @maxItems int
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'Int'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        if (@processorStatus = 'valid')
        begin
            if exists (select 1 from tblChangeNotificationQueuedInt where ConnectionId = @connectionId)
            begin
                raiserror('A batch is already pending for the specified queue connection.', 16, 1)
            end

            declare @result table (Value int)

            insert into @result (Value)
            select top (@maxItems) Value
            from tblChangeNotificationQueuedInt
            where ProcessorId = @processorId
			  and ConnectionId is null
			order by QueueOrder

            update tblChangeNotificationQueuedInt
            set ConnectionId = @connectionId
            where ProcessorId = @processorId
              and Value in (select Value from @result)

            select Value from @result
        end

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationHeartBeat]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationHeartBeat]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction

        exec dbo.ChangeNotificationAccessConnectionWorker @connectionId

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationOpenConnection]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationOpenConnection]
    @processorId uniqueidentifier,
    @queuedDataType nvarchar(30),
    @processorName nvarchar(4000),
    @inactiveConnectionTimeoutSeconds int
as
begin
    declare @connectionId uniqueidentifier
    declare @processorStatus nvarchar(30)
    declare @configuredChangeNotificationDataType nvarchar(30)

    begin try
        begin transaction

        declare @utcnow datetime2 = SYSUTCDATETIME()

        select @processorStatus = ProcessorStatus, @configuredChangeNotificationDataType = ChangeNotificationDataType
        from tblChangeNotificationProcessor
        where ProcessorId = @processorId

        if (@processorStatus is null)
        begin
            -- the queue does not exist on the database yet. create and open with state invalid.
            set @processorStatus = 'invalid'

            insert into tblChangeNotificationProcessor (ProcessorId, ChangeNotificationDataType, ProcessorName, ProcessorStatus, NextQueueOrderValue)
            values (@processorId, @queuedDataType, @processorName, @processorStatus, 0)

            set @connectionId = NEWID()
            insert into tblChangeNotificationConnection (ProcessorId, ConnectionId, IsOpen, LastActivityDbUtc)
            values (@processorId, @connectionId, 1, @utcnow)
        end
        else if (@processorStatus = 'invalid' or exists (select 1
            from tblChangeNotificationConnection
            where ProcessorId = @processorId and LastActivityDbUtc < DATEADD(second, -@inactiveConnectionTimeoutSeconds, @utcnow)))
        begin
            -- the queue exists.  we can skip waiting for another running processor to confirm the state, since it is invalid anyways.
            exec ChangeNotificationSetInvalidWorker @processorId, @inactiveConnectionTimeoutSeconds

            set @connectionId = NEWID()
            insert into tblChangeNotificationConnection (ProcessorId, ConnectionId, IsOpen, LastActivityDbUtc)
            values (@processorId, @connectionId, 1, @utcnow)
        end
        else if (@queuedDataType = @configuredChangeNotificationDataType)
        begin
            set @connectionId = NEWID()
            declare @isOpen bit

            if exists (select 1 from tblChangeNotificationConnection where ProcessorId = @processorId)
            begin
                -- there are connections open, which may or may not still be running.
                -- leave the isOpen flag set to 0 as a request for a running process to confirm the queue status.
                set @isOpen = 0
            end
            else
            begin
                -- there are no connections to the queue. open with the current status intact.
                set @isOpen = 1
            end

            insert into tblChangeNotificationConnection (ProcessorId, ConnectionId, IsOpen, LastActivityDbUtc)
            values (@processorId, @connectionId, @isOpen, SYSUTCDATETIME())
        end
        else
        begin
            -- the processor exists with a different queued type. throw an exception.
            raiserror('The specified processor ID already exists with a different queued type.', 16, 1)
        end

        select c.ConnectionId, case when c.IsOpen = 0 then 'opening' else p.ProcessorStatus end as ProcessorStatus
        from tblChangeNotificationConnection c
        join tblChangeNotificationProcessor p on c.ProcessorId = p.ProcessorId
        where c.ConnectionId = @connectionId

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[netContentAclChildAdd]...';


GO
CREATE PROCEDURE dbo.netContentAclChildAdd
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID	INT,
	@AccessMask INT,
	@Merge BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON

	CREATE TABLE #ignorecontents(IgnoreContentID INT PRIMARY KEY)

	IF @Merge = 1
	BEGIN
		INSERT INTO #ignorecontents(IgnoreContentID)
		SELECT fkChildID
		FROM tblTree
		WHERE fkParentID=@ContentID AND NOT EXISTS(SELECT * FROM tblContentAccess WHERE fkContentID=tblTree.fkChildID)

		EXEC netContentAclChildDelete @Name=@Name, @IsRole=@IsRole, @ContentID=@ContentID
	END
        
    /* Create new ACEs for all childs to @ContentID */
	INSERT INTO tblContentAccess 
		(fkContentID, 
		Name,
		IsRole, 
		AccessMask) 
	SELECT 
		fkChildID, 
		@Name,
		@IsRole, 
		@AccessMask
	FROM 
		tblTree
	WHERE 
		fkParentID=@ContentID AND NOT EXISTS(SELECT * FROM #ignorecontents WHERE IgnoreContentID=tblTree.fkChildID)
        
END
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationCompleteBatchString]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationCompleteBatchString]
    @connectionId uniqueidentifier,
    @success bit
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'String'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            if (@success = 1)
            begin
                delete from tblChangeNotificationQueuedString
                where ConnectionId = @connectionId


                if not exists (select 1 from tblChangeNotificationQueuedString where ProcessorId = @processorId)
                begin
                    update tblChangeNotificationProcessor
                    set NextQueueOrderValue = 0, LastConsistentDbUtc = SYSUTCDATETIME()
                    where ProcessorId = @processorId
                end
            end
            else
            begin
                declare @queueOrder int
                update tblChangeNotificationProcessor
                set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1
                where ProcessorId = @processorId

                update tblChangeNotificationQueuedString
                set QueueOrder = @queueOrder, ConnectionId = null
                where ConnectionId = @connectionId
            end
        end

        commit transaction
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationCompleteBatchGuid]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationCompleteBatchGuid]
    @connectionId uniqueidentifier,
    @success bit
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'Guid'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        if (@processorStatus != 'invalid' and @processorStatus != 'closed')
        begin
            if (@success = 1)
            begin
                delete from tblChangeNotificationQueuedGuid
                where ConnectionId = @connectionId

                if not exists (select 1 from tblChangeNotificationQueuedGuid where ProcessorId = @processorId)
                begin
                    update tblChangeNotificationProcessor
                    set NextQueueOrderValue = 0, LastConsistentDbUtc = SYSUTCDATETIME()
                    where ProcessorId = @processorId
                end
            end
            else
            begin
                declare @queueOrder int
                update tblChangeNotificationProcessor
                set @queueOrder = NextQueueOrderValue = NextQueueOrderValue + 1
                where ProcessorId = @processorId

                update tblChangeNotificationQueuedGuid
                set QueueOrder = @queueOrder, ConnectionId = null
                where ConnectionId = @connectionId
            end
        end

        commit transaction
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
PRINT N'Creating Procedure [dbo].[ChangeNotificationDequeueGuid]...';


GO
CREATE PROCEDURE [dbo].[ChangeNotificationDequeueGuid]
    @connectionId uniqueidentifier,
    @maxItems int
as
begin
    begin try
        begin transaction

        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime2)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId, 'Guid'
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable

        if (@processorStatus = 'valid')
        begin
            if exists (select 1 from tblChangeNotificationQueuedGuid where ConnectionId = @connectionId)
            begin
                raiserror('A batch is already pending for the specified queue connection.', 16, 1)
            end

            declare @result table (Value uniqueidentifier)

            insert into @result (Value)
            select top (@maxItems) Value
            from tblChangeNotificationQueuedGuid
            where ProcessorId = @processorId
			  and ConnectionId is null
            order by QueueOrder

            update tblChangeNotificationQueuedGuid
            set ConnectionId = @connectionId
            where ProcessorId = @processorId
              and Value in (select Value from @result)

            select Value from @result
        end

        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()

        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
SET IDENTITY_INSERT tblLanguageBranch ON
GO
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(1, 'en               ', NULL, 10, '~/app_themes/default/images/flags/en.gif', NULL, 1)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(2, 'en-GB            ', NULL, 20, '~/app_themes/default/images/flags/en-gb.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(3, 'en-NZ            ', NULL, 30, '~/app_themes/Default/Images/flags/en-NZ.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(4, 'en-ZA            ', NULL, 40, '~/app_themes/default/images/flags/en-za.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(5, 'de               ', NULL, 50, '~/app_themes/Default/Images/flags/de.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(6, 'fr               ', NULL, 60, '~/app_themes/default/images/flags/fr.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(7, 'es               ', NULL, 70, '~/app_themes/default/images/flags/es.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(8, 'sv               ', NULL, 80, '~/app_themes/default/images/flags/sv.gif', NULL, 1)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(9, 'no               ', NULL, 90, '~/app_themes/default/images/flags/no.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(10, 'da               ', NULL, 100, '~/app_themes/default/images/flags/da.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(11, 'fi               ', NULL, 110, '~/app_themes/default/images/flags/fi.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(12, 'nl               ', NULL, 120, '~/app_themes/default/images/flags/nl.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(13, 'nl-BE            ', NULL, 130, '~/app_themes/default/images/flags/nl-be.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(14, 'pt-BR            ', NULL, 140, '~/app_themes/default/images/flags/pt-br.gif', NULL, 0)
INSERT INTO  tblLanguageBranch([pkID], [LanguageID], [Name], [SortIndex], [SystemIconPath], [URLSegment], [Enabled])
VALUES(15, '', NULL, 150, '', NULL, 0)
GO
SET IDENTITY_INSERT tblLanguageBranch OFF
GO

/************************************************************************/
SET IDENTITY_INSERT tblCategory ON
GO
INSERT INTO tblCategory (pkID,fkParentID,CategoryGUID,SortOrder,Available,Selectable,SuperCategory,CategoryName,CategoryDescription) VALUES (
1,
NULL,
'{885BD5B6-9F33-4615-8E85-6390072E824C}',
1,
0,
0,
0,
'Root',
'Starting point')
GO
SET IDENTITY_INSERT tblCategory OFF
GO

/************************************************************************/
SET IDENTITY_INSERT tblFrame ON
GO
INSERT INTO tblFrame (pkID,FrameName,FrameDescription,SystemFrame) VALUES (
1,
'target="_blank"',
'Open the link in a new window',
1)
GO
INSERT INTO tblFrame (pkID,FrameName,FrameDescription,SystemFrame) VALUES (
2,
'target="_top"',
'Open the link in the whole window',
1)
GO
SET IDENTITY_INSERT tblFrame OFF
GO

/************************************************************************/
SET IDENTITY_INSERT tblPropertyDefinitionGroup ON
GO
INSERT INTO tblPropertyDefinitionGroup (pkID,SystemGroup,Access,GroupVisible,GroupOrder,Name) VALUES (
0,
1,
1,
1,
10,
'Information')
GO
INSERT INTO tblPropertyDefinitionGroup (pkID,SystemGroup,Access,GroupVisible,GroupOrder,Name) VALUES (
1,
1,
4,
0,
30,
'Advanced')
GO
INSERT INTO tblPropertyDefinitionGroup (pkID,SystemGroup,Access,GroupVisible,GroupOrder,Name) VALUES (
2,
1,
1,
0,
50,
'Categories')
GO
INSERT INTO tblPropertyDefinitionGroup (pkID,SystemGroup,Access,GroupVisible,GroupOrder,Name) VALUES (
3,
1,
1,
0,
40,
'Shortcut')
GO
INSERT INTO tblPropertyDefinitionGroup (pkID,SystemGroup,Access,GroupVisible,GroupOrder,Name) VALUES (
4,
1,
1,
0,
20,
'Scheduling')
GO
INSERT INTO tblPropertyDefinitionGroup (pkID,SystemGroup,Access,GroupVisible,GroupOrder,Name) VALUES (
5,
1,
1,
0,
60,
'DynamicBlocks')
GO
SET IDENTITY_INSERT tblPropertyDefinitionGroup OFF
GO

/************************************************************************/
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
0,
0,
'Boolean',
NULL,
NULL,
'choice')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
1,
1,
'Number',
NULL,
NULL,
'number')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
2,
2,
'FloatNumber',
NULL,
NULL,
'number')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName,Hidden) VALUES (
3,
3,
'PageType',
NULL,
NULL,
'system',
1)
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName,Hidden) VALUES (
4,
4,
'PageReference',
NULL,
NULL,
'system',
1)
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
5,
5,
'Date',
NULL,
NULL,
'datetime')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
6,
6,
'String',
NULL,
NULL,
'text')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
7,
7,
'LongString',
NULL,
NULL,
'text')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
8,
8,
'Category',
NULL,
NULL,
'choice')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
11,
11,
'ContentReference',
NULL,
NULL,
'content')
GO
INSERT INTO tblPropertyDefinitionType (pkID,Property,Name,TypeName,AssemblyName,GroupName) VALUES (
12,
12,
'Block',
NULL,
NULL,
NULL)
GO

/************************************************************************/
SET IDENTITY_INSERT tblContentType ON
GO
INSERT INTO tblContentType (pkID,ContentTypeGUID,Created,Name,Description,IdString,Available,SortOrder,MetaDataInherit,MetaDataDefault,WorkflowEditFields,Base) VALUES (
1,
'{3FA7D9E7-877B-11D3-827C-00A024CACFCB}',
'19990101 00:00',
'SysRoot',
'Used as root/welcome page',
'?id=',
0,
10000,
0,
0,
0,
'Page')
GO
INSERT INTO tblContentType (pkID,ContentTypeGUID,Created,Name,Description,IdString,Available,SortOrder,MetaDataInherit,MetaDataDefault,WorkflowEditFields,Base) VALUES (
2,
'{4EEA90CD-4210-4115-A399-6D6915554E10}',
'19990101 00:00',
'SysRecycleBin',
'Used as recycle bin for the website',
'?id=',
0,
10010,
0,
0,
0,
'Page')
GO
INSERT INTO tblContentType (pkID,ContentTypeGUID,Created,ModelType,Name,Description,IdString,Available,SortOrder,MetaDataInherit,MetaDataDefault,WorkflowEditFields,ContentType,Base) VALUES (
3,
'{52F8D1E9-6D87-4DB6-A465-41890289FB78}',
'19990101 00:00',
'EPiServer.Core.ContentFolder,EPiServer',
'SysContentFolder',
'Used as content folder',
'?id=',
0,
10020,
0,
0,
0,
2,
'Folder')
GO
INSERT INTO tblContentType (pkID,ContentTypeGUID,Created,ModelType,Name,Description,IdString,Available,SortOrder,MetaDataInherit,MetaDataDefault,WorkflowEditFields,ContentType,Base) VALUES (
4,
'{E9AB78A3-1BBF-48ef-A8D4-1C1F98E80D91}',
'19990101 00:00',
'EPiServer.Core.ContentAssetFolder,EPiServer',
'SysContentAssetFolder',
'Used as a folder for content assets',
'?id=',
0,
10030,
0,
0,
0,
2,
'Folder')
GO
SET IDENTITY_INSERT tblContentType OFF
GO

/************************************************************************
Dependent data
************************************************************************/
SET IDENTITY_INSERT tblContent ON
GO
--SysRoot
INSERT INTO tblContent (pkID,fkContentTypeID,fkParentID,ArchiveContentGUID,CreatorName,ContentGUID,VisibleInMenu,Deleted,ChildOrderRule,PeerOrder, fkMasterLanguageBranchID,ContentPath, IsLeafNode, Created, Saved) VALUES (
1,--pkID
1,--fkContentTypeID
NULL,--fkParentID
NULL,--ArchiveContentGUID
'',--CreatorName
'{43F936C9-9B23-4EA3-97B2-61C538AD07C9}',--ContentGUID
1,--VisibleInMenu
0,--Deleted
4,--ChildOrderRule
100,--PeerOrder
1,--fkMasterLanguageBranchID
'.',--ContentPath
0,--IsLeafNode
'19990101 00:00',--Created
'19990101 00:00')--Saved
GO

--SysWastebasket
INSERT INTO tblContent (pkID,fkContentTypeID,fkParentID,ArchiveContentGUID,CreatorName,ContentGUID,VisibleInMenu,Deleted,ChildOrderRule,PeerOrder,fkMasterLanguageBranchID,ContentPath,Created,Saved) VALUES (
2,--pkID
2,--fkContentTypeID
1,--fkParentID
NULL,--ArchiveContentGUID
'',--CreatorName
'{2F40BA47-F4FC-47AE-A244-0B909D4CF988}',--ContentGUID
1,--VisibleInMenu
0,--Deleted
1,--ChildOrderRule
10,--PeerOrder
1,--fkMasterLanguageBranchID
'.1.',--ContentPath
'19990101 00:00',--Created
'19990101 00:00')--Saved
GO

--SysGlobalAssets
INSERT INTO tblContent (pkID,fkContentTypeID,fkParentID,ArchiveContentGUID,CreatorName,ContentGUID,VisibleInMenu,Deleted,ChildOrderRule,PeerOrder,fkMasterLanguageBranchID,ContentPath,ContentType,Created,Saved) VALUES (
3,--pkID
3,--fkContentTypeID
1,--fkParentID
NULL,--ArchiveContentGUID
'',--CreatorName
'{E56F85D0-E833-4E02-976A-2D11FE4D598C}',--ContentGUID
1,--VisibleInMenu
0,--Deleted
3,--ChildOrderRule
100,--PeerOrder
15,--fkMasterLanguageBranchID
'.1.',--ContentPath
2,--ContentType
'19990101 00:00',--Created
'19990101 00:00')--Saved
GO

--SysContentAssets
INSERT INTO tblContent (pkID,fkContentTypeID,fkParentID,ArchiveContentGUID,CreatorName,ContentGUID,VisibleInMenu,Deleted,ChildOrderRule,PeerOrder,fkMasterLanguageBranchID,ContentPath,ContentType,Created,Saved) VALUES (
4,--pkID
3,--fkContentTypeID
1,--fkParentID
NULL,--ArchiveContentGUID
'',--CreatorName
'{99D57529-61F2-47C0-80C0-F91ECA6AF1AC}',--ContentGUID
1,--VisibleInMenu
0,--Deleted
3,--ChildOrderRule
100,--PeerOrder
15,--fkMasterLanguageBranchID
'.1.',--ContentPath
2,--ContentType
'19990101 00:00',--Created
'19990101 00:00')--Saved
GO
SET IDENTITY_INSERT tblContent OFF
GO

--Root
DECLARE @fkPageId1 INT
INSERT INTO tblWorkContent (fkContentID ,fkMasterVersionID, ContentLinkGUID, fkFrameID, ArchiveContentGUID, ChangedByName, NewStatusByName, Name, URLSegment,LinkURL ,ExternalURL ,VisibleInMenu ,LinkType ,Created ,Saved ,StartPublish ,StopPublish ,ChildOrderRule ,PeerOrder ,ChangedOnPublish ,RejectComment ,fkLanguageBranchID, Status) VALUES (
1, --fkContentID
null, --,fkMasterVersionID
null, --,ContentLinkGUID
null,--,fkFrameID
null,--,ArchiveContentGUID
'', --,ChangedByName
null, --,NewStatusByName
'Root',--Name
null, --,URLSegment
'~/link/43F936C99B234EA397B261C538AD07C9.aspx',--LinkURL
null, --,ExternalURL
1, --,VisibleInMenu
0, --,LinkType
'19990101 00:00', --,Created
'19990101 00:00', --,Saved
'19990101 00:00', --,StartPublish
null, --,StopPublish
4, --,ChildOrderRule
100, --,PeerOrder
0, --,ChangedOnPublish
null,--,RejectComment
1,--,fkLanguageBranchID
4 --status
)
SET @fkPageId1=@@IDENTITY

--RecycleBin
DECLARE @fkPageId2 INT
INSERT INTO tblWorkContent (fkContentID ,fkMasterVersionID, ContentLinkGUID, fkFrameID, ArchiveContentGUID, ChangedByName, NewStatusByName, Name, URLSegment,LinkURL ,ExternalURL ,VisibleInMenu ,LinkType ,Created ,Saved ,StartPublish ,StopPublish ,ChildOrderRule ,PeerOrder ,ChangedOnPublish ,RejectComment ,fkLanguageBranchID, Status) VALUES (
2, --fkContentID
null, --,fkMasterVersionID
null, --,ContentLinkGUID
null,--,fkFrameID
null,--,ArchiveContentGUID
'', --,ChangedByName
null, --,NewStatusByName
'Recycle Bin',--Name
null, --,URLSegment
'~/link/2F40BA47F4FC47AEA2440B909D4CF988.aspx',--LinkURL
null, --,ExternalURL
1, --,VisibleInMenu
0, --,LinkType
'19990101 00:00', --,Created
'19990101 00:00', --,Saved
'19990101 00:00', --,StartPublish
null, --,StopPublish
1, --,ChildOrderRule
10, --,PeerOrder
0, --,ChangedOnPublish
null,--,RejectComment
1,--,fkLanguageBranchID
4 --Status
)
SET @fkPageId2=@@IDENTITY


DECLARE @fkPageId3 INT
INSERT INTO tblWorkContent (fkContentID ,fkMasterVersionID, ContentLinkGUID, fkFrameID, ArchiveContentGUID, ChangedByName, NewStatusByName, Name, URLSegment,LinkURL ,ExternalURL ,VisibleInMenu ,LinkType ,Created ,Saved ,StartPublish ,StopPublish ,ChildOrderRule ,PeerOrder ,ChangedOnPublish ,RejectComment ,fkLanguageBranchID, Status) VALUES (
3, --fkContentID
null, --,fkMasterVersionID
null, --,ContentLinkGUID
null,--,fkFrameID
null,--,ArchiveContentGUID
'', --,ChangedByName
null, --,NewStatusByName
'SysGlobalAssets',--Name
'SysGlobalAssets', --,URLSegment
null,--LinkURL
null, --,ExternalURL
1, --,VisibleInMenu
0, --,LinkType
'19990101 00:00', --,Created
'19990101 00:00', --,Saved
'19990101 00:00', --,StartPublish
null, --,StopPublish
3, --,ChildOrderRule
100, --,PeerOrder
0, --,ChangedOnPublish
null,--,RejectComment
15,--,fkLanguageBranchID
4 -- Status
)
SET @fkPageId3=@@IDENTITY

DECLARE @fkPageId4 INT
INSERT INTO tblWorkContent (fkContentID ,fkMasterVersionID, ContentLinkGUID, fkFrameID, ArchiveContentGUID, ChangedByName, NewStatusByName, Name, URLSegment,LinkURL ,ExternalURL ,VisibleInMenu ,LinkType ,Created ,Saved ,StartPublish ,StopPublish ,ChildOrderRule ,PeerOrder ,ChangedOnPublish ,RejectComment ,fkLanguageBranchID, Status) VALUES (
4, --fkContentID
null, --,fkMasterVersionID
null, --,ContentLinkGUID
null,--,fkFrameID
null,--,ArchiveContentGUID
'', --,ChangedByName
null, --,NewStatusByName
'SysContentAssets',--Name
'SysContentAssets', --,URLSegment
null,--LinkURL
null, --,ExternalURL
1, --,VisibleInMenu
0, --,LinkType
'19990101 00:00', --,Created
'19990101 00:00', --,Saved
'19990101 00:00', --,StartPublish
null, --,StopPublish
3, --,ChildOrderRule
100, --,PeerOrder
0, --,ChangedOnPublish
null,--,RejectComment
15,--,fkLanguageBranchID
4 --Status
)
SET @fkPageId4=@@IDENTITY

INSERT INTO tblContentLanguage (fkContentID,fkLanguageBranchID,ContentLinkGUID,fkFrameID,CreatorName,ChangedByName,ContentGUID,Name,LinkURL,ExternalURL,AutomaticLink,FetchData,Created,Changed,Saved,StartPublish,StopPublish,[Version], Status) VALUES (
1,--fkContentID
1,--fkLanguageBranchID
NULL,--ContentLinkGUID
NULL,--fkFrameID
'',--CreatorName
'',--ChangedByName
'{43F936C9-9B23-4EA3-97B2-61C538AD07C9}',--ContentGUID
'Root',--Name
'~/link/43F936C99B234EA397B261C538AD07C9.aspx',--LinkURL
NULL,--ExternalURL
1,--AutomaticLink
0,--FetchData
'19990101 00:00',--Created
'19990101 00:00',--Changed
'19990101 00:00',--Saved
'19990101 00:00',--StartPublish
NULL,--StopPublish
@fkPageId1,--Version
4 --Status
)

INSERT INTO tblContentLanguage (fkContentID,fkLanguageBranchID,ContentLinkGUID,fkFrameID,CreatorName,ChangedByName,ContentGUID,Name,URLSegment,LinkURL,ExternalURL,AutomaticLink,FetchData,Created,Changed,Saved,StartPublish,StopPublish,[Version], Status) VALUES (
2,--fkContentID
1,--fkLanguageBranchID
NULL,--ContentLinkGUID
NULL,--fkFrameID
'',--CreatorName
'',--ChangedByName
'{2F40BA47-F4FC-47AE-A244-0B909D4CF988}',--ContentGUID
'Recycle Bin',--Name
'Recycle-Bin',--URLSegment
'~/link/2F40BA47F4FC47AEA2440B909D4CF988.aspx',--LinkURL
NULL,--ExternalURL
1,--AutomaticLink
0,--FetchData
'19990101 00:00',--Created
'19990101 00:00',--Changed
'19990101 00:00',--Saved
'19990101 00:00',--StartPublish
NULL,--StopPublish
@fkPageId2,--Version
4 --Status
)

INSERT INTO tblContentLanguage (fkContentID,fkLanguageBranchID,ContentLinkGUID,fkFrameID,CreatorName,ChangedByName,ContentGUID,Name,URLSegment,LinkURL,ExternalURL,AutomaticLink,FetchData,Created,Changed,Saved,StartPublish,StopPublish,[Version], Status) VALUES (
3,--fkContentID
15,--fkLanguageBranchID
NULL,--ContentLinkGUID
NULL,--fkFrameID
'',--CreatorName
'',--ChangedByName
'{E56F85D0-E833-4E02-976A-2D11FE4D598C}',--ContentGUID
'SysGlobalAssets',--Name
'SysGlobalAssets',--URLSegment
null,--LinkURL
NULL,--ExternalURL
1,--AutomaticLink
0,--FetchData
'19990101 00:00',--Created
'19990101 00:00',--Changed
'19990101 00:00',--Saved
'19990101 00:00',--StartPublish
NULL,--StopPublish
@fkPageId3,--Version
4 --Status
)

INSERT INTO tblContentLanguage (fkContentID,fkLanguageBranchID,ContentLinkGUID,fkFrameID,CreatorName,ChangedByName,ContentGUID,Name,URLSegment,LinkURL,ExternalURL,AutomaticLink,FetchData,Created,Changed,Saved,StartPublish,StopPublish,[Version], Status) VALUES (
4,--fkContentID
15,--fkLanguageBranchID
NULL,--ContentLinkGUID
NULL,--fkFrameID
'',--CreatorName
'',--ChangedByName
'{99D57529-61F2-47C0-80C0-F91ECA6AF1AC}',--ContentGUID
'SysContentAssets',--Name
'SysContentAssets',--URLSegment
null,--LinkURL
NULL,--ExternalURL
1,--AutomaticLink
0,--FetchData
'19990101 00:00',--Created
'19990101 00:00',--Changed
'19990101 00:00',--Saved
'19990101 00:00',--StartPublish
NULL,--StopPublish
@fkPageId4,--Version
4 --Status
)
GO

/************************************************************************/
INSERT INTO tblUserPermission (Name, IsRole, GroupName, Permission) VALUES ('Administrators',1,'EPiServerCMS', 'DetailedErrorMessage')    /* DetailedErrorMessage */
GO

/************************************************************************/
INSERT INTO tblContentAccess (fkContentID,Name,IsRole,AccessMask) VALUES (1,'Everyone',1,1)
INSERT INTO tblContentAccess (fkContentID,Name,IsRole,AccessMask) VALUES (2,'Everyone',1,1)
INSERT INTO tblContentAccess (fkContentID,Name,IsRole,AccessMask) VALUES (1,'SearchIndexer',1,5)
GO

/************************************************************************/
INSERT INTO tblTree (fkParentID,fkChildID,NestingLevel) VALUES (1,2,1)
GO

INSERT INTO tblTree (fkParentID,fkChildID,NestingLevel) VALUES (1,3,1)
GO

INSERT INTO tblTree (fkParentID,fkChildID,NestingLevel) VALUES (1,4,1)
GO
