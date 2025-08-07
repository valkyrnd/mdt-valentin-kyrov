if schema_id('onb') is null
	exec('create schema onb')

if object_id('onb.Post') is null
begin
	create table onb.Post (
		ID int not null identity,
		Code varchar(255) not null,
		Name varchar(255) not null,
		MDT_ID_PrincipalCreatedBy int not null,
		MDT_DateCreate datetime not null,
		constraint PK_Post primary key clustered (ID)
	)
	alter table onb.Post add constraint UK_Post_Code unique (Code)
	alter table onb.Post add constraint DF_Post_MDT_ID_PrincipalCreatedBy default mdt.ID_User() for MDT_ID_PrincipalCreatedBy
	alter table onb.Post add constraint FK_Post_MDT_ID_PrincipalCreatedBy_Principal foreign key (MDT_ID_PrincipalCreatedBy) references mdt.Principal(ID)
	alter table onb.Post add constraint DF_Post_MDT_DateCreate default getdate() for MDT_DateCreate
end

if object_id('onb.Employee') is null
begin
    create table onb.Employee (
        ID int not null identity,
        Code as ('E' + cast(ID as varchar(20))) persisted, 
        FullName varchar(255) not null,                  
        DateBirth date not null,                           
        DateEmployment date null,                          
        DateDismissal date null,                                                   
        MDT_ID_PrincipalCreatedBy int not null,
        MDT_DateCreate datetime not null,
        constraint PK_Employee primary key clustered (ID)
    )
    alter table onb.Employee add constraint UK_Employee_Code unique (Code)
    alter table onb.Employee add constraint DF_Employee_MDT_ID_PrincipalCreatedBy default mdt.ID_User() for MDT_ID_PrincipalCreatedBy
    alter table onb.Employee add constraint FK_Employee_MDT_ID_PrincipalCreatedBy_Principal foreign key (MDT_ID_PrincipalCreatedBy) references mdt.Principal(ID)
    alter table onb.Employee add constraint DF_Employee_MDT_DateCreate default getdate() for MDT_DateCreate
end

if object_id('onb.Employee_Post') is null
begin
    create table onb.Employee_Post (
        ID int not null identity,
        ID_Employee int not null,     
        ID_Post int not null,          
        DateBegin date not null,       
        DateEnd date null,           
        MDT_ID_PrincipalCreatedBy int not null,
        MDT_DateCreate datetime not null,
        constraint PK_Employee_Post primary key clustered (ID),
        constraint FK_Employee_Post_Employee foreign key (ID_Employee) references onb.Employee(ID),
        constraint FK_Employee_Post_Post foreign key (ID_Post) references onb.Post(ID),
        constraint UK_Employee_Post_Employee_DateBegin unique (ID_Employee, DateBegin)
    )
    alter table onb.Employee_Post add constraint DF_Employee_Post_MDT_ID_PrincipalCreatedBy default mdt.ID_User() for MDT_ID_PrincipalCreatedBy
    alter table onb.Employee_Post add constraint FK_Employee_Post_MDT_ID_PrincipalCreatedBy_Principal foreign key (MDT_ID_PrincipalCreatedBy) references mdt.Principal(ID)
    alter table onb.Employee_Post add constraint DF_Employee_Post_MDT_DateCreate default getdate() for MDT_DateCreate
end


if object_id('onb.Statement') is null
begin
    create table onb.Statement (
        ID int not null identity,
        DateRegistration date not null,         -- Дата заявления
        ID_Employee int not null,               -- FK на onb.Employee
        Content varchar(max) null,              -- Текст заявления
        MDT_ID_PrincipalCreatedBy int not null,
        MDT_DateCreate datetime not null,
        constraint PK_Statement primary key clustered (ID),
        constraint FK_Statement_Employee foreign key (ID_Employee) references onb.Employee(ID)
    )
    alter table onb.Statement add constraint DF_Statement_MDT_ID_PrincipalCreatedBy default mdt.ID_User() for MDT_ID_PrincipalCreatedBy
    alter table onb.Statement add constraint FK_Statement_MDT_ID_PrincipalCreatedBy_Principal foreign key (MDT_ID_PrincipalCreatedBy) references mdt.Principal(ID)
    alter table onb.Statement add constraint DF_Statement_MDT_DateCreate default getdate() for MDT_DateCreate
end