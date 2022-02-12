
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 10/15/2020 04:18:20
-- Generated from EDMX file: C:\Users\thlal\source\repos\Login04\Models\Model1.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [Database1];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------


-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Services'
CREATE TABLE [dbo].[Services] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ServiceName] nvarchar(max)  NOT NULL,
    [ContactEmail] nvarchar(max)  NOT NULL,
    [ContactNumber] nvarchar(max)  NOT NULL,
    [ServiceDescription] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'CourseRatings'
CREATE TABLE [dbo].[CourseRatings] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [UserId] nvarchar(max)  NOT NULL,
    [Comment] nvarchar(max)  NOT NULL,
    [RateId] int  NOT NULL,
    [CourseId] int  NOT NULL
);
GO

-- Creating table 'Rates'
CREATE TABLE [dbo].[Rates] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Rating] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Enrolments'
CREATE TABLE [dbo].[Enrolments] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [EnrolDate] datetime  NOT NULL,
    [UserId] nvarchar(max)  NOT NULL,
    [UserEmail] nvarchar(max)  NOT NULL,
    [CourseId] int  NOT NULL
);
GO

-- Creating table 'States'
CREATE TABLE [dbo].[States] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Status] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Courses'
CREATE TABLE [dbo].[Courses] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CourseName] nvarchar(max)  NOT NULL,
    [ContactEmailForCourse] nvarchar(max)  NOT NULL,
    [ContactNumber] nvarchar(max)  NOT NULL,
    [CourseDescription] nvarchar(max)  NOT NULL,
    [StartDate] nvarchar(max)  NOT NULL,
    [EndDate] nvarchar(max)  NOT NULL,
    [ServiceId] int  NOT NULL,
    [StateId] int  NOT NULL
);
GO

-- Creating table 'Studios'
CREATE TABLE [dbo].[Studios] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [StudioName] nvarchar(max)  NOT NULL,
    [Location] nvarchar(max)  NOT NULL,
    [Latitude] nvarchar(max)  NOT NULL,
    [Longitude] nvarchar(max)  NOT NULL,
    [StartTime] time  NOT NULL,
    [FinishTime] time  NOT NULL,
    [StudioDescription] nvarchar(max)  NOT NULL,
    [CourseId] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'Services'
ALTER TABLE [dbo].[Services]
ADD CONSTRAINT [PK_Services]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CourseRatings'
ALTER TABLE [dbo].[CourseRatings]
ADD CONSTRAINT [PK_CourseRatings]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Rates'
ALTER TABLE [dbo].[Rates]
ADD CONSTRAINT [PK_Rates]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Enrolments'
ALTER TABLE [dbo].[Enrolments]
ADD CONSTRAINT [PK_Enrolments]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'States'
ALTER TABLE [dbo].[States]
ADD CONSTRAINT [PK_States]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Courses'
ALTER TABLE [dbo].[Courses]
ADD CONSTRAINT [PK_Courses]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Studios'
ALTER TABLE [dbo].[Studios]
ADD CONSTRAINT [PK_Studios]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [ServiceId] in table 'Courses'
ALTER TABLE [dbo].[Courses]
ADD CONSTRAINT [FK_ServiceCourse]
    FOREIGN KEY ([ServiceId])
    REFERENCES [dbo].[Services]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ServiceCourse'
CREATE INDEX [IX_FK_ServiceCourse]
ON [dbo].[Courses]
    ([ServiceId]);
GO

-- Creating foreign key on [StateId] in table 'Courses'
ALTER TABLE [dbo].[Courses]
ADD CONSTRAINT [FK_StateCourse]
    FOREIGN KEY ([StateId])
    REFERENCES [dbo].[States]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_StateCourse'
CREATE INDEX [IX_FK_StateCourse]
ON [dbo].[Courses]
    ([StateId]);
GO

-- Creating foreign key on [CourseId] in table 'Enrolments'
ALTER TABLE [dbo].[Enrolments]
ADD CONSTRAINT [FK_CourseEnrolment]
    FOREIGN KEY ([CourseId])
    REFERENCES [dbo].[Courses]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CourseEnrolment'
CREATE INDEX [IX_FK_CourseEnrolment]
ON [dbo].[Enrolments]
    ([CourseId]);
GO

-- Creating foreign key on [CourseId] in table 'Studios'
ALTER TABLE [dbo].[Studios]
ADD CONSTRAINT [FK_CourseStudio]
    FOREIGN KEY ([CourseId])
    REFERENCES [dbo].[Courses]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CourseStudio'
CREATE INDEX [IX_FK_CourseStudio]
ON [dbo].[Studios]
    ([CourseId]);
GO

-- Creating foreign key on [RateId] in table 'CourseRatings'
ALTER TABLE [dbo].[CourseRatings]
ADD CONSTRAINT [FK_RateCourseRating]
    FOREIGN KEY ([RateId])
    REFERENCES [dbo].[Rates]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_RateCourseRating'
CREATE INDEX [IX_FK_RateCourseRating]
ON [dbo].[CourseRatings]
    ([RateId]);
GO

-- Creating foreign key on [CourseId] in table 'CourseRatings'
ALTER TABLE [dbo].[CourseRatings]
ADD CONSTRAINT [FK_CourseCourseRating]
    FOREIGN KEY ([CourseId])
    REFERENCES [dbo].[Courses]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CourseCourseRating'
CREATE INDEX [IX_FK_CourseCourseRating]
ON [dbo].[CourseRatings]
    ([CourseId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------