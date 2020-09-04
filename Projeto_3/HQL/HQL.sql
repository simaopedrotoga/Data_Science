-- tables
-- Table: jira_dm_projects
create table bit.jira_dm_projects(
    project_ID int,
    project_key varchar(30),
    project_name varchar(30),
    project_URI varchar(100)
)
comment "Table for projects dimension"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_DM_PROJECTS';

-- Table: jira_dm_versions
create table bit.jira_dm_versions(
    version_ID int,
    version_name varchar(30),
    version_description varchar(100),
    version_URI varchar(100),
    archived varchar(100),
    released varchar(100),
    overdue varchar(100),
    version_time_start_date date,
    version_time_released_date date,
    version_time_classification varchar(30)
)
comment "Table for versions dimension"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_DM_VERSIONS';

-- Table: jira_dm_epics
create table bit.jira_dm_epics(
    epic_ID int,
    epic_key varchar(30),
    epic_summary varchar(30),
    epic_extended_summary varchar(100),
    epic_priority varchar(30),
    epic_status varchar(30),
    creator varchar(30),
    epic_URI varchar(100)
)
comment "Table for epics dimension"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_DM_EPICS';

-- Table: jira_dm_sprints
create table bit.jira_dm_sprints(
    sprint_ID int,
    sprint_name varchar(30),
    sprint_status varchar(30),
    sprint_URI varchar(100),
    sprint_time_start_date date,
    sprint_time_complete_date date,
    sprint_time_end_date date,
    sprint_time_classification varchar(30),
    sprint_time_overdue varchar(30)
)
comment "Table for sprints dimension"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_DM_SPRINTS';

-- Table: jira_dm_issues
create table bit.jira_dm_issues(
    issue_ID int,
    issue_key varchar(30),
    issue_summary varchar(100),
    issue_status varchar(30),
    issue_time_created_on date,
    issue_type varchar(30),
    task_type varchar(30),
    issue_priority varchar(30),
    issue_created_by varchar(30),
    issue_assigned_to varchar(30),
    issue_time_original_estimate float,
    issue_time_remaining_estimate float,
    issue_URI varchar(100),
    parent_key varchar(30),
    parent_type varchar(30),
    issue_time_overdue varchar(30)
)
comment "Table for issues dimension"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_DM_ISSUES';

-- Table: jira_dm_worklogs
create table bit.jira_dm_worklogs(
    worklog_ID int,
    worklog_URI varchar(100),
    worklog_author varchar(30),
    worklog_time_created_on date
)
comment "Table for worklogs dimension"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_DM_WORKLOGS';

-- Table: jira_dm_transitions
create table bit.jira_dm_transitions(
    transition_ID int,
    transition_author varchar(30),
    transition_time_date date,
    transition_type varchar(30),
    transition_from_status varchar(30),
    transition_to_status varchar(30)
)
comment "Table for transitions dimension"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_DM_TRANSITIONS';

-- Table: jira_fact_versions
create table bit.jira_fact_versions(
    version_ID int,
    project_ID int,
    version_time_duration_days int,
    version_quantity int
)
comment "Table for versions fact"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_FACT_VERSIONS';

-- Table: jira_fact_epics
CREATE TABLE bit.jira_fact_epics (
    epic_ID int,
    project_ID int,
    epic_quantity int
) 
comment "Table for epics fact"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_FACT_EPICS';

-- Table: jira_fact_sprints
create table bit.jira_fact_sprints(
    sprint_ID int,
    project_ID int,
    sprint_time_duration_days int,
    sprint_quantity int
)
comment "Table for sprints fact"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_FACT_SPRINTS';

-- Table: jira_fact_issues
create table bit.jira_fact_issues(
    issue_ID int,
    version_ID int,
    epic_ID int,
    project_ID int,
    issue_time_duration_hours float,
    issue_quantity int
)
comment "Table for issues fact"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_FACT_ISSUES';

-- Table: jira_fact_issues_sprints
CREATE TABLE bit.jira_fact_issues_sprints (
    issue_ID int,
    sprint_ID int,
    issue_sprint_quantity int
) 
comment "Table for issues and sprints fact"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_FACT_ISSUES_SPRINTS';

-- Table: jira_fact_worklogs
create table bit.jira_fact_worklogs(
    worklog_ID int,
    issue_ID int,
    project_ID int,
    worklog_time_duration_hours int,
    worklog_quantity int
)
comment "Table for worklogs fact"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_FACT_WORKLOGS';

-- Table: jira_fact_transitions
create table bit.jira_fact_transitions(
    transition_ID int,
    issue_ID int,
    project_ID int,
    transition_quantity int,
    transition_time_duration_days int
)
comment "Table for transitions fact"
row format delimited fields terminated by ';'
stored as textfile
location '/DATA/DW/WORKBENCH/BIT/JIRA/JIRA_FACT_TRANSITIONS';